<template>
  <view class="confirm-order-container">
    <!-- 收货地址 -->
    <view class="section address-section" @click="selectAddress">
      <view class="address-content" v-if="selectedAddress">
        <view class="address-info">
          <view class="user-info">
            <text class="username">{{ selectedAddress.receiverName }}</text>
            <text class="phone">{{ selectedAddress.receiverPhone }}</text>
          </view>
          <view class="address-detail">
            {{ selectedAddress.province }} {{ selectedAddress.city }}
            {{ selectedAddress.district }} {{ selectedAddress.detailAddress }}
          </view>
        </view>
        <text class="arrow">></text>
      </view>
      <view class="no-address" v-else>
        <text>请选择收货地址</text>
        <text class="arrow">></text>
      </view>
    </view>

    <!-- 商品列表 -->
    <view class="section goods-section">
      <view class="goods-list">
        <view
          class="goods-item"
          v-for="item in orderData.items"
          :key="item.bookId"
        >
          <image
            class="goods-cover"
            :src="getItemImage(item)"
            mode="aspectFill"
          ></image>
          <view class="goods-info">
            <text class="goods-name">{{ item.bookName || "未知书名" }}</text>
            <view class="goods-bottom">
              <text class="goods-price">¥{{ formatPrice(item) }}</text>
              <text class="goods-quantity">x{{ item.quantity }}</text>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 订单信息 -->
    <view class="section order-info">
      <view class="info-item">
        <text class="label">商品金额</text>
        <text class="value">¥{{ formatTotalPrice }}</text>
      </view>
      <view class="info-item">
        <text class="label">运费</text>
        <text class="value">¥0.00</text>
      </view>
      <view class="info-item">
        <text class="label">备注</text>
        <input
          class="remark-input"
          v-model="remark"
          placeholder="选填，可备注特殊需求"
          placeholder-class="placeholder"
        />
      </view>
    </view>

    <!-- 底部结算栏 -->
    <view class="bottom-bar">
      <view class="total-section">
        <text class="total-label">合计：</text>
        <text class="total-price">¥{{ formatTotalPrice }}</text>
        <text class="payment-hint">微信支付</text>
      </view>
      <button class="btn-submit" @click="submitOrder" :loading="submitting">
        {{ submitting ? "提交中..." : "提交订单" }}
      </button>
    </view>
  </view>
</template>

<script>
import { createOrder } from "../../api/order.js";
import { getAddressList } from "../../api/address.js";
import { getImageUrl } from "../../utils/image.js";
import { deleteCartItem } from "../../api/cart.js";

