<template>
  <view class="order-list-container">
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

    <!-- 状态标签 -->
    <view class="status-tabs">
      <view
        class="tab-item"
        v-for="tab in tabs"
        :key="tab.value"
        :class="{ active: currentTab === tab.value }"
        @click="changeTab(tab.value)"
      >
        <text>{{ tab.label }}</text>
        <view class="tab-indicator" v-if="currentTab === tab.value"></view>
      </view>
    </view>

    <!-- 订单列表 -->
    <view class="order-list">
      <!-- 订单卡片 -->
      <view
        v-for="order in filteredOrders"
        :key="order.id"
        class="order-card"
        @click="goToDetail(order)"
      >
        <!-- 卡片头部 - 店铺信息和状态 -->
        <view class="card-header">
          <view class="shop-info">
            <view class="shop-avatar">
              <image
                v-if="order.merchantLogo"
                :src="order.merchantLogo"
                mode="aspectFill"
                class="avatar-img"
              ></image>
              <text v-else>{{ getMerchantIcon(order) }}</text>
            </view>
            <view class="shop-detail">
              <text class="shop-name">{{ getMerchantName(order) }}</text>
              <text class="order-time">{{
                formatOrderTime(order.createTime)
              }}</text>
            </view>
          </view>
          <view
            class="status-badge"
            :class="{
              'badge-pending': order.orderStatus === '待付款',
              'badge-review': order.orderStatus === '待评价',
              'badge-shipped': order.orderStatus === '待发货',
              'badge-received': order.orderStatus === '待收货',
              'badge-completed':
                order.orderStatus === '交易完成' ||
                order.orderStatus === '已完成',
              'badge-cancelled':
                order.orderStatus === '订单已取消' ||
                order.orderStatus === '已取消',
              'badge-refunding':
                order.orderStatus === '退款处理中' ||
                order.orderStatus === '退款中',
              'badge-refunded': order.orderStatus === '已退款',
            }"
          >
            <text>{{ getStatusText(order.orderStatus) }}</text>
          </view>
        </view>

        <!-- 商品信息 -->
        <view class="card-goods">
          <view
            v-for="(item, idx) in (order.items || []).slice(0, 2)"
            :key="idx"
            class="goods-item"
          >
            <image
              class="goods-cover"
              :src="item.coverImage"
              mode="aspectFill"
              @error="onImageError($event, idx)"
            ></image>
            <view class="goods-detail">
              <view class="goods-header">
                <text class="goods-name">{{ item.bookName }}</text>
                <view
                  class="item-status-tag"
                  :class="{
                    'status-orange':
                      item.status === '待付款' ||
                      item.status === '退款中' ||
                      item.status === '待评价',
                    'status-blue': item.status === '待发货',
                    'status-green':
                      item.status === '已完成' || item.status === '待收货',
                    'status-red':
                      item.status === '已退款' || item.status === '已取消',
                  }"
                >
                  <text>{{ getItemStatusText(item.status) }}</text>
                </view>
              </view>
              <view class="goods-bottom">
                <text class="goods-author">{{
                  item.author || "未知作者"
                }}</text>
                <text class="goods-price">¥{{ formatAmount(item.price) }}</text>
              </view>
              <text class="goods-quantity">x{{ item.quantity }}</text>
            </view>
          </view>

          <!-- 商品数量提示 -->
          <view class="goods-tip" v-if="(order.items || []).length > 2">
            <text>共{{ (order.items || []).length }}件商品</text>
            <text class="tip-arrow">›</text>
          </view>
        </view>

        <!-- 卡片底部 - 价格和操作 -->
        <view class="card-footer">
          <view class="price-info">
            <text class="price-label">合计</text>
            <text class="price-value"
              >¥{{ formatAmount(order.totalAmount) }}</text
            >
          </view>
          <view class="action-buttons">
            <!-- 待付款 -->
            <view v-if="order.orderStatus === '待付款'" class="button-group">
              <button class="btn-cancel" @click.stop="cancelOrder(order)">
                取消订单
              </button>
              <button class="btn-primary" @click.stop="payOrder(order)">
                去支付
              </button>
            </view>

            <!-- 待发货 -->
            <view v-if="order.orderStatus === '待发货'" class="button-group">
              <button class="btn-remind" @click.stop="remindShip(order)">
                提醒发货
              </button>
            </view>

            <!-- 待收货 -->
            <view v-if="order.orderStatus === '待收货'" class="button-group">
              <button class="btn-primary" @click.stop="confirmReceive(order)">
                确认收货
              </button>
            </view>

            <!-- 待评价 -->
            <view v-if="order.orderStatus === '待评价'" class="button-group">
              <button class="btn-primary" @click.stop="goToComment(order)">
                去评价
              </button>
            </view>

            <!-- 已完成 -- 无操作 -->

            <!-- 退款中 -->
            <view v-if="order.orderStatus === '退款中'">
              <button class="btn-view" @click.stop="goToDetail(order)">
                查看详情
              </button>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view class="empty-state" v-if="orderList.length === 0 && !loading">
        <view class="empty-illustration">�</view>
        <text class="empty-title">暂无订单</text>
        <text class="empty-desc">快去挑选心仪的书籍吧</text>
        <button class="btn-go-shop" @click="goToHome">
          <text>去逛逛</text>
        </button>
      </view>

      <!-- 加载状态 -->
      <view class="loading-container" v-if="loading">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 没有更多 -->
      <view class="no-more" v-if="noMore && orderList.length > 0">
        <text>— 没有更多订单了 —</text>
      </view>
    </view>
  </view>
