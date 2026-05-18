<template>
  <view class="refund-container">
    <!-- 订单信息 -->
    <view class="order-section" v-if="order">
      <view class="section-title">订单信息</view>
      <view class="order-info">
        <text class="order-id"
          >订单号：{{ order.orderNo || order.orderNumber || "无" }}</text
        >
      </view>
    </view>

    <!-- 单一商品模式 -->
    <view class="single-item-section" v-if="singleItem">
      <view class="section-title">退款商品</view>
      <view class="single-item-card">
        <image
          class="item-cover"
          :src="singleItem.coverImage"
          mode="aspectFill"
        ></image>
        <view class="item-info">
          <text class="item-name">{{
            singleItem.bookName || singleItem.bookTitle || "未知书名"
          }}</text>
          <text class="item-author" v-if="singleItem.author">{{
            singleItem.author
          }}</text>
          <view class="item-bottom">
            <text class="item-price">¥{{ singleItem.price || 0 }}</text>
            <text class="item-quantity">x{{ singleItem.quantity || 1 }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 多商品选择模式 -->
    <view class="items-section" v-else>
      <view class="section-title">选择退款商品</view>
      <view
        class="item-card"
        v-for="item in orderItems"
        :key="item.id"
        :class="{ selected: selectedItems.includes(item.id) }"
        @click="toggleSelectItem(item)"
      >
        <view class="checkbox">
          <text v-if="selectedItems.includes(item.id)">✓</text>
        </view>
        <image
          class="item-cover"
          :src="item.coverImage"
          mode="aspectFill"
        ></image>
        <view class="item-info">
          <text class="item-name">{{ item.bookName }}</text>
          <view class="item-bottom">
            <text class="item-price">¥{{ item.price }}</text>
            <text class="item-quantity">x{{ item.quantity }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 退款原因 -->
    <view class="reason-section">
      <view class="section-title">退款原因</view>
      <view class="reason-type">
        <picker
          :range="reasonTypes"
          range-key="label"
          :value="reasonTypeIndex"
          @change="onReasonTypeChange"
        >
          <view class="picker-value">
            <text>{{ reasonTypes[reasonTypeIndex].label }}</text>
            <text class="arrow">></text>
          </view>
        </picker>
      </view>
      <textarea
        class="reason-textarea"
        v-model="reasonDescription"
        placeholder="请详细描述退款原因（选填）"
        maxlength="200"
      ></textarea>
    </view>

    <!-- 退款金额 -->
    <view class="amount-section">
      <view class="section-title">退款金额</view>
      <view class="amount-display">
        <text class="amount-label">预计退款：</text>
        <text class="amount-value">¥{{ refundAmount }}</text>
      </view>
    </view>

    <!-- 提交按钮 -->
    <view class="submit-section">
      <button
        class="btn-submit"
        @click="submitRefund"
        :disabled="
          submitting || (showItemSelector && selectedItems.length === 0)
        "
      >
        {{ submitting ? "提交中..." : "提交退款申请" }}
      </button>
    </view>
  </view>
</template>

<script>
import { getOrderDetail } from "../../api/order.js";
import { applyRefundByItem } from "../../api/refund.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      orderId: null,
      order: null,
      orderItems: [],
      selectedItems: [],
      reasonTypes: [
        { label: "商品损坏", value: "damaged" },
        { label: "商品与描述不符", value: "not-match" },
        { label: "错拍/多拍", value: "wrong-order" },
        { label: "不想买了", value: "dont-want" },
        { label: "其他", value: "other" },
      ],
      reasonTypeIndex: 0,
      reasonDescription: "",
      submitting: false,
      preSelectedBookId: null,
    };
  },
  computed: {
    showItemSelector() {
      return !this.preSelectedBookId;
    },
    singleItem() {
      if (!this.preSelectedBookId) return null;
      return this.orderItems.find((item) => item.id == this.preSelectedBookId);
    },
    refundAmount() {
      if (this.preSelectedBookId && this.singleItem) {
        const item = this.singleItem;
        const price = parseFloat(item.price) || 0;
        const qty = parseInt(item.quantity) || 0;
        return (price * qty).toFixed(2);
      }
      return this.orderItems
        .filter((item) => this.selectedItems.includes(item.id))
        .reduce((sum, item) => {
          const price = parseFloat(item.price) || 0;
          const qty = parseInt(item.quantity) || 0;
          return sum + price * qty;
        }, 0)
        .toFixed(2);
    },
  },
  onLoad(options) {
    if (options.orderId) {
      this.orderId = options.orderId;
    }
    if (options.bookId) {
      this.preSelectedBookId = parseInt(options.bookId);
    }
    this.loadOrderDetail();
  },
  methods: {
    async loadOrderDetail() {
      try {
        const res = await getOrderDetail(this.orderId);
        if (res.code === 200) {
          const orderData = res.data.order || res.data;
          this.order = {
            ...orderData,
            orderNo: orderData.orderNumber || orderData.orderNo,
          };
          const items = res.data.items || [];
          this.orderItems = items.map((item) => ({
            ...item,
            coverImage: item.coverImage
              ? getImageUrl(item.coverImage)
              : "/static/default-cover.png",
            price: item.price || item.bookPrice || 0,
          }));
        }
      } catch (error) {
        console.error("加载订单详情失败:", error);
        uni.showToast({
          title: "加载失败",
          icon: "none",
        });
      }
    },
    toggleSelectItem(item) {
      const index = this.selectedItems.indexOf(item.id);
      if (index > -1) {
        this.selectedItems.splice(index, 1);
      } else {
        this.selectedItems.push(item.id);
      }
    },
    onReasonTypeChange(e) {
      this.reasonTypeIndex = e.detail.value;
    },
    async submitRefund() {
      const userInfo = uni.getStorageSync("userInfo");
      if (!userInfo || !userInfo.id) {
        uni.showToast({
          title: "请先登录",
          icon: "none",
        });
        return;
      }

      this.submitting = true;
      try {
        const reason = this.reasonTypes[this.reasonTypeIndex].label;
        let promises = [];

        if (this.preSelectedBookId && this.singleItem) {
          promises = [
            applyRefundByItem({
              orderId: this.orderId,
              orderItemId: this.singleItem.id,
              userId: userInfo.id,
              reason: reason,
              description: this.reasonDescription,
            }),
          ];
        } else {
          if (this.selectedItems.length === 0) {
            uni.showToast({
              title: "请选择退款商品",
              icon: "none",
            });
            this.submitting = false;
            return;
          }
          promises = this.selectedItems.map((itemId) => {
            return applyRefundByItem({
              orderId: this.orderId,
              orderItemId: itemId,
              userId: userInfo.id,
              reason: reason,
              description: this.reasonDescription,
            });
          });
        }

        await Promise.all(promises);

        uni.showToast({
          title: "退款申请已提交",
          icon: "success",
        });

        setTimeout(() => {
          uni.redirectTo({
            url: `/pages/order-detail/order-detail?id=${this.orderId}`,
          });
        }, 1500);
      } catch (error) {
        console.error("提交退款失败:", error);
        uni.showToast({
          title: "提交失败",
          icon: "none",
        });
      } finally {
        this.submitting = false;
      }
    },
  },
};
</script>