export default {
  data() {
    return {
      orderData: {
        items: [],
        totalPrice: 0,
        cartIds: [],
      },
      selectedAddress: null,
      remark: "",
      submitting: false,
    };
  },
  computed: {
    formatTotalPrice() {
      if (this.orderData.totalPrice) {
        return parseFloat(this.orderData.totalPrice).toFixed(2);
      }
      if (this.orderData.items && this.orderData.items.length > 0) {
        const total = this.orderData.items.reduce((sum, item) => {
          const price =
            parseFloat(item.price) || parseFloat(item.bookPrice) || 0;
          const qty = parseInt(item.quantity) || 0;
          return sum + price * qty;
        }, 0);
        return total.toFixed(2);
      }
      return "0.00";
    },
  },
  onLoad(options) {
    if (options.data) {
      try {
        this.orderData = JSON.parse(decodeURIComponent(options.data));
        if (this.orderData.items) {
          this.orderData.items = this.orderData.items.map((item) => ({
            ...item,
            coverImage: item.coverImage
              ? getImageUrl(item.coverImage)
              : "/static/default-cover.png",
          }));
        }
      } catch (e) {
        console.error("解析订单数据失败:", e);
      }
    }
    this.loadDefaultAddress();
  },
  onShow() {
    const address = uni.getStorageSync("selectedAddress");
    if (address) {
      this.selectedAddress = address;
      uni.removeStorageSync("selectedAddress");
    }
  },
  methods: {
    getItemImage(item) {
      if (item.coverImage) {
        return getImageUrl(item.coverImage);
      }
      return "/static/default-cover.png";
    },
    formatPrice(item) {
      const price = item.price || item.bookPrice || 0;
      return parseFloat(price).toFixed(2);
    },
    async loadDefaultAddress() {
      const userInfo = uni.getStorageSync("userInfo");
      if (!userInfo || !userInfo.id) {
        return;
      }
      try {
        const res = await getAddressList(userInfo.id);
        if (res.code === 200 && res.data && res.data.length > 0) {
          const defaultAddress = res.data.find((item) => item.isDefault);
          this.selectedAddress = defaultAddress || res.data[0];
        }
      } catch (error) {
        console.error("加载地址失败:", error);
      }
    },
    selectAddress() {
      uni.navigateTo({
        url: "/pages/address-list/address-list?select=true",
      });
    },
    async submitOrder() {
      if (!this.selectedAddress) {
        uni.showToast({
          title: "请选择收货地址",
          icon: "none",
        });
        return;
      }

      this.submitting = true;
      try {
        const userInfo = uni.getStorageSync("userInfo");
        if (!userInfo || !userInfo.id) {
          uni.showToast({
            title: "请先登录",
            icon: "none",
          });
          this.submitting = false;
          return;
        }
        const orderItems = this.orderData.items.map((item) => ({
          bookId: item.bookId,
          quantity: item.quantity,
          price: item.price,
        }));

        const orderPayload = {
          userId: Number(userInfo.id),
          addressId: this.selectedAddress.id,
          totalPrice: this.orderData.totalPrice,
          remark: this.remark,
          items: orderItems,
        };

        const res = await createOrder(orderPayload);

        if (res.code === 200) {
          const orderId = res.data && res.data.id ? res.data.id : res.data;
          uni.setStorageSync("newOrderId", orderId);

          const cartIds = this.orderData.cartIds || [];
          if (cartIds.length > 0) {
            try {
              await Promise.all(cartIds.map((id) => deleteCartItem(id)));
            } catch (e) {
              console.warn("删除购物车商品失败:", e);
            }
          }

          uni.showToast({
            title: "订单提交成功",
            icon: "success",
          });

          setTimeout(() => {
            uni.redirectTo({
              url: `/pages/order-detail/order-detail?id=${orderId}`,
            });
          }, 1500);
        }
      } catch (error) {
        console.error("提交订单失败:", error);
      } finally {
        this.submitting = false;
      }
    },
  },
};
</script>

<style scoped>
.confirm-order-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 120rpx;
}

.section {
  background-color: #fff;
  margin-bottom: 20rpx;
}

.address-section {
  padding: 30rpx;
}

.address-content {
  display: flex;
  align-items: center;
}

.address-info {
  flex: 1;
}

.user-info {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;
}

.username {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-right: 20rpx;
}

.phone {
  font-size: 28rpx;
  color: #666;
}

.address-detail {
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
}

.arrow {
  font-size: 32rpx;
  color: #999;
  margin-left: 20rpx;
}

.no-address {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 28rpx;
  color: #15803d;
}

.goods-section {
  padding: 0;
}

.goods-list {
  padding: 20rpx 30rpx;
}

.goods-item {
  display: flex;
  padding: 20rpx 0;
  border-bottom: 1px solid #f5f5f5;
}

.goods-item:last-child {
  border-bottom: none;
}

.goods-cover {
  width: 160rpx;
  height: 220rpx;
  border-radius: 12rpx;
  background-color: #f5f5f5;
  flex-shrink: 0;
}

.goods-info {
  flex: 1;
  margin-left: 24rpx;
  display: flex;
  flex-direction: column;
  min-height: 200rpx;
}

.goods-name {
  font-size: 28rpx;
  color: #333;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.goods-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
  padding-top: 16rpx;
}

.goods-price {
  font-size: 30rpx;
  color: #15803d;
  font-weight: bold;
}

.goods-quantity {
  font-size: 26rpx;
  color: #999;
}

.order-info {
  padding: 30rpx;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
}

.info-item .label {
  font-size: 28rpx;
  color: #333;
}

.info-item .value {
  font-size: 28rpx;
  color: #15803d;
  font-weight: bold;
}

.remark-input {
  flex: 1;
  text-align: right;
  font-size: 28rpx;
  margin-left: 20rpx;
}

.placeholder {
  color: #999;
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

.total-section {
  flex: 1;
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

.payment-hint {
  display: inline-block;
  font-size: 22rpx;
  color: #999;
  margin-left: 16rpx;
  padding: 4rpx 12rpx;
  background: #f5f5f5;
  border-radius: 8rpx;
}

.btn-submit {
  width: 240rpx;
  height: 72rpx;
  background-color: #15803d;
  color: #fff;
  border-radius: 36rpx;
  font-size: 30rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
}
</style>