</template>

<script>
import {
  getOrderList,
  cancelOrder as cancelOrderApi,
  confirmReceive as confirmReceiveApi,
  remindShip as remindShipApi,
} from "../../api/order.js";
import config from "../../config/index.js";

export default {
  data() {
    return {
      tabs: [
        { label: "全部", value: -1 },
        { label: "待支付", value: 0 },
        { label: "待发货", value: 1 },
        { label: "待收货", value: 2 },
        { label: "待评价", value: 3 },
        { label: "已完成", value: 4 },
      ],
      currentTab: -1,
      orderList: [],
      allOrderList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      noMore: false,
      refreshing: false,
      userId: null,
      searchKey: "",
      isSearching: false,
    };
  },
  computed: {
    filteredOrders() {
      if (!this.searchKey) {
        return this.orderList;
      }
      const keyword = this.searchKey.toLowerCase().trim();
      return this.orderList.filter((order) => {
        const items = order.items || [];
        return items.some(
          (item) =>
            (item.bookName || "").toLowerCase().includes(keyword) ||
            (item.author || "").toLowerCase().includes(keyword)
        );
      });
    },
  },
  onLoad() {
    const userInfo = uni.getStorageSync("userInfo");
    if (!userInfo || !userInfo.id) {
      uni.showToast({ title: "请先登录", icon: "none" });
      setTimeout(() => {
        uni.reLaunch({
          url: "/pages/login/login",
        });
      }, 1500);
      return;
    }
    this.userId = userInfo.id;

    const filterStatus = uni.getStorageSync("orderListFilterStatus");
    if (
      filterStatus !== undefined &&
      filterStatus !== null &&
      filterStatus !== ""
    ) {
      uni.removeStorageSync("orderListFilterStatus");
      this.currentTab = filterStatus;
    }

    this.loadOrders(true);
  },
  onShow() {
    const filterStatus = uni.getStorageSync("orderListFilterStatus");
    if (
      filterStatus !== undefined &&
      filterStatus !== null &&
      filterStatus !== ""
    ) {
      uni.removeStorageSync("orderListFilterStatus");
      if (this.currentTab !== filterStatus) {
        this.currentTab = filterStatus;
        this.loadOrders(true);
      }
    }
  },
  methods: {
    handleSearch() {
      if (this.searchKey.trim()) {
        this.isSearching = true;
      }
    },
    clearSearch() {
      this.searchKey = "";
      this.isSearching = false;
    },
    async loadOrders(reset = false) {
      if (this.loading || !this.userId) return;
      if (reset) {
        this.page = 1;
        this.noMore = false;
      }

      this.loading = true;
      try {
        const params = {
          page: this.page,
          pageSize: this.size,
        };
        if (this.currentTab !== -1) {
          params.status = this.currentTab;
        }

        const res = await getOrderList(this.userId, params);

        if (res.code === 200) {
          let data = res.data.records || res.data || [];
          data = data.map((order) => ({
            ...order,
            orderStatus: order.orderStatus || order.status || "未知",
            merchantLogo: this.getFullImageUrl(order.merchantLogo),
            items: (order.items || []).map((item) => ({
              ...item,
              coverImage: this.getFullImageUrl(item.coverImage),
            })),
          }));
          if (reset) {
            this.orderList = data;
          } else {
            this.orderList = [...this.orderList, ...data];
          }
          this.total = res.data.total || data.length || 0;
          this.noMore = data.length < this.size;
          this.page++;
        }
      } catch (error) {
        console.error("加载订单失败:", error);
      } finally {
        this.loading = false;
        this.refreshing = false;
      }
    },
    loadMore() {
      if (!this.noMore && !this.loading) {
        this.page++;
        this.loadOrders();
      }
    },
    onRefresh() {
      this.refreshing = true;
      this.loadOrders(true);
    },
    changeTab(value) {
      if (this.currentTab !== value) {
        this.currentTab = value;
        this.loadOrders(true);
      }
    },
    getStatusText(status) {
      if (!status) {
        return "未知";
      }
      const map = {
        0: "待支付",
        1: "待发货",
        2: "待收货",
        3: "已完成",
        4: "已取消",
        5: "退款中",
        6: "已退款",
        待付款: "待支付",
        待发货: "待发货",
        待收货: "待收货",
        待评价: "待评价",
        交易完成: "已完成",
        已完成: "已完成",
        订单已取消: "已取消",
        已取消: "已取消",
        退款处理中: "退款中",
        退款中: "退款中",
        已退款: "已退款",
      };
      return map[status] || map[String(status)] || status;
    },
    getItemStatusText(status) {
      if (!status) {
        return "未知";
      }
      const map = {
        待付款: "待付款",
        待发货: "待发货",
        待收货: "待收货",
        待评价: "待评价",
        已完成: "已完成",
        退款中: "退款中",
        已退款: "已退款",
        已取消: "已取消",
      };
      return map[status] || status;
    },
    getStatusBadgeClass(status) {
      const badgeMap = {
        待付款: "badge-pending",
        待发货: "badge-shipped",
        待收货: "badge-received",
        交易完成: "badge-completed",
        已完成: "badge-completed",
        订单已取消: "badge-cancelled",
        已取消: "badge-cancelled",
        退款处理中: "badge-refunding",
        退款中: "badge-refunding",
      };
      return badgeMap[status] || "badge-default";
    },
    getDisplayItems(order) {
      const items = order.items || order.orderItems || [];
      return items.slice(0, 2);
    },
    getMerchantName(order) {
      if (order.items && order.items.length > 0) {
        const merchantName =
          order.items[0].merchantName || order.merchantNameDisplay;
        if (merchantName) return merchantName;
      }
      if (order.merchantNameDisplay) {
        return order.merchantNameDisplay;
      }
      return "书魂商城";
    },
    formatAmount(amount) {
      if (amount === null || amount === undefined || amount === "") {
        return "0.00";
      }
      const num = typeof amount === "number" ? amount : parseFloat(amount);
      return isNaN(num) ? "0.00" : num.toFixed(2);
    },
    getMerchantIcon(order) {
      const merchantName = this.getMerchantName(order);
      if (merchantName.includes("茑屋")) return "📖";
      if (merchantName.includes("西西弗")) return "📚";
      if (merchantName.includes("新华")) return "�";
      if (merchantName.includes("当当")) return "📗";
      if (merchantName.includes("博库")) return "�";
      return "🏪";
    },
    getFullImageUrl(url) {
      if (!url) return "/static/default-cover.png";
      if (url.startsWith("http://") || url.startsWith("https://")) {
        return url;
      }
      return config.imgUrl + url;
    },
    onImageError(e, index) {
      e.target.src = "/static/default-cover.png";
    },
    getItemCount(order) {
      const items = order.items || order.orderItems || [];
      return items.length;
    },
    formatOrderTime(time) {
      if (!time) return "";
      const date = new Date(time);
      const month = (date.getMonth() + 1).toString().padStart(2, "0");
      const day = date.getDate().toString().padStart(2, "0");
      const hour = date.getHours().toString().padStart(2, "0");
      const minute = date.getMinutes().toString().padStart(2, "0");
      return `${month}-${day} ${hour}:${minute}`;
    },
    copyOrderNo(order) {
      const orderNo = order.orderNumber || order.orderNo;
      uni.setClipboardData({
        data: orderNo,
        success: () => {
          uni.showToast({ title: "订单号已复制", icon: "success" });
        },
      });
    },
    goToDetail(orderId) {
      if (typeof orderId === "object") {
        orderId = orderId.id;
      }
      uni.navigateTo({
        url: `/pages/order-detail/order-detail?id=${orderId}`,
      });
    },
    goToHome() {
      uni.switchTab({
        url: "/pages/home/home",
      });
    },
    goToComment(order) {
      const orderId = typeof order === "object" ? order.id : order;
      uni.navigateTo({
        url: `/pages/order-detail/order-detail?id=${orderId}&action=comment`,
      });
    },
    async cancelOrder(order) {
      try {
        await uni.showModal({
          title: "提示",
          content: "确定要取消该订单吗？",
        });
        await cancelOrderApi(order.id);
        uni.showToast({ title: "订单已取消", icon: "success" });
        this.loadOrders(true);
      } catch (error) {
        console.error("取消订单失败:", error);
        uni.showToast({ title: "取消失败", icon: "none" });
      }
    },
    async confirmReceive(order) {
      try {
        await uni.showModal({
          title: "确认收货",
          content: "确认已收到商品？",
        });
        await confirmReceiveApi(order.id);
        uni.showToast({ title: "已确认收货", icon: "success" });
        this.loadOrders(true);
      } catch (error) {
        console.error("确认收货失败:", error);
        uni.showToast({ title: "操作失败", icon: "none" });
      }
    },
    async remindShip(order) {
      try {
        await remindShipApi(order.id);
        uni.showToast({ title: "已提醒商家发货", icon: "success" });
      } catch (error) {
        console.error("提醒发货失败:", error);
        uni.showToast({ title: "提醒失败", icon: "none" });
      }
    },
    payOrder(order) {
      uni.navigateTo({
        url: `/pages/order-detail/order-detail?id=${order.id}&action=pay`,
      });
    },
  },
};
</script>

