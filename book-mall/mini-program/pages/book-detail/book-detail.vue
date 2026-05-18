<template>
  <view class="book-detail-container">
    <!-- 封面图 -->
    <swiper class="cover-swiper" indicator-dots circular>
      <swiper-item v-for="(img, index) in bookImages" :key="index">
        <image class="cover-image" :src="img" mode="aspectFit"></image>
      </swiper-item>
    </swiper>

    <!-- 价格和基本信息 -->
    <view class="book-base-info">
      <view class="price-row">
        <text class="price">¥{{ book.price }}</text>
        <text class="original-price" v-if="book.originalPrice"
          >¥{{ book.originalPrice }}</text
        >
      </view>
      <view class="book-title">{{ book.bookName }}</view>
      <view class="book-meta">
        <text class="author">{{ book.author }}</text>
        <text class="publisher" v-if="book.publisher">
          | {{ book.publisher }}</text
        >
      </view>
      <view class="book-info-row">
        <view class="book-stats">
          <text class="stat-item">销量 {{ book.sales || 0 }}</text>
        </view>
        <view
          class="merchant-section"
          v-if="book.merchantName || book.shopName"
        >
          <view class="merchant-avatar">
            <image
              v-if="book.merchantAvatar"
              :src="getImageUrl(book.merchantAvatar)"
              mode="aspectFill"
            ></image>
            <text v-else class="avatar-placeholder">🏪</text>
          </view>
          <view class="merchant-info">
            <text
              class="merchant-type-tag"
              :class="{
                'badge-flagship': book.shopType === '旗舰',
                'badge-third': book.shopType === '第三方',
                'badge-self': !book.shopType || book.shopType === '自营',
              }"
              >{{ book.shopType || "自营" }}</text
            >
            <text class="merchant-name">{{
              book.shopName || book.merchantName
            }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 服务保障 -->
    <view class="services-section">
      <view class="service-item">
        <text class="service-icon">✓</text>
        <text class="service-text">正品保障</text>
      </view>
      <view class="service-item">
        <text class="service-icon">✓</text>
        <text class="service-text">假一赔三</text>
      </view>
      <view class="service-item">
        <text class="service-icon">✓</text>
        <text class="service-text">免运费</text>
      </view>
      <view class="service-item">
        <text class="service-icon">✓</text>
        <text class="service-text">48小时发货</text>
      </view>
      <view class="service-item">
        <text class="service-icon">✓</text>
        <text class="service-text">7天无理由退换</text>
      </view>
    </view>

    <!-- 出版信息 -->
    <view class="meta-section">
      <view class="meta-row" v-if="book.publishDate">
        <text class="meta-label">出版时间：</text>
        <text class="meta-value">{{ formatDate(book.publishDate) }}</text>
      </view>
      <view class="meta-row" v-if="book.createTime">
        <text class="meta-label">上架时间：</text>
        <text class="meta-value">{{ formatDate(book.createTime) }}</text>
      </view>
    </view>

    <!-- 数量选择 -->
    <view class="quantity-section">
      <text class="section-title">数量</text>
      <view class="quantity-control">
        <view class="qty-btn" @click="decreaseQty">-</view>
        <input
          class="qty-input"
          type="number"
          v-model="quantity"
          @change="onQuantityChange"
        />
        <view class="qty-btn" @click="increaseQty">+</view>
      </view>
    </view>

    <!-- 简介 -->
    <view class="description-section">
      <view class="section-title">图书简介</view>
      <view class="description-content">
        <view
          class="desc-line"
          v-for="(line, index) in getDescriptionLines(book.description)"
          :key="index"
        >
          {{ line }}
        </view>
      </view>
    </view>

    <!-- 目录 -->
    <view class="catalog-section" v-if="book.catalog">
      <view class="section-title">目录</view>
      <view class="catalog-content">
        <view
          class="desc-line"
          v-for="(line, index) in getDescriptionLines(book.catalog)"
          :key="index"
        >
          {{ line }}
        </view>
      </view>
    </view>

    <!-- 评论列表 -->
    <view class="comment-section">
      <view class="section-header">
        <text class="section-title">商品评价 ({{ commentTotal }})</text>
        <text class="more-btn" @click="goToCommentList">查看更多 ></text>
      </view>
      <view class="comment-list" v-if="commentList.length > 0">
        <view class="comment-item" v-for="item in commentList" :key="item.id">
          <view class="comment-header">
            <image
              class="avatar"
              :src="item.userAvatar || '/static/icons/user.png'"
              mode="aspectFill"
            ></image>
            <view class="user-info">
              <text class="username">{{ item.userName || "匿名用户" }}</text>
              <view class="rating">
                <text class="star" :class="{ active: 1 <= item.rating }"
                  >★</text
                >
                <text class="star" :class="{ active: 2 <= item.rating }"
                  >★</text
                >
                <text class="star" :class="{ active: 3 <= item.rating }"
                  >★</text
                >
                <text class="star" :class="{ active: 4 <= item.rating }"
                  >★</text
                >
                <text class="star" :class="{ active: 5 <= item.rating }"
                  >★</text
                >
              </view>
            </view>
            <text class="comment-time">{{ formatTime(item.createTime) }}</text>
          </view>
          <view class="comment-content">{{
            formatRichText(item.content)
          }}</view>
          <!-- 商家回复 -->
          <view class="merchant-reply" v-if="item.replyContent">
            <view class="reply-header">
              <text class="reply-icon">🏪</text>
              <text class="reply-label">{{
                item.replyRole === "admin" ? "官方回复" : "商家回复"
              }}</text>
              <text class="reply-time" v-if="item.replyTime">{{
                formatTime(item.replyTime)
              }}</text>
            </view>
            <view class="reply-content">{{
              formatRichText(item.replyContent)
            }}</view>
          </view>
        </view>
      </view>
      <view class="empty-comment" v-else>
        <text>暂无评论</text>
      </view>
    </view>

    <!-- 底部操作栏 -->
    <view class="bottom-bar">
      <view class="action-icons">
        <view class="action-item" @click="toggleFavorite">
          <text class="icon">{{ isFavorite ? "❤️" : "🤍" }}</text>
          <text class="label">收藏</text>
        </view>
        <view class="action-item" @click="goToCart">
          <text class="icon">🛒</text>
          <text class="label">购物车</text>
        </view>
      </view>
      <view class="action-buttons">
        <button class="btn-add-cart" @click="addToCart">加入购物车</button>
        <button class="btn-buy-now" @click="buyNow">立即购买</button>
      </view>
    </view>
  </view>
</template>

<script>
import { getBookDetail, getBookComments } from "../../api/book.js";
import { addToCart as addToCartApi } from "../../api/cart.js";
import {
  addFavorite,
  removeFavorite,
  checkFavorite,
} from "../../api/favorite.js";
import { formatRichText } from "../../utils/format.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      bookId: null,
      userId: null,
      book: {},
      bookImages: [],
      quantity: 1,
      commentList: [],
      commentTotal: 0,
      isFavorite: false,
    };
  },
  onLoad(options) {
    if (options.id) {
      this.bookId = options.id;
      const userInfo = uni.getStorageSync("userInfo");
      if (userInfo && userInfo.id) {
        this.userId = userInfo.id;
      }
      this.loadBookDetail();
      this.loadComments();
      this.checkFavoriteStatus();
    }
  },
  onShareAppMessage(res) {
    const bookName = this.book.bookName || "精彩图书";
    const price = this.book.price || 0;
    return {
      title: `${bookName} - ¥${price}`,
      path: `/pages/book-detail/book-detail?id=${this.bookId}`,
      imageUrl: this.book.coverImage
        ? this.getImageUrl(this.book.coverImage)
        : "/static/icons/book.png",
    };
  },
  methods: {
    formatRichText,
    getImageUrl(path) {
      if (!path) return "/static/icons/book.png";
      if (path.startsWith("http")) return path;
      return (
        "http://localhost:8080" + (path.startsWith("/") ? path : "/" + path)
      );
    },
    formatDate(dateStr) {
      if (!dateStr) return "未知";
      const date = new Date(dateStr);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      return `${year}-${month}-${day}`;
    },
    getShopTypeTagClass(shopType) {
      if (!shopType) return "badge-self";

      const type = String(shopType).trim();

      if (type.includes("旗舰") || type === "flagship") {
        return "badge-flagship";
      } else if (type.includes("第三方") || type === "third_party") {
        return "badge-third";
      } else if (type.includes("自营") || type === "self") {
        return "badge-self";
      }

      return "badge-self";
    },
    getDescriptionLines(text) {
      if (!text) return ["暂无简介"];
      const formatted = formatRichText(text);
      const lines = formatted.split("\n").filter((line) => line.trim());
      if (lines.length === 0) return ["暂无简介"];
      return lines;
    },
    formatDescriptionText(text) {
      if (!text) return "暂无简介";
      return formatRichText(text);
    },
    async loadBookDetail() {
      try {
        const res = await getBookDetail(this.bookId);
        if (res.code === 200) {
          this.book = res.data;
          this.bookImages =
            this.book.images && this.book.images.length > 0
              ? this.book.images
              : [this.book.coverImage || "/static/icons/book.png"];
        }
      } catch (error) {
        console.error("加载图书详情失败:", error);
      }
    },
    async loadComments() {
      try {
        const res = await getBookComments(this.bookId);
        if (res.code === 200) {
          this.commentList = (res.data || []).map((comment) => ({
            ...comment,
            userAvatar: comment.userAvatar
              ? getImageUrl(comment.userAvatar)
              : "/static/icons/user.png",
          }));
          this.commentTotal = (res.data && res.data.length) || 0;
        }
      } catch (error) {
        console.error("加载评论失败:", error);
      }
    },
    async checkFavoriteStatus() {
      if (!this.userId || !this.bookId) return;
      try {
        const res = await checkFavorite(this.userId, this.bookId);
        if (res.code === 200) {
          this.isFavorite = res.data;
        }
      } catch (error) {
        console.error("检查收藏状态失败:", error);
      }
    },
    async toggleFavorite() {
      if (!this.userId) {
        uni.showToast({ title: "请先登录", icon: "none" });
        return;
      }
      try {
        if (this.isFavorite) {
          await removeFavorite(this.userId, this.bookId);
        } else {
          await addFavorite({ userId: this.userId, bookId: this.bookId });
        }
        this.isFavorite = !this.isFavorite;
        uni.showToast({
          title: this.isFavorite ? "收藏成功" : "取消收藏",
          icon: "success",
        });
      } catch (error) {
        console.error("操作收藏失败:", error);
      }
    },
    decreaseQty() {
      if (this.quantity > 1) {
        this.quantity--;
      }
    },
    increaseQty() {
      if (this.quantity < this.book.stock) {
        this.quantity++;
      } else {
        uni.showToast({
          title: "已达库存上限",
          icon: "none",
        });
      }
    },
    onQuantityChange(e) {
      let val = parseInt(e.detail.value) || 1;
      if (val < 1) val = 1;
      if (val > this.book.stock) val = this.book.stock;
      this.quantity = val;
    },
    async addToCart() {
      if (!this.userId) {
        uni.showToast({ title: "请先登录", icon: "none" });
        return;
      }
      try {
        await addToCartApi({
          userId: this.userId,
          bookId: this.bookId,
          quantity: this.quantity,
        });
        uni.showToast({
          title: "加入购物车成功",
          icon: "success",
        });
      } catch (error) {
        console.error("加入购物车失败:", error);
        uni.showToast({
          title: "加入购物车失败",
          icon: "none",
        });
      }
    },
    buyNow() {
      const orderData = {
        items: [
          {
            bookId: this.bookId,
            bookName: this.book.bookName,
            coverImage: this.book.coverImage,
            price: this.book.price,
            quantity: this.quantity,
          },
        ],
        totalPrice: this.book.price * this.quantity,
      };
      uni.navigateTo({
        url: `/pages/confirm-order/confirm-order?data=${encodeURIComponent(
          JSON.stringify(orderData)
        )}`,
      });
    },
    goToCart() {
      uni.switchTab({
        url: "/pages/cart/cart",
      });
    },
    goToCommentList() {
      uni.navigateTo({
        url: `/subpkg/comment-list/comment-list?bookId=${this.bookId}`,
      });
    },
    formatTime(time) {
      if (!time) return "";
      const date = new Date(time);
      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(
        2,
        "0"
      )}-${String(date.getDate()).padStart(2, "0")}`;
    },
  },
};
</script>

<style scoped>
.book-detail-container {
  min-height: 100vh;
  padding-bottom: 120rpx;
  background-color: #f5f5f5;
}

.cover-swiper {
  height: 600rpx;
  background-color: #fff;
}

.cover-image {
  width: 100%;
  height: 100%;
}

.merchant-avatar image {
  width: 100%;
  height: 100%;
}

.avatar-placeholder {
  font-size: 32rpx;
}

.badge-self {
  background: linear-gradient(135deg, #e6a23c 0%, #f56c6c 100%);
}

.badge-flagship {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
}

.badge-third {
  background: linear-gradient(135deg, #909399 0%, #606266 100%);
}

.merchant-name {
  font-size: 26rpx;
  color: #333;
  font-weight: 500;
}

/* 服务保障 */
.services-section {
  background-color: #fff;
  padding: 24rpx 30rpx;
  margin-top: 20rpx;
  display: flex;
  flex-wrap: wrap;
}

.service-item {
  display: flex;
  align-items: center;
  margin-right: 24rpx;
  margin-bottom: 12rpx;
}

.service-icon {
  font-size: 24rpx;
  color: #16a34a;
  margin-right: 6rpx;
}

.service-text {
  font-size: 24rpx;
  color: #666;
}

/* 出版信息 */
.meta-section {
  background-color: #fff;
  padding: 24rpx 30rpx;
  margin-top: 20rpx;
}

.meta-row {
  display: flex;
  font-size: 26rpx;
  line-height: 2;
}

.meta-label {
  color: #999;
  width: 140rpx;
}

.meta-value {
  color: #666;
  flex: 1;
}

.book-base-info {
  background-color: #fff;
  padding: 30rpx;
}

.price-row {
  display: flex;
  align-items: baseline;
  margin-bottom: 20rpx;
}

.price {
  font-size: 48rpx;
  color: #15803d;
  font-weight: bold;
}

.original-price {
  font-size: 28rpx;
  color: #999;
  text-decoration: line-through;
  margin-left: 20rpx;
}

.book-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 16rpx;
}

.book-meta {
  display: flex;
  flex-wrap: wrap;
  font-size: 26rpx;
  color: #666;
  margin-bottom: 16rpx;
}

.book-meta text {
  margin-right: 30rpx;
}

.book-info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  min-height: 64rpx;
}

.book-stats {
  display: flex;
  font-size: 24rpx;
  color: #999;
}

.stat-item {
  margin-right: 30rpx;
}

.merchant-section {
  display: flex;
  align-items: center;
}

.merchant-avatar {
  width: 48rpx;
  height: 48rpx;
  border-radius: 50%;
  background-color: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  margin-right: 16rpx;
  flex-shrink: 0;
}

.merchant-type-tag {
  font-size: 20rpx;
  padding: 4rpx 12rpx;
  color: #fff;
  border-radius: 6rpx;
  margin-right: 16rpx;
  font-weight: 600;
  flex-shrink: 0;
}

.quantity-section {
  background-color: #fff;
  padding: 30rpx;
  margin-top: 20rpx;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.section-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
}

.quantity-control {
  display: flex;
  align-items: center;
}

.qty-btn {
  width: 60rpx;
  height: 60rpx;
  background-color: #f5f5f5;
  border-radius: 8rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 32rpx;
}

.qty-input {
  width: 80rpx;
  height: 60rpx;
  background-color: #f5f5f5;
  margin: 0 16rpx;
  text-align: center;
  font-size: 28rpx;
}

.description-section,
.catalog-section {
  background-color: #fff;
  padding: 30rpx;
  margin-top: 20rpx;
}

.description-content,
.catalog-content {
  font-size: 28rpx;
  color: #666;
  line-height: 1.8;
  margin-top: 20rpx;
}

.desc-line {
  margin-bottom: 24rpx;
  line-height: 1.8;
  color: #333;
}

.comment-section {
  background-color: #fff;
  padding: 30rpx;
  margin-top: 20rpx;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.more-btn {
  font-size: 26rpx;
  color: #999;
}

.comment-list {
  display: flex;
  flex-direction: column;
}

.comment-item {
  padding: 24rpx 0;
  border-bottom: 1px solid #f5f5f5;
}

.comment-item:last-child {
  border-bottom: none;
}

.comment-header {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;
}

.avatar {
  width: 64rpx;
  height: 64rpx;
  border-radius: 32rpx;
  background-color: #f5f5f5;
  margin-right: 16rpx;
}

.user-info {
  flex: 1;
}

.username {
  font-size: 28rpx;
  color: #333;
  font-weight: 500;
}

.rating {
  display: flex;
  margin-top: 8rpx;
}

.star {
  font-size: 24rpx;
  color: #ddd;
  margin-right: 4rpx;
}

.star.active {
  color: #15803d;
}

.comment-time {
  font-size: 24rpx;
  color: #999;
}

.comment-content {
  font-size: 28rpx;
  color: #666;
  line-height: 1.6;
}

/* 商家回复样式 */
.merchant-reply {
  margin-top: 16rpx;
  padding: 20rpx;
  background-color: #f5f5f5;
  border-radius: 12rpx;
  border-left: 4rpx solid #15803d;
}

.reply-header {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;
}

.reply-icon {
  font-size: 28rpx;
  margin-right: 8rpx;
}

.reply-label {
  font-size: 26rpx;
  color: #15803d;
  font-weight: 500;
}

.reply-time {
  font-size: 22rpx;
  color: #999;
  margin-left: auto;
}

.reply-content {
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
}

.empty-comment {
  text-align: center;
  padding: 60rpx;
  font-size: 28rpx;
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

.action-icons {
  display: flex;
  margin-right: 30rpx;
}

.action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-right: 40rpx;
}

.action-item .icon {
  font-size: 40rpx;
}

.action-item .label {
  font-size: 20rpx;
  color: #666;
  margin-top: 4rpx;
}

.action-buttons {
  flex: 1;
  display: flex;
}

.btn-add-cart,
.btn-buy-now {
  flex: 1;
  height: 72rpx;
  line-height: 72rpx;
  border-radius: 36rpx;
  font-size: 28rpx;
  border: none;
}

.btn-add-cart {
  background-color: #84cc16;
  color: #333;
  margin-right: 20rpx;
}

.btn-buy-now {
  background-color: #15803d;
  color: #fff;
}

.comment-popup {
  background-color: #fff;
  border-radius: 24rpx 24rpx 0 0;
}

.popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1px solid #f5f5f5;
}

.popup-title {
  font-size: 32rpx;
  font-weight: bold;
}

.close-btn {
  font-size: 40rpx;
  color: #999;
}

.popup-content {
  padding: 30rpx;
}

.rating-section {
  margin-bottom: 30rpx;
}

.rating-section .label {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 16rpx;
}

.rating-stars {
  display: flex;
}

.rating-stars .star {
  font-size: 48rpx;
  color: #ddd;
  margin-right: 16rpx;
}

.rating-stars .star.active {
  color: #15803d;
}

.comment-input {
  width: 100%;
  height: 200rpx;
  background-color: #f5f5f5;
  border-radius: 16rpx;
  padding: 24rpx;
  font-size: 28rpx;
}

.word-count {
  text-align: right;
  font-size: 24rpx;
  color: #999;
  margin-top: 16rpx;
}

.submit-btn {
  width: 100%;
  height: 88rpx;
  background-color: #15803d;
  color: #fff;
  border-radius: 44rpx;
  font-size: 32rpx;
  margin-top: 30rpx;
}
</style>
