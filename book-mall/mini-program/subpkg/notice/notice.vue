<template>
  <view class="notice-container">
    <!-- 空状态 -->
    <view class="empty-state" v-if="!loading && noticeList.length === 0">
      <text class="empty-icon">📢</text>
      <text class="empty-text">暂无通知</text>
    </view>

    <!-- 通知列表 -->
    <view class="notice-list" v-else>
      <view
        class="notice-item"
        v-for="item in noticeList"
        :key="item.id"
        @click="goToDetail(item)"
      >
        <view class="notice-header">
          <text class="notice-title">{{ item.title }}</text>
          <view class="notice-tag" :class="'tag-' + item.noticeType">
            {{ getNoticeTypeName(item.noticeType) }}
          </view>
        </view>
        <text class="notice-summary">{{
          truncateText(formatRichText(item.summary || item.content || ""), 80)
        }}</text>
        <view class="notice-footer">
          <text class="notice-time">{{ formatTime(item.createTime) }}</text>
          <text class="notice-arrow">></text>
        </view>
      </view>
    </view>

    <!-- 加载更多 -->
    <view class="loading-more" v-if="loading">
      <text class="loading-text">加载中...</text>
    </view>
    <view class="no-more" v-if="!loading && noMore && noticeList.length > 0">
      <text class="no-more-text">没有更多了</text>
    </view>
  </view>
</template>

<script>
import { getNoticeList } from "../../api/notice.js";
import { getImageUrl } from "../../utils/image.js";
import { formatRichText, truncateText } from "../../utils/format.js";

export default {
  data() {
    return {
      noticeList: [],
      page: 1,
      size: 10,
      loading: false,
      noMore: false,
    };
  },
  onLoad() {
    this.loadNotices(true);
  },
  onPullDownRefresh() {
    this.loadNotices(true);
  },
  onReachBottom() {
    if (!this.noMore && !this.loading) {
      this.loadNotices(false);
    }
  },
  methods: {
    formatRichText,
    truncateText,
    async loadNotices(reset = false) {
      if (this.loading) return;

      if (reset) {
        this.page = 1;
        this.noMore = false;
      }

      this.loading = true;

      try {
        const res = await getNoticeList({
          page: this.page,
          size: this.size,
        });

        if (res.code === 200) {
          let data = res.data.records || res.data || [];
          data = data.map((item) => ({
            ...item,
            coverImage: item.coverImage ? getImageUrl(item.coverImage) : "",
          }));

          if (reset) {
            this.noticeList = data;
          } else {
            this.noticeList = [...this.noticeList, ...data];
          }

          this.noMore = data.length < this.size;
          this.page++;
        }
      } catch (error) {
        console.error("加载通知失败:", error);
      } finally {
        this.loading = false;
        uni.stopPullDownRefresh();
      }
    },
    getNoticeTypeName(type) {
      const typeMap = {
        0: "公告",
        1: "活动",
        2: "系统",
      };
      return typeMap[type] || "通知";
    },
    formatTime(time) {
      if (!time) return "";
      const date = new Date(time);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      return `${year}-${month}-${day}`;
    },
    goToDetail(item) {
      uni.navigateTo({
        url: `/subpkg/notice/notice-detail?id=${
          item.id
        }&title=${encodeURIComponent(item.title)}`,
      });
    },
  },
};
</script>

<style scoped>
.notice-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 40rpx;
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

.notice-list {
  padding: 20rpx;
}

.notice-item {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.notice-header {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;
}

.notice-title {
  flex: 1;
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.notice-tag {
  font-size: 22rpx;
  padding: 6rpx 16rpx;
  border-radius: 20rpx;
  margin-left: 16rpx;
}

.tag-0 {
  background-color: #f0f9ff;
  color: #15803d;
}

.tag-1 {
  background-color: #fef3c7;
  color: #d97706;
}

.tag-2 {
  background-color: #f3f4f6;
  color: #6b7280;
}

.notice-summary {
  display: block;
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  margin-bottom: 16rpx;
}

.notice-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.notice-time {
  font-size: 24rpx;
  color: #999;
}

.notice-arrow {
  font-size: 28rpx;
  color: #999;
}

.loading-more,
.no-more {
  text-align: center;
  padding: 30rpx;
}

.loading-text,
.no-more-text {
  font-size: 26rpx;
  color: #999;
}
</style>
