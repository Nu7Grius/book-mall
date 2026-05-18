<template>
  <view class="comment-list-container">
    <!-- 评分概览 -->
    <view class="rating-overview" v-if="ratingStats">
      <view class="rating-left">
        <text class="rating-score">{{
          ratingStats.averageRating || "0.0"
        }}</text>
        <text class="rating-label">综合评分</text>
        <view class="rating-stars">
          <text
            v-for="star in 5"
            :key="star"
            class="star"
            :class="{ active: star <= averageRatingRound }"
            >★</text
          >
        </view>
      </view>
      <view class="rating-right">
        <view
          class="rating-bar"
          v-for="(count, index) in ratingStats.ratingDistribution"
          :key="index"
        >
          <text class="bar-label">{{ 5 - index }}星</text>
          <view class="bar-track">
            <view
              class="bar-fill"
              :style="{
                width:
                  ratingStats.totalComments > 0
                    ? (count / ratingStats.totalComments) * 100 + '%'
                    : '0%',
              }"
            ></view>
          </view>
          <text class="bar-count">{{ count }}</text>
        </view>
      </view>
    </view>

    <!-- 评论列表 -->
    <view class="comment-list" v-if="comments.length > 0">
      <view class="comment-item" v-for="item in comments" :key="item.id">
        <view class="comment-header">
          <view class="user-info">
            <image
              class="avatar"
              :src="item.userAvatar || '/static/icons/user.png'"
              mode="aspectFill"
            ></image>
            <text class="username">{{ item.userName || "匿名用户" }}</text>
          </view>
          <view class="rating-stars">
            <text
              v-for="star in 5"
              :key="star"
              class="star"
              :class="{ active: star <= item.rating }"
              >★</text
            >
          </view>
        </view>
        <view class="comment-content">{{ formatRichText(item.content) }}</view>
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
        <text class="comment-time">{{ formatTime(item.createTime) }}</text>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <text class="empty-icon">💬</text>
      <text class="empty-text">暂无评价</text>
    </view>

    <!-- 加载更多 -->
    <view class="loading-more" v-if="loading">
      <text>加载中...</text>
    </view>
    <view class="no-more" v-if="!loading && noMore && comments.length > 0">
      <text>没有更多了</text>
    </view>
  </view>
</template>

<script>
import { getCommentsByBookId, getCommentStats } from "../../api/comment.js";
import { formatRichText } from "../../utils/format.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      bookId: null,
      comments: [],
      ratingStats: null,
      page: 1,
      size: 10,
      loading: false,
      noMore: false,
    };
  },
  onLoad(options) {
    if (options.bookId) {
      this.bookId = options.bookId;
      this.loadRatingStats();
      this.loadComments(true);
    }
  },
  onReachBottom() {
    if (!this.noMore && !this.loading) {
      this.loadComments(false);
    }
  },
  computed: {
    averageRatingRound() {
      if (!this.ratingStats || !this.ratingStats.averageRating) return 0;
      return Math.round(this.ratingStats.averageRating);
    },
  },
  methods: {
    formatRichText,
    async loadRatingStats() {
      try {
        const res = await getCommentStats(this.bookId);
        if (res.code === 200 && res.data) {
          this.ratingStats = res.data;
        }
      } catch (error) {
        console.error("加载评分统计失败:", error);
      }
    },
    async loadComments(reset = false) {
      if (this.loading) return;

      if (reset) {
        this.page = 1;
        this.noMore = false;
      }

      this.loading = true;
      try {
        const res = await getCommentsByBookId(this.bookId);
        if (res.code === 200) {
          const data = (res.data || []).map((comment) => ({
            ...comment,
            userAvatar: comment.userAvatar
              ? getImageUrl(comment.userAvatar)
              : "/static/icons/user.png",
            rating: comment.rating || 5,
          }));

          if (reset) {
            this.comments = data;
          } else {
            this.comments = [...this.comments, ...data];
          }

          this.noMore = data.length < this.size;
          this.page++;
        }
      } catch (error) {
        console.error("加载评论失败:", error);
      } finally {
        this.loading = false;
      }
    },
    formatTime(time) {
      if (!time) return "";
      const date = new Date(time);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      return `${year}-${month}-${day}`;
    },
  },
};
</script>

<style scoped>
.comment-list-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 40rpx;
}

.rating-overview {
  display: flex;
  background-color: #fff;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.rating-left {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 200rpx;
  border-right: 1px solid #f0f0f0;
}

.rating-score {
  font-size: 60rpx;
  font-weight: bold;
  color: #f5a623;
}

.rating-label {
  font-size: 24rpx;
  color: #999;
  margin-top: 8rpx;
}

.rating-stars {
  display: flex;
  margin-top: 8rpx;
}

.star {
  font-size: 28rpx;
  color: #ddd;
  margin: 0 2rpx;
}

.star.active {
  color: #f5a623;
}

.rating-right {
  flex: 1;
  padding-left: 30rpx;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.rating-bar {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;
}

.rating-bar:last-child {
  margin-bottom: 0;
}

.bar-label {
  font-size: 22rpx;
  color: #666;
  width: 60rpx;
}

.bar-track {
  flex: 1;
  height: 16rpx;
  background-color: #f0f0f0;
  border-radius: 8rpx;
  margin: 0 16rpx;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background-color: #f5a623;
  border-radius: 8rpx;
}

.bar-count {
  font-size: 22rpx;
  color: #999;
  width: 60rpx;
  text-align: right;
}

.comment-list {
  padding: 0 20rpx;
}

.comment-item {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.user-info {
  display: flex;
  align-items: center;
}

.avatar {
  width: 60rpx;
  height: 60rpx;
  border-radius: 50%;
  margin-right: 16rpx;
}

.username {
  font-size: 28rpx;
  color: #333;
}

.comment-content {
  font-size: 28rpx;
  color: #333;
  line-height: 1.6;
  margin-bottom: 16rpx;
}

/* 商家回复样式 */
.merchant-reply {
  margin: 16rpx 0;
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

.comment-time {
  font-size: 24rpx;
  color: #999;
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
}

.loading-more,
.no-more {
  text-align: center;
  padding: 30rpx;
}

.loading-more text,
.no-more text {
  font-size: 26rpx;
  color: #999;
}
</style>
