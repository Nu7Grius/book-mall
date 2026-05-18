<template>
  <view class="cart-container">
    <!-- 购物车列表 -->
    <view class="cart-list" v-if="cartList.length > 0">
      <view
        class="cart-item"
        v-for="item in cartList"
        :key="item.id"
        @click="toggleSelect(item)"
      >
        <!-- 选择框 -->
        <view class="checkbox-wrapper" @click.stop="toggleSelect(item)">
          <view
            class="checkbox"
            :class="{ active: selectedIds.includes(item.id) }"
          >
            <text class="check-icon" v-if="selectedIds.includes(item.id)"
              >✓</text
            >
          </view>
        </view>

        <!-- 商品图片 -->
        <image
          class="book-cover"
          :src="getBookImage(item)"
          mode="aspectFill"
          @click.stop="goToDetail(item.bookId)"
        ></image>

        <!-- 商品信息 -->
        <view class="item-info">
          <text class="book-name" @click.stop="goToDetail(item.bookId)">{{
            item.bookName || (item.book && item.book.bookName) || "未知书名"
          }}</text>
          <text class="book-author">{{
            (item.book && item.book.author) || "未知作者"
          }}</text>
          <view class="price-row">
            <text class="price">¥{{ item.bookPrice || item.price || 0 }}</text>
            <view class="quantity-control">
              <view class="qty-btn" @click.stop="decreaseQty(item)">-</view>
              <input
                class="qty-input"
                type="number"
                :value="item.quantity"
                @change="updateQuantity(item, $event)"
              />
              <view class="qty-btn" @click.stop="increaseQty(item)">+</view>
            </view>
          </view>
        </view>

        <!-- 删除按钮 -->
        <view class="delete-btn" @click.stop="removeItem(item)">
          <text>删除</text>
        </view>
      </view>
    </view>

    <!-- 空购物车 -->
    <view class="empty-cart" v-else>
      <text class="empty-icon">🛒</text>
      <text class="empty-text">购物车是空的</text>
      <button class="btn-go-shopping" @click="goToHome">去逛逛</button>
    </view>

    <!-- 底部结算栏 -->
    <view class="bottom-bar" v-if="cartList.length > 0">
      <!-- 全选 -->
      <view class="select-all" @click="toggleSelectAll">
        <view class="checkbox" :class="{ active: isSelectAll }">
          <text class="check-icon" v-if="isSelectAll">✓</text>
        </view>
        <text class="label">全选</text>
      </view>

      <!-- 总价 -->
      <view class="total-section">
        <text class="total-label">合计：</text>
        <text class="total-price">¥{{ totalPrice }}</text>
      </view>

      <!-- 结算按钮 -->
      <button
        class="btn-settle"
        @click="goToSettle"
        :disabled="selectedIds.length === 0"
      >
        结算({{ selectedIds.length }})
      </button>
    </view>
  </view>
</template>

<script>
import { getCartList, updateCartItem, deleteCartItem } from "../../api/cart.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      cartList: [],
      selectedIds: [],
      loading: false,
      userId: null,
    };
  },
  computed: {
    totalPrice() {
      const selectedItems = this.cartList.filter((item) =>
        this.selectedIds.includes(item.id)
      );
      const total = selectedItems.reduce((sum, item) => {
        const price = parseFloat(item.bookPrice) || parseFloat(item.price) || 0;
        const qty = parseInt(item.quantity) || 0;
        return sum + price * qty;
      }, 0);
      return total.toFixed(2);
    },
    isSelectAll() {
      return (
        this.cartList.length > 0 &&
        this.selectedIds.length === this.cartList.length
      );
    },
  },
  onShow() {
    const userInfo = uni.getStorageSync("userInfo");
    if (!userInfo || !userInfo.id) {
      uni.showToast({
        title: "请先登录",
        icon: "none",
      });
      return;
    }
    this.userId = userInfo.id;
    this.loadCartList();
  },
  methods: {
    getBookImage(item) {
      if (item.coverImage) {
        return getImageUrl(item.coverImage);
      }
      if (item.bookCoverImage) {
        return getImageUrl(item.bookCoverImage);
      }
      return "/static/icons/book.png";
    },
    async loadCartList() {
      this.loading = true;
      try {
        const res = await getCartList();
        if (res.code === 200) {
          this.cartList = res.data || [];
        }
      } catch (error) {
        console.error("加载购物车失败:", error);
      } finally {
        this.loading = false;
      }
    },
    toggleSelect(item) {
      const index = this.selectedIds.indexOf(item.id);
      if (index > -1) {
        this.selectedIds.splice(index, 1);
      } else {
        this.selectedIds.push(item.id);
      }
    },
    toggleSelectAll() {
      if (this.isSelectAll) {
        this.selectedIds = [];
      } else {
        this.selectedIds = this.cartList.map((item) => item.id);
      }
    },
    async decreaseQty(item) {
      if (item.quantity > 1) {
        await this.updateItemQuantity(item, item.quantity - 1);
      }
    },
    async increaseQty(item) {
      if (item.stock && item.quantity < item.stock) {
        await this.updateItemQuantity(item, item.quantity + 1);
      } else if (!item.stock) {
        await this.updateItemQuantity(item, item.quantity + 1);
      }
    },
    async updateQuantity(item, e) {
      let val = parseInt(e.detail.value) || 1;
      if (val < 1) val = 1;
      if (item.stock && val > item.stock) val = item.stock;
      await this.updateItemQuantity(item, val);
    },
    async updateItemQuantity(item, quantity) {
      try {
        await updateCartItem({
          id: item.id,
          quantity: quantity,
        });
        item.quantity = quantity;
      } catch (error) {
        console.error("更新数量失败:", error);
      }
    },
    async removeItem(item) {
      const res = await new Promise((resolve) => {
        uni.showModal({
          title: "提示",
          content: "确定要删除该商品吗？",
          success: (modalRes) => {
            resolve(modalRes.confirm);
          },
        });
      });

      if (res) {
        try {
          await deleteCartItem(item.id);
          uni.showToast({
            title: "删除成功",
            icon: "success",
          });
          this.loadCartList();
        } catch (error) {
          console.error("删除失败:", error);
        }
      }
    },
    goToDetail(bookId) {
      uni.navigateTo({
        url: `/pages/book-detail/book-detail?id=${bookId}`,
      });
    },
    goToHome() {
      uni.switchTab({
        url: "/pages/home/home",
      });
    },
    goToSettle() {
      if (this.selectedIds.length === 0) {
        uni.showToast({
          title: "请选择商品",
          icon: "none",
        });
        return;
      }

      const selectedItems = this.cartList.filter((item) =>
        this.selectedIds.includes(item.id)
      );
      const orderData = {
        userId: this.userId,
        items: selectedItems.map((item) => ({
          bookId: item.bookId,
          bookName:
            item.bookName || (item.book && item.book.bookName) || "未知书名",
          coverImage:
            item.coverImage ||
            item.bookCoverImage ||
            (item.book && item.book.coverImage),
          price:
            item.price || item.bookPrice || (item.book && item.book.price) || 0,
          quantity: item.quantity,
        })),
        totalPrice: parseFloat(this.totalPrice),
        cartIds: this.selectedIds,
      };

      uni.navigateTo({
        url: `/pages/confirm-order/confirm-order?data=${encodeURIComponent(
          JSON.stringify(orderData)
        )}`,
      });
    },
  },
};
</script>