<style scoped>
.refund-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 120rpx;
}

.section-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  padding: 20rpx 30rpx;
}

.order-section {
  background-color: #fff;
  margin-bottom: 20rpx;
}

.order-info {
  padding: 0 30rpx 20rpx;
}

.single-item-section {
  background-color: #fff;
  margin-bottom: 20rpx;
}

.single-item-card {
  display: flex;
  align-items: center;
  padding: 20rpx 30rpx;
  background-color: #fafafa;
  border-radius: 12rpx;
  margin: 0 30rpx 20rpx;
}

.single-item-card .item-cover {
  width: 150rpx;
  height: 200rpx;
  border-radius: 8rpx;
  margin-right: 24rpx;
  flex-shrink: 0;
}

.single-item-card .item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.single-item-card .item-name {
  font-size: 30rpx;
  color: #333;
  font-weight: 500;
  margin-bottom: 12rpx;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.single-item-card .item-author {
  font-size: 26rpx;
  color: #999;
  margin-bottom: 16rpx;
}

.single-item-card .item-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.single-item-card .item-price {
  font-size: 32rpx;
  color: #ee4b2b;
  font-weight: bold;
}

.single-item-card .item-quantity {
  font-size: 28rpx;
  color: #999;
}

.order-id {
  font-size: 26rpx;
  color: #666;
}

.items-section {
  background-color: #fff;
  margin-bottom: 20rpx;
}

.item-card {
  display: flex;
  align-items: center;
  padding: 20rpx 30rpx;
  border-bottom: 1px solid #f5f5f5;
}

.item-card:last-child {
  border-bottom: none;
}

.item-card.selected {
  background-color: #f0f9ff;
}

.checkbox {
  width: 40rpx;
  height: 40rpx;
  border: 2px solid #ddd;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
  font-size: 24rpx;
  color: #15803d;
}

.item-card.selected .checkbox {
  border-color: #15803d;
  background-color: #15803d;
  color: #fff;
}

.item-cover {
  width: 120rpx;
  height: 160rpx;
  border-radius: 8rpx;
  margin-right: 20rpx;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 28rpx;
  color: #333;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.item-bottom {
  display: flex;
  justify-content: space-between;
  margin-top: 12rpx;
}

.item-price {
  font-size: 28rpx;
  color: #ee4b2b;
}

.item-quantity {
  font-size: 26rpx;
  color: #999;
}

.reason-section {
  background-color: #fff;
  margin-bottom: 20rpx;
  padding-bottom: 20rpx;
}

.reason-type {
  padding: 0 30rpx 20rpx;
}

.picker-value {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx;
  background-color: #f5f5f5;
  border-radius: 12rpx;
  font-size: 28rpx;
  color: #333;
}

.arrow {
  color: #999;
}

.reason-textarea {
  margin: 0 30rpx;
  padding: 20rpx;
  width: calc(100% - 100rpx);
  height: 150rpx;
  font-size: 28rpx;
  color: #333;
  background-color: #f5f5f5;
  border-radius: 12rpx;
  box-sizing: border-box;
}

.amount-section {
  background-color: #fff;
  margin-bottom: 20rpx;
  padding-bottom: 20rpx;
}

.amount-display {
  padding: 0 30rpx;
}

.amount-label {
  font-size: 28rpx;
  color: #666;
}

.amount-value {
  font-size: 36rpx;
  color: #ee4b2b;
  font-weight: bold;
}

.submit-section {
  padding: 30rpx;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
}

.btn-submit {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  background-color: #15803d;
  color: #fff;
  font-size: 32rpx;
  border-radius: 44rpx;
  border: none;
}

.btn-submit[disabled] {
  background-color: #a5d6a7;
}
</style>
