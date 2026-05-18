<template>
  <view class="favorites-container">
    <!-- 搜索栏 -->
    <view class="search-bar">
      <view class="search-input">
        <text class="icon">🔍</text>
        <input
          v-model="searchKey"
          placeholder="搜索图书名称"
          @confirm="handleSearch"
          confirm-type="search"
        />
      </view>
      <text class="cancel-btn" v-if="searchKey" @click="clearSearch">取消</text>
    </view>

    <!-- 收藏列表 -->
    <view class="favorites-list" v-if="filteredFavorites.length > 0">
      <view
        class="favorite-item"
        v-for="item in filteredFavorites"
        :key="item.id"
      >
        <image
          class="book-cover"
          :src="item.coverImage || '/static/icons/book.png'"
          mode="aspectFill"
          @click="goToDetail(item.id)"
        ></image>

        <view class="book-info">
          <text class="book-name" @click="goToDetail(item.id)">{{
            item.bookName
          }}</text>
          <text class="book-author">{{ item.author || "未知作者" }}</text>
          <view class="book-bottom">
            <text class="book-price">¥{{ item.price }}</text>
            <button class="btn-add-cart" @click="addToCart(item)">
              加入购物车
            </button>
          </view>
        </view>

        <view class="delete-btn" @click="removeFavorite(item)">
          <text>取消收藏</text>
        </view>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else-if="!loading">
      <text class="empty-icon">❤️</text>
      <text class="empty-text">{{
        searchKey ? "未找到匹配的图书" : "暂无收藏"
      }}</text>
      <button
        class="btn-go-browse"
        @click="searchKey ? clearSearch() : goToHome()"
      >
        {{ searchKey ? "清除搜索" : "去逛逛" }}
      </button>
    </view>

    <!-- 加载状态 -->
    <view class="loading-more" v-if="loading">
      <text>加载中...</text>
    </view>
  </view>
</template>

<script>
import { getFavoriteList, removeFavorite } from "../../api/favorite.js";
import { addToCart as addToCartApi } from "../../api/cart.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      favoritesList: [],
      loading: false,
      userId: null,
      searchKey: "",
    };
  },
  computed: {
    filteredFavorites() {
      if (!this.searchKey) {
        return this.favoritesList;
      }
      const keyword = this.searchKey.toLowerCase().trim();
      return this.favoritesList.filter(
        (item) =>
          (item.bookName || "").toLowerCase().includes(keyword) ||
          (item.author || "").toLowerCase().includes(keyword)
      );
    },
  },
  onLoad() {
    const userInfo = uni.getStorageSync("userInfo");
    if (!userInfo || !userInfo.id) {
      uni.showToast({
        title: "请先登录",
        icon: "none",
      });
      return;
    }
    this.userId = userInfo.id;
    this.loadFavorites();
  },
  onShow() {
    const userInfo = uni.getStorageSync("userInfo");
    if (userInfo && userInfo.id) {
      this.userId = userInfo.id;
      this.loadFavorites();
    }
  },
  methods: {
    handleSearch() {
      // 前端筛选由 computed 属性自动处理
    },
    clearSearch() {
      this.searchKey = "";
    },
    async loadFavorites() {
      if (!this.userId) return;
      this.loading = true;
      try {
        const res = await getFavoriteList(this.userId);
        if (res.code === 200) {
          this.favoritesList = (res.data || []).map((item) => ({
            ...item,
            coverImage: item.coverImage
              ? getImageUrl(item.coverImage)
              : "/static/default-cover.png",
          }));
        }
      } catch (error) {
        console.error("加载收藏列表失败:", error);
      } finally {
        this.loading = false;
      }
    },
    goToDetail(bookId) {
      uni.navigateTo({
        url: `/pages/book-detail/book-detail?id=${bookId}`,
      });
    },
    async removeFavorite(item) {
      const res = await new Promise((resolve) => {
        uni.showModal({
          title: "提示",
          content: "确定要取消收藏该图书吗？",
          success: (modalRes) => {
            resolve(modalRes.confirm);
          },
        });
      });

      if (res) {
        try {
          await removeFavorite({ userId: this.userId, bookId: item.id });
          uni.showToast({
            title: "已取消收藏",
            icon: "success",
          });
          this.loadFavorites();
        } catch (error) {
          console.error("取消收藏失败:", error);
        }
      }
    },
    async addToCart(item) {
      const userInfo = uni.getStorageSync("userInfo");
      if (!userInfo || !userInfo.id) {
        uni.showToast({
          title: "请先登录",
          icon: "none",
        });
        return;
      }
      try {
        await addToCartApi({
          userId: userInfo.id,
          bookId: item.id,
          quantity: 1,
        });
        uni.showToast({
          title: "加入购物车成功",
          icon: "success",
        });
      } catch (error) {
        console.error("加入购物车失败:", error);
      }
    },
    goToHome() {
      uni.switchTab({
        url: "/pages/home/home",
      });
    },
  },
};
</script>
<style scoped>
.favorites-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-top: 0;
}

/* 搜索栏 */
.search-bar {
  display: flex;
  align-items: center;
  padding: 20rpx 30rpx;
  background-color: #fff;
  border-bottom: 1rpx solid #f0f0f0;
}

.search-input {
  flex: 1;
  display: flex;
  align-items: center;
  height: 64rpx;
  background-color: #f5f5f5;
  border-radius: 32rpx;
  padding: 0 24rpx;
}

.search-input .icon {
  font-size: 26rpx;
  margin-right: 12rpx;
}

.search-input input {
  flex: 1;
  font-size: 26rpx;
}

.cancel-btn {
  font-size: 28rpx;
  color: #15803d;
  margin-left: 20rpx;
}

/* 收藏列表 */
.favorites-list {
  display: flex;
  flex-direction: column;
  padding: 20rpx;
}

.favorite-item {
  display: flex;
  background-color: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.book-cover {
  width: 160rpx;
  height: 220rpx;
  border-radius: 12rpx;
  background-color: #f5f5f5;
  flex-shrink: 0;
}

.book-info {
  flex: 1;
  margin-left: 24rpx;
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

.book-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
  padding-top: 16rpx;
}

.book-price {
  font-size: 30rpx;
  color: #15803d;
  font-weight: bold;
}

.btn-add-cart {
  height: 56rpx;
  line-height: 56rpx;
  background-color: #15803d;
  color: #fff;
  border-radius: 28rpx;
  font-size: 24rpx;
  padding: 0 24rpx;
  border: none;
}

.delete-btn {
  padding: 10rpx 20rpx;
  color: #15803d;
  font-size: 26rpx;
  align-self: flex-start;
}

.empty-state {
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

.btn-go-browse {
  width: 240rpx;
  height: 72rpx;
  background-color: #15803d;
  color: #fff;
  border-radius: 36rpx;
  font-size: 28rpx;
}

.loading-more {
  text-align: center;
  padding: 30rpx;
  font-size: 26rpx;
  color: #999;
}
</style>