<style scoped>
/* 页面容器 */
.order-list-container {
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

/* 状态标签 */
.status-tabs {
  display: flex;
  background-color: #fff;
  padding: 20rpx 30rpx;
  border-bottom: 1rpx solid #e8e8e8;
  position: sticky;
  top: 0;
  z-index: 100;
}

.tab-item {
  flex: 1;
  text-align: center;
  padding: 16rpx 0;
  font-size: 28rpx;
  color: #666;
  position: relative;
  transition: all 0.3s ease;
}

.tab-item.active {
  color: #15803d;
  font-weight: 600;
}

.tab-indicator {
  position: absolute;
  bottom: -4rpx;
  left: 50%;
  transform: translateX(-50%);
  width: 40rpx;
  height: 6rpx;
  background: linear-gradient(135deg, #15803d 0%, #22c55e 100%);
  border-radius: 3rpx;
}

/* 订单列表 */
.order-list {
  padding: 20rpx 30rpx;
  padding-top: 30rpx;
}

/* 订单卡片 */
.order-card {
  background-color: #fff;
  border-radius: 24rpx;
  margin-bottom: 30rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
}

.order-card:active {
  transform: scale(0.98);
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.04);
}

/* 卡片头部 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #f5f5f5;
  background: linear-gradient(90deg, #fafbfc 0%, #ffffff 100%);
}

.shop-info {
  display: flex;
  align-items: center;
}

.shop-avatar {
  width: 72rpx;
  height: 72rpx;
  background: linear-gradient(135deg, #15803d 0%, #22c55e 100%);
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36rpx;
  margin-right: 20rpx;
  box-shadow: 0 4rpx 12rpx rgba(21, 128, 61, 0.3);
  overflow: hidden;
}

.avatar-img {
  width: 100%;
  height: 100%;
  border-radius: 16rpx;
}

.shop-detail {
  display: flex;
  flex-direction: column;
}

.shop-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 6rpx;
}

.order-time {
  font-size: 24rpx;
  color: #999;
}

/* 状态徽章 - 统一颜色规则：
   待付款/待评价/退款中: 橙色
   待发货: 蓝色
   待收货/已完成: 绿色
   已取消/已退款: 红色
*/
.status-badge {
  padding: 10rpx 24rpx;
  border-radius: 30rpx;
  font-size: 26rpx;
  font-weight: 500;
}

.status-badge.badge-pending {
  color: #ff9800;
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
}

.status-badge.badge-review {
  color: #ff9800;
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
}

.status-badge.badge-shipped {
  color: #2196f3;
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
}

.status-badge.badge-received {
  color: #4caf50;
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
}

.status-badge.badge-completed {
  color: #4caf50;
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
}

.status-badge.badge-cancelled {
  color: #f44336;
  background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
}

.status-badge.badge-refunding {
  color: #ff9800;
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
}

.status-badge.badge-refunded {
  color: #f44336;
  background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
}

/* 商品信息 */
.card-goods {
  padding: 30rpx;
}

.goods-item {
  display: flex;
  margin-bottom: 30rpx;
}

.goods-item:last-child {
  margin-bottom: 0;
}

.goods-cover {
  width: 180rpx;
  height: 180rpx;
  border-radius: 16rpx;
  background: linear-gradient(135deg, #f5f5f5 0%, #eeeeee 100%);
  flex-shrink: 0;
}

.goods-detail {
  flex: 1;
  margin-left: 30rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  position: relative;
}

.goods-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8rpx;
}

.goods-name {
  font-size: 28rpx;
  color: #333;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
  font-weight: 500;
  flex: 1;
  margin-right: 12rpx;
}

.item-status-tag {
  padding: 4rpx 12rpx;
  border-radius: 8rpx;
  font-size: 20rpx;
  flex-shrink: 0;
}

.item-status-tag.status-orange {
  color: #ff9800;
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
}

.item-status-tag.status-blue {
  color: #2196f3;
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
}

.item-status-tag.status-green {
  color: #4caf50;
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
}

.item-status-tag.status-red {
  color: #f44336;
  background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
}

.item-status-tag.status-gray {
  color: #999;
  background: linear-gradient(135deg, #f5f5f5 0%, #eeeeee 100%);
}

.goods-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12rpx;
}

.goods-author {
  font-size: 24rpx;
  color: #999;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.goods-price {
  font-size: 32rpx;
  color: #15803d;
  font-weight: 700;
  margin-left: 20rpx;
}

.goods-quantity {
  position: absolute;
  right: 0;
  bottom: 0;
  font-size: 26rpx;
  color: #999;
}

/* 商品数量提示 */
.goods-tip {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20rpx;
  background: linear-gradient(90deg, #f9fafb 0%, #f5f5f5 100%);
  border-radius: 12rpx;
  margin-top: 20rpx;
}

.goods-tip text {
  font-size: 26rpx;
  color: #666;
}

.tip-arrow {
  font-size: 32rpx;
  color: #999;
  margin-left: 8rpx;
}

/* 收货信息 */
.card-receiver {
  display: flex;
  align-items: center;
  padding: 24rpx 30rpx;
  background: linear-gradient(90deg, #f9fbf9 0%, #f5f9f5 100%);
  border-top: 1rpx solid #f5f5f5;
  border-bottom: 1rpx solid #f5f5f5;
}

.receiver-icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.receiver-text {
  flex: 1;
  font-size: 26rpx;
  color: #666;
  line-height: 1.5;
}

/* 卡片底部 */
.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  background: #fff;
}

.price-info {
  display: flex;
  flex-direction: column;
}

.price-label {
  font-size: 24rpx;
  color: #999;
  margin-bottom: 4rpx;
}

.price-value {
  font-size: 40rpx;
  font-weight: 700;
  color: #15803d;
  line-height: 1.2;
}

/* 操作按钮 */
.action-buttons {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.button-group {
  display: flex;
  gap: 20rpx;
  margin-bottom: 10rpx;
}

.button-group:last-child {
  margin-bottom: 0;
}

.action-buttons button {
  padding: 16rpx 32rpx;
  font-size: 26rpx;
  border-radius: 30rpx;
  border: none;
  line-height: 1.4;
}

.btn-primary {
  background: linear-gradient(135deg, #15803d 0%, #22c55e 100%);
  color: #fff;
  box-shadow: 0 4rpx 12rpx rgba(21, 128, 61, 0.3);
}

.btn-default {
  background-color: #fff;
  color: #666;
  border: 2rpx solid #e0e0e0 !important;
}

.btn-cancel {
  background-color: #fff;
  color: #999;
  border: 2rpx solid #e0e0e0 !important;
}

.btn-warning {
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
  color: #ff9800;
  border: 2rpx solid #ffb74d !important;
}

.btn-remind {
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
  color: #15803d;
  border: 2rpx solid #15803d !important;
}

.btn-refund {
  background: linear-gradient(135deg, #fff4f0 0%, #ffe4d9 100%);
  color: #ff6b35;
  border: 2rpx solid #ff6b35 !important;
}

.btn-view {
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
  color: #ff9800;
  border: 2rpx solid #ff9800 !important;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 60rpx;
}

.empty-illustration {
  font-size: 160rpx;
  margin-bottom: 40rpx;
  opacity: 0.8;
}

.empty-title {
  font-size: 40rpx;
  font-weight: 700;
  color: #333;
  margin-bottom: 16rpx;
}

.empty-desc {
  font-size: 28rpx;
  color: #999;
  margin-bottom: 60rpx;
}

.btn-go-shop {
  padding: 24rpx 80rpx;
  background: linear-gradient(135deg, #15803d 0%, #22c55e 100%);
  color: #fff;
  border-radius: 50rpx;
  font-size: 32rpx;
  font-weight: 600;
  border: none;
  box-shadow: 0 8rpx 24rpx rgba(21, 128, 61, 0.3);
}

.btn-go-shop text {
  color: #fff;
}

/* 加载状态 */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60rpx;
}

.loading-spinner {
  width: 60rpx;
  height: 60rpx;
  border: 4rpx solid #e0e0e0;
  border-top-color: #15803d;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.loading-text {
  font-size: 26rpx;
  color: #999;
  margin-top: 20rpx;
}

/* 没有更多 */
.no-more {
  text-align: center;
  padding: 40rpx;
  color: #999;
  font-size: 26rpx;
}
</style>
