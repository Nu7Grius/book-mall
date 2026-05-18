<template>
  <view class="notice-detail-container">
    <view class="notice-header">
      <text class="notice-title">{{ notice.title }}</text>
      <view class="notice-meta">
        <view class="notice-tag" :class="'tag-' + notice.noticeType">
          {{ getNoticeTypeName(notice.noticeType) }}
        </view>
        <text class="notice-time">{{ formatTime(notice.createTime) }}</text>
      </view>
    </view>

    <view class="notice-content">
      <text class="content-text">{{ formatRichText(notice.content) }}</text>
    </view>
  </view>
</template>

<script>
import { getNoticeDetail } from "../../api/notice.js";
import { formatRichText } from "../../utils/format.js";

export default {
  data() {
    return {
      noticeId: null,
      notice: {
        title: "",
        content: "",
        noticeType: 0,
        createTime: "",
      },
    };
  },
  onLoad(options) {
    if (options.id) {
      this.noticeId = options.id;
      this.loadNoticeDetail();
    }
    if (options.title) {
      uni.setNavigationBarTitle({
        title: decodeURIComponent(options.title),
      });
    }
  },
  methods: {
    formatRichText,
    async loadNoticeDetail() {
      uni.showLoading({ title: "加载中..." });
      try {
        const res = await getNoticeDetail(this.noticeId);
        if (res.code === 200) {
          this.notice = res.data;
        }
      } catch (error) {
        console.error("加载通知详情失败:", error);
      } finally {
        uni.hideLoading();
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
      const hour = String(date.getHours()).padStart(2, "0");
      const minute = String(date.getMinutes()).padStart(2, "0");
      return `${year}-${month}-${day} ${hour}:${minute}`;
    },
  },
};
</script>

<style scoped>
.notice-detail-container {
  min-height: 100vh;
  background-color: #fff;
  padding: 30rpx;
}

.notice-header {
  margin-bottom: 40rpx;
  padding-bottom: 30rpx;
  border-bottom: 1px solid #f5f5f5;
}

.notice-title {
  display: block;
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  line-height: 1.5;
  margin-bottom: 20rpx;
}

.notice-meta {
  display: flex;
  align-items: center;
}

.notice-tag {
  font-size: 22rpx;
  padding: 6rpx 16rpx;
  border-radius: 20rpx;
  margin-right: 20rpx;
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

.notice-time {
  font-size: 24rpx;
  color: #999;
}

.notice-content {
  padding-bottom: 60rpx;
}

.content-text {
  display: block;
  font-size: 30rpx;
  color: #333;
  line-height: 1.8;
}
</style>