<style scoped>
.cart-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 120rpx;
}

.cart-list {
  padding: 20rpx;
}

.cart-item {
  display: flex;
  align-items: flex-start;
  background-color: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.checkbox-wrapper {
  padding-top: 60rpx;
  margin-right: 20rpx;
}

.checkbox {
  width: 40rpx;
  height: 40rpx;
  border: 2rpx solid #ddd;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.checkbox.active {
  background-color: #15803d;
  border-color: #15803d;
}

.check-icon {
  color: #fff;
  font-size: 24rpx;
}

.book-cover {
  width: 160rpx;
  height: 220rpx;
  border-radius: 12rpx;
  background-color: #f5f5f5;
  flex-shrink: 0;
}

.item-info {
  flex: 1;
  margin-left: 20rpx;
  display: flex;
  flex-direction: column;
}

.book-name {
  font-size: 28rpx;
  color: #333;
  font-weight: 500;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.book-author {
  font-size: 24rpx;
  color: #999;
  margin-top: 8rpx;
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
}

.price {
  font-size: 30rpx;
  color: #15803d;
  font-weight: bold;
}

.quantity-control {
  display: flex;
  align-items: center;
}

.qty-btn {
  width: 48rpx;
  height: 48rpx;
  background-color: #f5f5f5;
  border-radius: 8rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 28rpx;
}

.qty-input {
  width: 60rpx;
  height: 48rpx;
  background-color: #f5f5f5;
  margin: 0 8rpx;
  text-align: center;
  font-size: 26rpx;
}

.delete-btn {
  padding: 10rpx 20rpx;
  color: #15803d;
  font-size: 26rpx;
}

.empty-cart {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 200rpx 0;
}

.empty-icon {
  font-size: 120rpx;
  margin-bottom: 30rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
  margin-bottom: 40rpx;
}

.btn-go-shopping {
  width: 240rpx;
  height: 72rpx;
  background-color: #15803d;
  color: #fff;
  border-radius: 36rpx;
  font-size: 28rpx;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100rpx;
  background-color: #fff;
  display: flex;
  align-items: center;
  padding: 0 30rpx;
  box-shadow: 0 -2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.select-all {
  display: flex;
  align-items: center;
  margin-right: 30rpx;
}

.select-all .checkbox {
  margin-right: 16rpx;
}

.select-all .label {
  font-size: 28rpx;
  color: #333;
}

.total-section {
  flex: 1;
  text-align: right;
  margin-right: 20rpx;
}

.total-label {
  font-size: 28rpx;
  color: #333;
}

.total-price {
  font-size: 36rpx;
  color: #15803d;
  font-weight: bold;
}

.btn-settle {
  width: 200rpx;
  height: 72rpx;
  background-color: #15803d;
  color: #fff;
  border-radius: 36rpx;
  font-size: 28rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
}

.btn-settle[disabled] {
  background-color: #ccc;
}
</style>
