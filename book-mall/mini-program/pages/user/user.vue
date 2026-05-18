<template>
  <view class="user-container">
    <!-- 用户信息卡片 -->
    <view class="user-card">
      <view class="user-info">
        <image
          class="avatar"
          :src="userInfo.avatar || '/static/icons/user.png'"
          mode="aspectFill"
          @click="changeAvatar"
        ></image>
        <view class="info-content">
          <text class="username">{{ userInfo.realName || "未登录" }}</text>
        </view>
      </view>
    </view>

    <!-- 订单快捷入口 -->
    <view class="order-section">
      <view class="section-header">
        <text class="section-title">我的订单</text>
        <text class="more-btn" @click="goToOrderList">全部订单 ></text>
      </view>
      <view class="order-icons">
        <view class="order-item" @click="goToOrderListByStatus(0)">
          <text class="icon">💳</text>
          <text class="label">待支付</text>
          <view class="badge" v-if="orderCounts.unpaid > 0">{{
            orderCounts.unpaid
          }}</view>
        </view>
        <view class="order-item" @click="goToOrderListByStatus(1)">
          <text class="icon">📦</text>
          <text class="label">待发货</text>
          <view class="badge" v-if="orderCounts.unshipped > 0">{{
            orderCounts.unshipped
          }}</view>
        </view>
        <view class="order-item" @click="goToOrderListByStatus(2)">
          <text class="icon">🚚</text>
          <text class="label">待收货</text>
          <view class="badge" v-if="orderCounts.unreceived > 0">{{
            orderCounts.unreceived
          }}</view>
        </view>
        <view class="order-item" @click="goToOrderListByStatus(3)">
          <text class="icon">⭐</text>
          <text class="label">已完成</text>
        </view>
      </view>
    </view>

    <!-- 功能列表 -->
    <view class="menu-section">
      <view class="menu-item" @click="goToFavorites">
        <text class="icon">❤️</text>
        <text class="label">我的收藏</text>
        <text class="arrow">></text>
      </view>
      <view class="menu-item" @click="goToAddressList">
        <text class="icon">📍</text>
        <text class="label">收货地址</text>
        <text class="arrow">></text>
      </view>
      <view class="menu-item" @click="goToNotice">
        <text class="icon">🔔</text>
        <text class="label">系统通知</text>
        <text class="arrow">></text>
      </view>
    </view>

    <view class="menu-section">
      <view class="menu-item" @click="editProfile">
        <text class="icon">👤</text>
        <text class="label">编辑资料</text>
        <text class="arrow">></text>
      </view>
      <view class="menu-item" @click="changePassword">
        <text class="icon">🔐</text>
        <text class="label">修改密码</text>
        <text class="arrow">></text>
      </view>
      <view class="menu-item" @click="contactService">
        <text class="icon">📞</text>
        <text class="label">联系客服</text>
        <text class="arrow">></text>
      </view>
      <view class="menu-item" @click="aboutUs">
        <text class="icon">ℹ️</text>
        <text class="label">关于我们</text>
        <text class="arrow">></text>
      </view>
    </view>

    <!-- 退出登录 -->
    <view class="logout-section" v-if="isLoggedIn">
      <button class="btn-logout" @click="logout">退出登录</button>
    </view>

    <!-- 联系客服弹窗 -->
    <view
      class="custom-modal"
      v-if="showContactModal"
      @click="closeContactModal"
    >
      <view class="modal-content" @click.stop>
        <view class="modal-title">联系客服</view>
        <view class="modal-body">
          <view class="info-line center"
            >如有疑问，请通过以下方式联系我们：</view
          >
        </view>
        <view class="modal-buttons vertical">
          <button class="btn-confirm full-width" @click="callHotline">
            📞 拨打热线
          </button>
          <button
            class="btn-confirm full-width green"
            @click="openOnlineService"
          >
            💬 在线客服
          </button>
          <button class="btn-cancel-text" @click="closeContactModal">
            取消
          </button>
        </view>
      </view>
    </view>

    <!-- 在线客服弹窗 -->
    <view
      class="custom-modal"
      v-if="showOnlineService"
      @click="closeOnlineService"
    >
      <view class="modal-content" @click.stop>
        <view class="modal-title">在线客服</view>
        <view class="modal-body">
          <view class="info-line">客服微信号：bookmall_service</view>
          <view class="info-line">工作时间：9:00-18:00</view>
          <view class="info-line bold">是否复制微信号？</view>
        </view>
        <view class="modal-buttons">
          <button class="btn-cancel" @click="closeOnlineService">取消</button>
          <button class="btn-confirm" @click="copyWechat">复制</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { getUserInfoById } from "../../api/user.js";
