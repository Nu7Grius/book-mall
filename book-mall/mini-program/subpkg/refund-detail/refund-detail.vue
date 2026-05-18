<template>
  <view class="refund-detail-container">
    <!-- 加载状态 -->
    <view class="loading-section" v-if="loading">
      <text>加载中...</text>
    </view>

    <!-- 退款详情 -->
    <view class="refund-content" v-else-if="refundDetail">
      <!-- 退款金额卡片 -->
      <view class="amount-card">
        <view class="amount-label">退款金额</view>
        <view class="amount-value">¥{{ refundAmount }}</view>
      </view>

      <!-- 退款商品信息 -->
      <view class="section goods-section">
        <view class="goods-card">
          <image
            class="goods-cover"
            :src="goodsInfo.coverImage"
            mode="aspectFill"
            @error="handleImageError"
          ></image>
          <view class="goods-info">
            <text class="goods-name">{{
              goodsInfo.bookName || "未知书名"
            }}</text>
            <text class="goods-author" v-if="goodsInfo.author">{{
              goodsInfo.author
            }}</text>
            <view class="goods-bottom">
              <text class="goods-price">¥{{ goodsInfo.price }}</text>
              <text class="goods-quantity">x{{ goodsInfo.quantity || 1 }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 退款状态 -->
      <view class="section status-section">
        <view class="status-badge" :class="statusBadgeClass">
          <text class="status-icon">{{ statusBadgeIcon }}</text>
          <text class="status-text">{{ refundDetail.refundStatus }}</text>
        </view>
      </view>

      <!-- 退款信息 -->
      <view class="section info-section">
        <view class="info-row">
          <text class="label">退款原因</text>
          <text class="value">{{ refundDetail.refundReason || "未填写" }}</text>
        </view>
        <view class="info-row" v-if="refundDetail.refundDescription">
          <text class="label">详细说明</text>
          <text class="value">{{ refundDetail.refundDescription }}</text>
        </view>
        <view class="info-row">
          <text class="label">申请时间</text>
          <text class="value">{{ formatDate(refundDetail.createTime) }}</text>
        </view>
      </view>

      <!-- 商家回复区域 -->
      <view class="section reply-section" v-if="refundDetail.merchantReply">
        <view class="reply-header">
          <text class="reply-title">商家回复</text>
        </view>
        <view class="reply-alert" :class="replyAlertClass">
          <view class="reply-alert-header">
            <text class="reply-alert-icon">{{ replyAlertIcon }}</text>
            <text class="reply-alert-title">{{ replyAlertTitle }}</text>
          </view>
          <text class="reply-alert-content">{{
            refundDetail.merchantReply
          }}</text>
        </view>
        <text class="reply-time" v-if="refundDetail.processTime">
          处理时间：{{ formatDate(refundDetail.processTime) }}
        </text>
      </view>

      <!-- 后续操作（被拒绝时） -->
      <view class="section action-section" v-if="isRejected">
        <view class="action-title">后续操作</view>
        <view class="action-buttons">
          <button class="btn-action" @click="reapplyRefund">
            <text class="btn-icon">🔄</text>
            <text class="btn-text">再次申请退款</text>
          </button>
          <button
            class="btn-action"
            v-if="merchantPhone"
            @click="contactMerchant"
          >
            <text class="btn-icon">📞</text>
            <text class="btn-text">联系商家</text>
          </button>
        </view>
      </view>

      <!-- 退款通过提示 -->
      <view class="section success-section" v-if="isApproved">
        <view class="success-alert">
          <text class="success-icon">✅</text>
          <view class="success-text">
            <text class="success-title">退款已通过</text>
            <text class="success-desc"
              >商家已通过您的退款申请，款项将原路返回</text
            >
          </view>
        </view>
      </view>
    </view>

    <!-- 加载失败 -->
    <view class="error-section" v-else>
      <text class="error-icon">❌</text>
      <text class="error-text">加载退款详情失败</text>
      <button class="btn-retry" @click="loadRefundDetail">重新加载</button>
    </view>
  </view>
</template>

<script>
import { getRefundByOrderItem } from "../../api/refund.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      orderItemId: null,
      refundDetail: null,
      loading: true,
      merchantPhone: "",
      goodsInfo: {
        coverImage: "",
        bookName: "",
        author: "",
        price: "0.00",
        quantity: 1,
      },
    };
  },
  computed: {
    refundAmount() {
      if (!this.refundDetail) return "0.00";
      const amount = this.refundDetail.refundAmount;
      if (amount === null || amount === undefined || amount === "") {
        return "0.00";
      }
      const num = typeof amount === "number" ? amount : parseFloat(amount);
      return isNaN(num) ? "0.00" : num.toFixed(2);
    },
    statusBadgeClass() {
      if (!this.refundDetail) return "";
      const status = this.refundDetail.refundStatus;
      const classMap = {
        待处理: "badge-pending",
        已通过: "badge-approved",
        已拒绝: "badge-rejected",
        已取消: "badge-cancelled",
      };
      return classMap[status] || "";
    },
    statusBadgeIcon() {
      if (!this.refundDetail) return "❓";
      const status = this.refundDetail.refundStatus;
      const iconMap = {
        待处理: "⏳",
        已通过: "✅",
        已拒绝: "❌",
        已取消: "○",
      };
      return iconMap[status] || "❓";
    },
    isPending() {
      return this.refundDetail?.refundStatus === "待处理";
    },
    isRejected() {
      return this.refundDetail?.refundStatus === "已拒绝";
    },
    isApproved() {
      return this.refundDetail?.refundStatus === "已通过";
    },
    replyAlertClass() {
      return this.isRejected ? "alert-error" : "alert-success";
    },
    replyAlertIcon() {
      return this.isRejected ? "❌" : "✅";
    },
    replyAlertTitle() {
      return this.isRejected ? "商家已拒绝退款" : "商家已通过退款";
    },
  },
  onLoad(options) {
    if (options.orderItemId) {
      this.orderItemId = parseInt(options.orderItemId);
      this.loadRefundDetail();
    } else {
      uni.showToast({
        title: "参数错误",
        icon: "none",
      });
      setTimeout(() => {
        uni.navigateBack();
      }, 1500);
    }
  },
  methods: {
    async loadRefundDetail() {
      this.loading = true;
      try {
        const res = await getRefundByOrderItem(this.orderItemId);
        if (res.code === 200 && res.data) {
          this.refundDetail = res.data;
          if (this.refundDetail.orderItem) {
            const item = this.refundDetail.orderItem;
            this.goodsInfo = {
              coverImage: item.coverImage
                ? getImageUrl(item.coverImage)
                : "/static/default-cover.png",
              bookName: item.bookName || item.bookTitle || "未知书名",
              author: item.author || "",
              price: parseFloat(item.price || item.bookPrice || 0).toFixed(2),
              quantity: item.quantity || 1,
            };
            this.merchantPhone = item.merchantPhone || "";
          } else {
            this.goodsInfo.coverImage = "/static/default-cover.png";
          }
        } else {
          uni.showToast({
            title: "未找到退款信息",
            icon: "none",
          });
        }
      } catch (error) {
        console.error("加载退款详情失败:", error);
        uni.showToast({
          title: "加载失败",
          icon: "none",
        });
      } finally {
        this.loading = false;
      }
    },
    handleImageError(e) {
      this.goodsInfo.coverImage = "/static/default-cover.png";
    },
    formatDate(date) {
      if (!date) return "";
      const d = new Date(date);
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(
        2,
        "0"
      )}-${String(d.getDate()).padStart(2, "0")} ${String(
        d.getHours()
      ).padStart(2, "0")}:${String(d.getMinutes()).padStart(2, "0")}`;
    },
    reapplyRefund() {
      uni.navigateTo({
        url: `/subpkg/refund-apply/refund-apply?orderId=${this.refundDetail.orderId}&bookId=${this.orderItemId}`,
      });
    },
    contactMerchant() {
      if (this.merchantPhone) {
        uni.makePhoneCall({
          phoneNumber: this.merchantPhone,
          fail: () => {
            uni.showToast({
              title: "拨打电话失败",
              icon: "none",
            });
          },
        });
      } else {
        uni.showToast({
          title: "商家暂无联系电话",
          icon: "none",
        });
      }
    },
  },
};
</script>

<style scoped>
.refund-detail-container {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.loading-section {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 300rpx;
  color: #999;
  font-size: 28rpx;
}

.error-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 200rpx 0;
}

.error-icon {
  font-size: 80rpx;
  margin-bottom: 30rpx;
}

.error-text {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 40rpx;
}

.btn-retry {
  width: 240rpx;
  height: 72rpx;
  line-height: 72rpx;
  background-color: #15803d;
  color: #fff;
  font-size: 28rpx;
  border-radius: 36rpx;
  border: none;
}

.refund-content {
  padding-bottom: 60rpx;
}

/* 退款金额卡片 */
.amount-card {
  background: #fff;
  padding: 40rpx 30rpx;
  margin-bottom: 20rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}

.amount-label {
  font-size: 28rpx;
  color: #999;
  margin-bottom: 12rpx;
}

.amount-value {
  font-size: 56rpx;
  color: #ee4b2b;
  font-weight: bold;
}

/* 通用区块 */
.section {
  background-color: #fff;
  margin-bottom: 20rpx;
}

/* 商品信息 */
.goods-section {
  padding: 30rpx;
}

.goods-card {
  display: flex;
  background-color: #fafafa;
  border-radius: 12rpx;
  padding: 20rpx;
}

.goods-cover {
  width: 140rpx;
  height: 180rpx;
  border-radius: 8rpx;
  margin-right: 20rpx;
  flex-shrink: 0;
  background-color: #eee;
}

.goods-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.goods-name {
  font-size: 28rpx;
  color: #333;
  font-weight: 500;
  margin-bottom: 8rpx;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.goods-author {
  font-size: 24rpx;
  color: #999;
  margin-bottom: 12rpx;
}

.goods-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.goods-price {
  font-size: 30rpx;
  color: #ee4b2b;
  font-weight: bold;
}

.goods-quantity {
  font-size: 26rpx;
  color: #999;
}

/* 退款状态 */
.status-section {
  padding: 24rpx 30rpx;
  display: flex;
  justify-content: center;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  padding: 12rpx 32rpx;
  border-radius: 40rpx;
  font-size: 28rpx;
  font-weight: 500;
}

.status-badge.badge-pending {
  color: #fa8c16;
  background-color: #fff7e6;
}

.status-badge.badge-approved {
  color: #52c41a;
  background-color: #f6ffed;
}

.status-badge.badge-rejected {
  color: #f5222d;
  background-color: #fff1f0;
}

.status-badge.badge-cancelled {
  color: #8c8c8c;
  background-color: #fafafa;
}

.status-icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

/* 退款信息 */
.info-section {
  padding: 24rpx 30rpx;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 16rpx 0;
  border-bottom: 1px solid #f5f5f5;
}

.info-row:last-child {
  border-bottom: none;
}

.info-row .label {
  font-size: 28rpx;
  color: #666;
  flex-shrink: 0;
  width: 140rpx;
}

.info-row .value {
  font-size: 28rpx;
  color: #333;
  text-align: right;
  flex: 1;
  margin-left: 20rpx;
}

/* 商家回复 */
.reply-section {
  padding: 24rpx 30rpx;
}

.reply-header {
  margin-bottom: 20rpx;
}

.reply-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
}

.reply-alert {
  border-radius: 12rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
}

.reply-alert.alert-error {
  background-color: #fff2f0;
}

.reply-alert.alert-success {
  background-color: #f6ffed;
}

.reply-alert-header {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;
}

.reply-alert-icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.reply-alert-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
}

.reply-alert.alert-error .reply-alert-title {
  color: #f5222d;
}

.reply-alert.alert-success .reply-alert-title {
  color: #52c41a;
}

.reply-alert-content {
  font-size: 28rpx;
  color: #333;
  line-height: 1.6;
  display: block;
}

.reply-time {
  font-size: 24rpx;
  color: #999;
}

/* 后续操作 */
.action-section {
  padding: 24rpx 30rpx;
}

.action-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.action-buttons {
  display: flex;
  gap: 20rpx;
}

.btn-action {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24rpx;
  border-radius: 12rpx;
  font-size: 28rpx;
  border: none;
  background-color: #f5f5f5;
}

.btn-action:first-child {
  background-color: #fff3e0;
  color: #fa8c16;
}

.btn-action:last-child {
  background-color: #e6f7ff;
  color: #1890ff;
}

.btn-icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.btn-text {
  font-weight: 500;
}

/* 退款通过提示 */
.success-section {
  padding: 24rpx 30rpx;
}

.success-alert {
  display: flex;
  align-items: flex-start;
  background-color: #f6ffed;
  border-radius: 12rpx;
  padding: 24rpx;
}

.success-icon {
  font-size: 40rpx;
  margin-right: 16rpx;
}

.success-text {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.success-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #52c41a;
  margin-bottom: 8rpx;
}

.success-desc {
  font-size: 26rpx;
  color: #666;
}
</style>
