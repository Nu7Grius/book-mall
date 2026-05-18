<template>
  <view class="container">
    <view class="header">
      <text class="title">联系客服</text>
      <text class="subtitle">我们随时为您服务</text>
    </view>

    <view class="service-options">
      <view class="service-card" @click="callHotline">
        <view class="card-icon">📞</view>
        <view class="card-content">
          <text class="card-title">电话客服</text>
          <text class="card-desc">400-888-8888</text>
          <text class="card-time">工作日 9:00-18:00</text>
        </view>
        <text class="arrow">›</text>
      </view>

      <view class="service-card" @click="openWechatCustomerService">
        <view class="card-icon green">💬</view>
        <view class="card-content">
          <text class="card-title">微信客服</text>
          <text class="card-desc">在线咨询更便捷</text>
          <text class="card-time">平均响应 5 分钟</text>
        </view>
        <text class="arrow">›</text>
      </view>
    </view>

    <view class="tips-section">
      <text class="tips-title">温馨提示</text>
      <view class="tips-list">
        <text class="tip-item">• 请详细描述您遇到的问题</text>
        <text class="tip-item">• 提供订单号可加快处理速度</text>
        <text class="tip-item">• 遇到支付问题建议保留截图</text>
        <text class="tip-item">• 客服工作时间内必回复</text>
      </view>
    </view>

    <button
      class="contact-btn"
      open-type="contact"
      :send-message-title="contactTitle"
      :send-message-img="contactImage"
      @contact="onContact"
    >
      打开微信客服
    </button>
  </view>
</template>

<script>
export default {
  data() {
    return {
      contactTitle: "用户咨询",
      contactImage: "/static/icons/logo.png",
    };
  },
  methods: {
    callHotline() {
      uni.makePhoneCall({
        phoneNumber: "400-888-8888",
        fail: () => {
          uni.showToast({
            title: "拨打失败",
            icon: "none",
          });
        },
      });
    },
    openWechatCustomerService() {
      uni.showToast({
        title: "请点击下方按钮联系客服",
        icon: "none",
        duration: 2000,
      });
    },
  },
};
</script>

<style scoped>
.container {
  min-height: 100vh;
  background: #f5f5f5;
  padding: 40rpx;
}

.header {
  text-align: center;
  margin-bottom: 60rpx;
}

.title {
  display: block;
  font-size: 48rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 16rpx;
}

.subtitle {
  display: block;
  font-size: 28rpx;
  color: #999;
}

.service-options {
  margin-bottom: 60rpx;
}

.service-card {
  background: white;
  border-radius: 24rpx;
  padding: 40rpx;
  margin-bottom: 30rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.card-icon {
  width: 100rpx;
  height: 100rpx;
  background: #fff3e0;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 48rpx;
  margin-right: 30rpx;
}

.card-icon.green {
  background: #e8f5e9;
}

.card-content {
  flex: 1;
}

.card-title {
  display: block;
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 8rpx;
}

.card-desc {
  display: block;
  font-size: 26rpx;
  color: #666;
  margin-bottom: 4rpx;
}

.card-time {
  display: block;
  font-size: 22rpx;
  color: #999;
}

.arrow {
  font-size: 48rpx;
  color: #ccc;
}

.tips-section {
  background: white;
  border-radius: 24rpx;
  padding: 40rpx;
  margin-bottom: 120rpx;
}

.tips-title {
  display: block;
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 24rpx;
}

.tips-list {
  display: flex;
  flex-direction: column;
}

.tip-item {
  font-size: 26rpx;
  color: #666;
  line-height: 1.8;
}

.contact-btn {
  position: fixed;
  bottom: 60rpx;
  left: 40rpx;
  right: 40rpx;
  background: linear-gradient(135deg, #4caf50, #45a049);
  color: white;
  font-size: 32rpx;
  font-weight: bold;
  border-radius: 50rpx;
  padding: 24rpx 0;
  border: none;
  box-shadow: 0 8rpx 24rpx rgba(76, 175, 80, 0.3);
}

.contact-btn::after {
  border: none;
}
</style>