import { getImageUrl } from "../../utils/image.js";
import { getOrderList } from "../../api/order.js";

export default {
  data() {
    return {
      userInfo: {},
      orderCounts: {
        unpaid: 0,
        unshipped: 0,
        unreceived: 0,
      },
      isLoggedIn: false,
      showContactModal: false,
      showOnlineService: false,
    };
  },
  onShow() {
    this.checkLoginStatus();
  },
  onLoad() {
    this.checkLoginStatus();
  },
  methods: {
    checkLoginStatus() {
      const userInfo = uni.getStorageSync("userInfo");

      if (userInfo && userInfo.id) {
        this.isLoggedIn = true;
        this.userInfo = userInfo;
        this.loadUserInfo();
        this.loadOrderCounts();
      } else {
        this.isLoggedIn = false;
        this.userInfo = {};
      }
    },
    async loadUserInfo() {
      try {
        const res = await getUserInfoById(this.userInfo.id);
        if (res.code === 200) {
          const userData = {
            ...res.data,
            avatar: res.data.avatar ? getImageUrl(res.data.avatar) : "",
          };
          this.userInfo = userData;
          uni.setStorageSync("userInfo", res.data);
        }
      } catch (error) {
        console.error("加载用户信息失败:", error);
      }
    },
    async loadOrderCounts() {
      if (!this.userInfo || !this.userInfo.id) return;

      try {
        const res = await getOrderList(this.userInfo.id, {
          page: 1,
          size: 100,
        });

        if (res.code === 200) {
          const data = res.data.records || res.data || [];
          const counts = { unpaid: 0, unshipped: 0, unreceived: 0 };

          data.forEach((order) => {
            if (order.status === 0) counts.unpaid++;
            else if (order.status === 1) counts.unshipped++;
            else if (order.status === 2) counts.unreceived++;
          });

          this.orderCounts = counts;
        }
      } catch (error) {
        console.error("加载订单数量失败:", error);
      }
    },
    changeAvatar() {
      uni.chooseImage({
        count: 1,
        sizeType: ["compressed"],
        sourceType: ["album", "camera"],
        success: (res) => {
          const tempFilePath = res.tempFilePaths[0];
          this.uploadAvatar(tempFilePath);
        },
      });
    },
    async uploadAvatar(filePath) {
      uni.showLoading({ title: "上传中..." });
      try {
        const { uploadAvatar } = require("../../api/user.js");
        const res = await uploadAvatar(filePath);
        if (res.code === 200) {
          this.userInfo.avatar = getImageUrl(res.data);
          uni.setStorageSync("userInfo", {
            ...uni.getStorageSync("userInfo"),
            avatar: res.data,
          });
          uni.showToast({
            title: "头像更新成功",
            icon: "success",
          });
        }
      } catch (error) {
        console.error("上传头像失败:", error);
      } finally {
        uni.hideLoading();
      }
    },
    goToOrderList() {
      uni.switchTab({
        url: "/pages/order-list/order-list",
      });
    },
    goToOrderListByStatus(status) {
      uni.setStorageSync("orderListFilterStatus", status);
      uni.reLaunch({
        url: "/pages/order-list/order-list",
      });
    },
    goToFavorites() {
      uni.navigateTo({
        url: "/subpkg/favorites/favorites",
      });
    },
    goToAddressList() {
      uni.navigateTo({
        url: "/pages/address-list/address-list",
      });
    },
    goToNotice() {
      uni.navigateTo({
        url: "/subpkg/notice/notice",
      });
    },
    editProfile() {
      uni.navigateTo({
        url: "/subpkg/edit-profile/edit-profile",
      });
    },
    changePassword() {
      uni.navigateTo({
        url: "/subpkg/change-password/change-password",
      });
    },
    contactService() {
      uni.navigateTo({
        url: "/subpkg/customer-service/customer-service",
      });
    },
    closeContactModal() {
      this.showContactModal = false;
    },
    callHotline() {
      this.showContactModal = false;
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
    openOnlineService() {
      this.showContactModal = false;
      this.showOnlineService = true;
    },
    closeOnlineService() {
      this.showOnlineService = false;
    },
    copyWechat() {
      uni.setClipboardData({
        data: "bookmall_service",
        success: () => {
          uni.showToast({
            title: "已复制",
            icon: "success",
          });
          this.showOnlineService = false;
        },
      });
    },
    aboutUs() {
      uni.showModal({
        title: "关于我们",
        content: "OpenBook V1.0.0\n\n一个专注于图书交易的在线商城平台",
        showCancel: false,
      });
    },
    async logout() {
      const res = await new Promise((resolve) => {
        uni.showModal({
          title: "提示",
          content: "确定要退出登录吗？",
          success: (modalRes) => {
            resolve(modalRes.confirm);
          },
        });
      });

      if (res) {
        uni.removeStorageSync("token");
        uni.removeStorageSync("userInfo");
        uni.showToast({
          title: "已退出登录",
          icon: "success",
        });
        setTimeout(() => {
          uni.reLaunch({
            url: "/pages/login/login",
          });
        }, 1500);
      }
    },
  },
};
</script>

<style scoped>
.user-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 40rpx;
}

