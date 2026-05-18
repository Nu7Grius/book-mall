<template>
  <view class="address-list-container">
    <!-- 地址列表 -->
    <view class="address-list" v-if="addressList.length > 0">
      <view
        class="address-item"
        v-for="item in addressList"
        :key="item.id"
        @click="selectAddress(item)"
      >
        <view class="address-info">
          <view class="user-info">
            <text class="username">{{ item.receiverName }}</text>
            <text class="phone">{{ item.phone }}</text>
            <view class="default-tag" v-if="item.isDefault">默认</view>
          </view>
          <view class="address-detail">
            {{ item.province }} {{ item.city }} {{ item.district }}
            {{ item.detail }}
          </view>
        </view>

        <view class="address-actions">
          <view class="action-btn" @click.stop="editAddress(item)">
            <text>编辑</text>
          </view>
          <view class="action-btn delete" @click.stop="deleteAddress(item)">
            <text>删除</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <text class="empty-icon">📍</text>
      <text class="empty-text">暂无收货地址</text>
    </view>

    <!-- 添加地址按钮 -->
    <view class="bottom-bar">
      <button class="btn-add" @click="addAddress">
        <text class="icon">+</text>
        <text>添加新地址</text>
      </button>
    </view>
  </view>
</template>

<script>
import {
  getAddressList,
  deleteAddress as deleteAddressApi,
  setDefaultAddress,
} from "../../api/address.js";

export default {
  data() {
    return {
      addressList: [],
      isSelectMode: false,
    };
  },
  onLoad(options) {
    if (options.select === "true") {
      this.isSelectMode = true;
      uni.setNavigationBarTitle({
        title: "选择收货地址",
      });
    }
    this.loadAddressList();
  },
  onShow() {
    this.loadAddressList();
  },
  methods: {
    async loadAddressList() {
      const userInfo = uni.getStorageSync("userInfo");
      if (!userInfo || !userInfo.id) {
        return;
      }
      try {
        const res = await getAddressList(userInfo.id);
        if (res.code === 200) {
          this.addressList = res.data || [];
        }
      } catch (error) {
        console.error("加载地址列表失败:", error);
      }
    },
    selectAddress(item) {
      if (this.isSelectMode) {
        uni.setStorageSync("selectedAddress", item);
        uni.navigateBack();
      }
    },
    editAddress(item) {
      uni.navigateTo({
        url: `/pages/address-edit/address-edit?id=${item.id}`,
      });
    },
    async deleteAddress(item) {
      const res = await new Promise((resolve) => {
        uni.showModal({
          title: "提示",
          content: "确定要删除该地址吗？",
          success: (modalRes) => {
            resolve(modalRes.confirm);
          },
        });
      });

      if (res) {
        try {
          await deleteAddressApi(item.id);
          uni.showToast({
            title: "删除成功",
            icon: "success",
          });
          this.loadAddressList();
        } catch (error) {
          console.error("删除地址失败:", error);
        }
      }
    },
    addAddress() {
      uni.navigateTo({
        url: "/pages/address-edit/address-edit",
      });
    },
  },
};
</script>

<style scoped>
.address-list-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20rpx;
  padding-bottom: 140rpx;
}

.address-list {
  display: flex;
  flex-direction: column;
}

.address-item {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.address-info {
  margin-bottom: 20rpx;
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

.default-tag {
  background-color: #15803d;
  color: #fff;
  font-size: 20rpx;
  padding: 4rpx 12rpx;
  border-radius: 4rpx;
  margin-left: 16rpx;
}

.address-detail {
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
}

.address-actions {
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid #f5f5f5;
  padding-top: 20rpx;
}

.action-btn {
  padding: 10rpx 30rpx;
  font-size: 26rpx;
  color: #666;
}

.action-btn.delete {
  color: #15803d;
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

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 20rpx 30rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background-color: #fff;
  box-shadow: 0 -2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.btn-add {
  width: 100%;
  height: 88rpx;
  background: linear-gradient(135deg, #15803d 0%, #166534 100%);
  color: #fff;
  border-radius: 44rpx;
  font-size: 30rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
}

.btn-add .icon {
  font-size: 40rpx;
  margin-right: 10rpx;
}
</style>