.user-card {
  background: linear-gradient(135deg, #15803d 0%, #166534 100%);
  padding: 60rpx 30rpx;
}

.user-info {
  display: flex;
  align-items: center;
}

.avatar {
  width: 120rpx;
  height: 120rpx;
  border-radius: 60rpx;
  background-color: #fff;
  margin-right: 30rpx;
}

.info-content {
  flex: 1;
  color: #fff;
}

.username {
  display: block;
  font-size: 36rpx;
  font-weight: bold;
  margin-bottom: 8rpx;
}

.order-section {
  background-color: #fff;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.more-btn {
  font-size: 26rpx;
  color: #999;
}

.order-icons {
  display: flex;
  justify-content: space-around;
}

.order-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

.order-item .icon {
  font-size: 48rpx;
  margin-bottom: 12rpx;
}

.order-item .label {
  font-size: 26rpx;
  color: #666;
}

.order-item .badge {
  position: absolute;
  top: -10rpx;
  right: -10rpx;
  min-width: 32rpx;
  height: 32rpx;
  background-color: #15803d;
  color: #fff;
  font-size: 20rpx;
  border-radius: 16rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0 8rpx;
}

.menu-section {
  background-color: #fff;
  margin-bottom: 20rpx;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 32rpx 30rpx;
  border-bottom: 1px solid #f5f5f5;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-item .icon {
  font-size: 40rpx;
  margin-right: 24rpx;
}

.menu-item .label {
  flex: 1;
  font-size: 28rpx;
  color: #333;
}

.menu-item .arrow {
  font-size: 28rpx;
  color: #999;
}

.logout-section {
  padding: 40rpx 30rpx;
}

.btn-logout {
  width: 100%;
  height: 88rpx;
  background-color: #fff;
  color: #15803d;
  border-radius: 44rpx;
  font-size: 30rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
}

.custom-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.modal-content {
  width: 600rpx;
  background-color: #fff;
  border-radius: 24rpx;
  overflow: hidden;
}

.modal-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #333;
  text-align: center;
  padding: 40rpx 30rpx 20rpx;
}

.modal-body {
  padding: 20rpx 40rpx 40rpx;
}

.info-line {
  font-size: 28rpx;
  color: #666;
  line-height: 1.8;
}

.info-line.center {
  text-align: center;
}

.info-line.bold {
  font-weight: bold;
  color: #333;
}

.modal-buttons.vertical {
  flex-direction: column;
  border-top: none;
  padding: 0 30rpx 30rpx;
}

.modal-buttons.vertical .full-width {
  width: 100%;
  margin-bottom: 20rpx;
}

.modal-buttons.vertical .full-width:last-of-type {
  margin-bottom: 0;
}

.btn-confirm.full-width {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  background-color: #f5f5f5;
  color: #333;
  border-radius: 44rpx;
  font-size: 30rpx;
  font-weight: normal;
  border: none;
}

.btn-confirm.full-width.green {
  background-color: #15803d;
  color: #fff;
}

.btn-cancel-text {
  background: none;
  border: none;
  color: #999;
  font-size: 28rpx;
  margin-top: 20rpx;
  padding: 0;
}

.modal-buttons {
  display: flex;
  border-top: 1rpx solid #eee;
}

.btn-cancel,
.btn-confirm {
  flex: 1;
  height: 96rpx;
  line-height: 96rpx;
  text-align: center;
  font-size: 30rpx;
  border: none;
  background: #fff;
}

.btn-cancel {
  color: #999;
  border-right: 1rpx solid #eee;
}

.btn-confirm {
  color: #15803d;
  font-weight: 600;
}
</style>
