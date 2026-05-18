<template>
  <view class="order-detail-container">
    <!-- 订单状态 -->
    <view class="status-section">
      <view class="status-content">
        <text class="status-icon">{{ statusIcon }}</text>
        <text class="order-status-text">{{ statusText }}</text>
      </view>
    </view>

    <!-- 收货地址 -->
    <view class="address-section">
      <view class="address-icon">📍</view>
      <view class="address-info">
        <view class="user-info">
          <text class="username">{{
            order.receiverName || order.addressName || "未知"
          }}</text>
          <text class="phone">{{
            order.receiverPhone || order.addressPhone || ""
          }}</text>
        </view>
        <view class="address-detail">
          {{ order.address || "" }}
        </view>
      </view>
    </view>

    <!-- 商品列表 -->
    <view class="goods-section">
      <view class="section-title">商品清单</view>
      <view class="goods-list" v-if="orderItems.length > 0">
        <view class="goods-item" v-for="item in orderItems" :key="item.id">
          <image
            class="goods-cover"
            :src="getItemImage(item)"
            mode="aspectFill"
            @click="goToBookDetail(item.bookId)"
          ></image>
          <view class="goods-info">
            <view class="goods-header">
              <text class="goods-name" @click="goToBookDetail(item.bookId)">{{
                item.bookName || item.bookTitle || "未知书名"
              }}</text>
              <view
                class="item-status-tag"
                :class="{
                  'status-blue': getDisplayStatus(item) === '待发货',
                  'status-orange':
                    getDisplayStatus(item) === '待付款' ||
                    getDisplayStatus(item) === '退款中' ||
                    getDisplayStatus(item) === '待评价',
                  'status-green':
                    getDisplayStatus(item) === '已完成' ||
                    getDisplayStatus(item) === '待收货',
                  'status-red':
                    getDisplayStatus(item) === '已退款' ||
                    getDisplayStatus(item) === '已取消',
                }"
                @click="handleStatusClick(item)"
              >
                {{ getItemStatusText(item.status, item.commented) }}
              </view>
            </view>
            <view class="goods-author" v-if="item.author">{{
              item.author
            }}</view>
            <view class="goods-bottom">
              <text class="goods-price">¥{{ getItemPrice(item) }}</text>
              <text class="goods-quantity">x{{ item.quantity || 1 }}</text>
            </view>
            <view class="goods-actions">
              <button
                v-if="item.status === '待发货'"
                class="btn-action-small btn-remind"
                @click="remindShipForItem(item)"
              >
                提醒发货
              </button>
              <button
                v-if="item.status === '待发货'"
                class="btn-action-small btn-refund"
                @click="applyRefundForItem(item)"
              >
                申请退款
              </button>
              <button
                v-if="item.status === '待收货'"
                class="btn-action-small btn-refund"
                @click="applyRefundForItem(item)"
              >
                申请退款
              </button>
              <button
                v-if="item.status === '退款中'"
                class="btn-action-small btn-view"
                @click="viewRefundDetail(item)"
              >
                查看退款
              </button>
              <button
                v-if="item.status === '待评价' && !item.commented"
                class="btn-action-small"
                @click="openCommentPopup(item)"
              >
                去评价
              </button>
              <text
                v-if="item.status === '待评价' && item.commented"
                class="status-text"
              >
                已评价
              </text>
              <text v-if="item.status === '已完成'" class="status-text">
                已完成
              </text>
              <text v-if="item.status === '已退款'" class="status-text">
                已退款
              </text>
              <text v-if="item.status === '已取消'" class="status-text">
                已取消
              </text>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 订单信息 -->
    <view class="info-section">
      <view class="info-row">
        <text class="label">订单编号</text>
        <view class="value-row">
          <text class="value">{{ order.orderNumber || order.orderNo }}</text>
          <text class="copy-btn" @click="copyOrderNo">复制</text>
        </view>
      </view>
      <view class="info-row">
        <text class="label">下单时间</text>
        <text class="value">{{ formatDate(order.createTime) }}</text>
      </view>
      <view class="info-row" v-if="order.paymentTime || order.payTime">
        <text class="label">支付时间</text>
        <text class="value">{{
          formatDate(order.paymentTime || order.payTime)
        }}</text>
      </view>
      <view class="info-row" v-if="order.shippingTime || order.deliveryTime">
        <text class="label">发货时间</text>
        <text class="value">{{
          formatDate(order.shippingTime || order.deliveryTime)
        }}</text>
      </view>
      <view class="info-row" v-if="order.completionTime || order.receiveTime">
        <text class="label">收货时间</text>
        <text class="value">{{
          formatDate(order.completionTime || order.receiveTime)
        }}</text>
      </view>
      <view class="info-row" v-if="order.remark">
        <text class="label">备注</text>
        <text class="value">{{ order.remark }}</text>
      </view>
    </view>

    <!-- 价格明细 -->
    <view class="price-section">
      <view class="price-row">
        <text class="label">商品总额</text>
        <text class="value">¥{{ formattedTotalAmount }}</text>
      </view>
      <view class="price-row">
        <text class="label">运费</text>
        <text class="value">¥{{ formattedFreight }}</text>
      </view>
      <view class="price-row total">
        <text class="label">实付款</text>
        <text class="value">¥{{ formattedActualPayment }}</text>
      </view>
    </view>

    <!-- 底部操作栏 - 只保留全局操作 -->
    <view class="bottom-bar" v-if="showBottomBar">
      <view class="action-buttons">
        <button
          class="btn-default"
          v-if="hasPendingPayItem"
          @click="cancelOrder"
        >
          取消订单
        </button>
        <button
          class="btn-primary"
          v-if="hasPendingReceiveItems"
          @click="confirmReceive"
        >
          确认收货
        </button>
        <button class="btn-primary" v-if="hasPendingPayItem" @click="payOrder">
          去支付
        </button>
      </view>
    </view>

    <!-- 评价弹窗 -->
    <view class="comment-popup" v-if="showCommentPopup">
      <view class="popup-mask" @click="closeCommentPopup"></view>
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">商品评价</text>
          <text class="popup-close" @click="closeCommentPopup">✕</text>
        </view>
        <view class="popup-body">
          <view class="comment-book-info" v-if="currentCommentItem">
            <image
              class="book-cover"
              :src="currentCommentItem.coverImage"
              mode="aspectFill"
            ></image>
            <text class="book-name">{{ currentCommentItem.bookName }}</text>
          </view>
          <view class="rating-section">
            <text class="rating-label">评分</text>
            <view class="rating-stars">
              <text
                v-for="star in 5"
                :key="star"
                class="star"
                :class="{ active: star <= commentForm.rating }"
                @click="setRating(star)"
                >★</text
              >
            </view>
          </view>
          <view class="comment-section">
            <text class="comment-label">评价内容</text>
            <view class="editor-toolbar">
              <view class="toolbar-btn" @click="insertFormat('bold')">
                <text class="toolbar-icon">B</text>
              </view>
              <view class="toolbar-btn" @click="insertFormat('italic')">
                <text class="toolbar-icon italic">I</text>
              </view>
              <view class="toolbar-btn" @click="insertFormat('underline')">
                <text class="toolbar-icon underline">U</text>
              </view>
              <view class="toolbar-separator"></view>
              <view class="toolbar-btn" @click="insertFormat('br')">
                <text class="toolbar-icon">↵</text>
              </view>
              <view class="toolbar-btn" @click="clearFormat">
                <text class="toolbar-icon clear">清空</text>
              </view>
            </view>
            <textarea
              class="comment-textarea"
              v-model="commentForm.content"
              placeholder="请输入您的评价..."
              maxlength="500"
              :disabled="false"
            ></textarea>
            <text class="char-count">{{ commentForm.content.length }}/500</text>
          </view>
          <view class="image-section">
            <text class="comment-label">上传图片（选填，最多3张）</text>
            <view class="image-list">
              <view
                v-for="(img, index) in commentForm.images"
                :key="index"
                class="image-item"
              >
                <image
                  :src="img"
                  mode="aspectFill"
                  class="preview-image"
                ></image>
                <view class="delete-btn" @click="deleteImage(index)">×</view>
              </view>
              <view
                v-if="commentForm.images.length < 3"
                class="add-image-btn"
                @click="chooseImage"
              >
                <text class="add-icon">+</text>
                <text class="add-text">添加图片</text>
              </view>
            </view>
          </view>
          <view class="popup-footer">
            <button class="btn-cancel" @click="closeCommentPopup">取消</button>
            <button
              class="btn-submit"
              @click="submitComment"
              :disabled="submitting"
            >
              提交评价
            </button>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import {
  getOrderDetail,
  cancelOrder,
  confirmReceive,
  payOrder,
  remindShip,
  completeOrder,
} from "../../api/order.js";
import { addComment, getCommentsByUserId } from "../../api/comment.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      orderId: null,
      order: {},
      showCommentPopup: false,
      currentCommentItem: null,
      autoOpenComment: false,
      commentForm: {
        rating: 5,
        content: "",
        images: [],
      },
      submitting: false,
      userCommentedItems: new Set(),
    };
  },
  computed: {
    statusIcon() {
      const status = this.order.orderStatus || this.order.status;
      const iconMap = {
        待付款: "💳",
        待发货: "📦",
        待收货: "🚚",
        待评价: "⭐",
        交易完成: "✅",
        已完成: "✅",
        订单已取消: "❌",
        已取消: "❌",
        退款处理中: "💰",
        退款中: "💰",
        已退款: "💵",
      };
      return iconMap[status] || "❓";
    },
    statusText() {
      const status = this.order.orderStatus || this.order.status;
      const map = {
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
      return map[status] || status || "未知状态";
    },
    formattedTotalAmount() {
      const amount = this.order.totalAmount;
      if (amount === null || amount === undefined || amount === "") {
        return "0.00";
      }
      const num = typeof amount === "number" ? amount : parseFloat(amount);
      return isNaN(num) ? "0.00" : num.toFixed(2);
    },
    formattedFreight() {
      return "0.00";
    },
    formattedActualPayment() {
      const amount = this.order.totalAmount;
      if (amount === null || amount === undefined || amount === "") {
        return "0.00";
      }
      const num = typeof amount === "number" ? amount : parseFloat(amount);
      return isNaN(num) ? "0.00" : num.toFixed(2);
    },
    orderItems() {
      if (this.order.items && this.order.items.length > 0) {
        return this.order.items;
      }
      return [];
    },
    showBottomBar() {
      const status = this.order.orderStatus || this.order.status;
      const hiddenStatuses = ["已取消", "已退款"];
      return !hiddenStatuses.includes(status);
    },
    hasPendingShipItems() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      return this.orderItems.some((item) => item.status === "待发货");
    },
    hasRefundableItems() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      const refundableStatuses = ["待发货", "待收货", "待评价"];
      return this.orderItems.some((item) =>
        refundableStatuses.includes(item.status)
      );
    },
    hasRefundingItems() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      return this.orderItems.some((item) => item.status === "退款中");
    },
    hasPendingReceiveItems() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      return this.orderItems.some((item) => item.status === "待收货");
    },
    hasPendingPayItem() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      return this.orderItems.some((item) => item.status === "待付款");
    },
  },
  onLoad(options) {
    if (options.id) {
      if (options.id === "[object Object]") {
        uni.showToast({ title: "订单信息错误", icon: "none" });
        setTimeout(() => uni.navigateBack(), 1500);
        return;
      }
      this.orderId = options.id;
    }
    if (options.action === "comment") {
      this.autoOpenComment = true;
    }
    this.loadOrderDetail();
  },
  methods: {
    getItemImage(item) {
      if (item.coverImage) {
        return getImageUrl(item.coverImage);
      }
      if (item.book && item.book.coverImage) {
        return getImageUrl(item.book.coverImage);
      }
      return "/static/default-cover.png";
    },
    getItemPrice(item) {
      const price =
        item.price ||
        item.bookPrice ||
        item.unitPrice ||
        (item.book && item.book.price) ||
        0;
      return parseFloat(price).toFixed(2);
    },
    async loadOrderDetail() {
      try {
        const res = await getOrderDetail(this.orderId);
        if (res.code === 200 && res.data) {
          const orderData = res.data.order || res.data;
          const items = res.data.items || [];

          const processedItems = items.map((item) => {
            let status = item.status;
            if (
              item.refundStatus === "申请中" ||
              item.refundStatus === "处理中"
            ) {
              status = "退款中";
            } else if (
              item.refundStatus === "已通过" ||
              item.refundStatus === "已完成"
            ) {
              status = "已退款";
            }
            return {
              ...item,
              status: status,
              coverImage: item.coverImage
                ? getImageUrl(item.coverImage)
                : "/static/default-cover.png",
            };
          });

          this.order = {
            ...orderData,
            items: processedItems,
          };

          if (this.order.orderStatus === "待评价") {
            if (
              this.autoOpenComment &&
              this.order.items &&
              this.order.items.length > 0
            ) {
              const firstUncommented = this.order.items.find(
                (item) => !item.commented
              );
              if (firstUncommented) {
                this.openCommentPopup(firstUncommented);
              }
            }
          }
        }
      } catch (error) {
        console.error("加载订单详情失败:", error);
        uni.showToast({
          title: "加载失败",
          icon: "none",
        });
      }
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
    formatAmount(amount) {
      if (amount === null || amount === undefined || amount === "") {
        return "0.00";
      }
      const num = typeof amount === "number" ? amount : parseFloat(amount);
      return isNaN(num) ? "0.00" : num.toFixed(2);
    },
    getItemStatusText(status, commented = false) {
      if (!status) {
        return "未知";
      }
      if (status === "待评价" && commented) {
        return "已完成";
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
    getDisplayStatus(item) {
      if (item.status === "待评价" && item.commented) {
        return "已完成";
      }
      return item.status;
    },
    copyOrderNo() {
      const orderNo = this.order.orderNumber || this.order.orderNo;
      if (!orderNo) {
        uni.showToast({ title: "订单号不存在", icon: "none" });
        return;
      }
      uni.setClipboardData({
        data: orderNo,
        success: () => {
          setTimeout(() => {
            uni.showToast({
              title: "订单号已复制",
              icon: "success",
              duration: 1500,
              mask: true,
            });
          }, 0);
        },
      });
    },
    goToBookDetail(bookId) {
      uni.navigateTo({
        url: `/pages/book-detail/book-detail?id=${bookId}`,
      });
    },
    async cancelOrder() {
      const res = await new Promise((resolve) => {
        uni.showModal({
          title: "提示",
          content: "确定要取消该订单吗？",
          success: (modalRes) => {
            resolve(modalRes.confirm);
          },
        });
      });

      if (res) {
        try {
          await cancelOrder(this.orderId);
          uni.showToast({
            title: "订单已取消",
            icon: "success",
          });
          setTimeout(() => {
            uni.navigateBack();
          }, 1500);
        } catch (error) {
          console.error("取消订单失败:", error);
        }
      }
    },
    async confirmReceive() {
      const res = await new Promise((resolve) => {
        uni.showModal({
          title: "提示",
          content: "确认已收到货物吗？",
          success: (modalRes) => {
            resolve(modalRes.confirm);
          },
        });
      });

      if (res) {
        try {
          await confirmReceive(this.orderId);
          uni.showToast({
            title: "确认收货成功",
            icon: "success",
          });
          this.loadOrderDetail();
        } catch (error) {
          console.error("确认收货失败:", error);
        }
      }
    },
    applyRefund() {
      uni.navigateTo({
        url: `/subpkg/refund-apply/refund-apply?orderId=${this.orderId}`,
      });
    },
    remindShipForItem(item) {
      uni.showModal({
        title: "提醒发货",
        content: `确定提醒商家发货 "${item.bookName || "该商品"}" 吗？`,
        success: async (res) => {
          if (res.confirm) {
            try {
              await remindShip(this.orderId);
              uni.showToast({
                title: "已提醒商家发货",
                icon: "success",
              });
            } catch (error) {
              console.error("提醒发货失败:", error);
              uni.showToast({
                title: "提醒失败，请重试",
                icon: "none",
              });
            }
          }
        },
      });
    },
    applyRefund() {
      uni.navigateTo({
        url: `/subpkg/refund-apply/refund-apply?orderId=${this.orderId}`,
      });
    },
    applyRefundForItem(item) {
      if (item.status === "退款中") {
        uni.showModal({
          title: "退款状态",
          content: `商品 "${
            item.bookName || "该商品"
          }" 正在退款处理中，请耐心等待。`,
          showCancel: false,
        });
        return;
      }
      uni.navigateTo({
        url: `/subpkg/refund-apply/refund-apply?orderId=${this.orderId}&bookId=${item.id}`,
      });
    },
    viewRefundDetail(item) {
      uni.navigateTo({
        url: `/subpkg/refund-detail/refund-detail?orderItemId=${item.id}`,
      });
    },
    handleStatusClick(item) {
      if (item.status === "待收货" && item.expressNo) {
        this.showExpressInfo(item);
      }
    },
    showExpressInfo(item) {
      if (!item.expressNo) return;

      uni.showModal({
        title: "物流信息",
        content: `${item.expressCompany || "快递"}：${item.expressNo}`,
        showCancel: true,
        confirmText: "复制单号",
        success: (res) => {
          if (res.confirm) {
            uni.setClipboardData({
              data: item.expressNo,
              success: () => {
                uni.showToast({
                  title: "已复制快递单号",
                  icon: "success",
                });
              },
            });
          }
        },
      });
    },
    payOrder() {
      uni.showModal({
        title: "确认支付",
        content: `确认支付 ¥${this.formattedActualPayment}？\n\n支持微信支付`,
        confirmText: "微信支付",
        success: async (modalRes) => {
          if (modalRes.confirm) {
            uni.showLoading({ title: "正在发起支付..." });
            try {
              const res = await payOrder(this.orderId);
              uni.hideLoading();
              if (res.code === 200) {
                uni.showToast({
                  title: "支付成功",
                  icon: "success",
                });
                setTimeout(() => {
                  this.loadOrderDetail();
                }, 1500);
              } else {
                uni.showToast({
                  title: res.message || "支付失败",
                  icon: "none",
                });
              }
            } catch (error) {
              uni.hideLoading();
              console.error("支付失败:", error);
              uni.showToast({
                title: "支付失败，请重试",
                icon: "none",
              });
            }
          }
        },
      });
    },
    async checkUserComments() {
      const userInfo = uni.getStorageSync("userInfo");
      if (!userInfo || !userInfo.id) return;
      try {
        const res = await getCommentsByUserId(userInfo.id);
        if (res.code === 200 && res.data) {
          res.data.forEach((comment) => {
            this.userCommentedItems.add(comment.bookId);
          });
          this.updateItemsCommentStatus();
        }
      } catch (error) {
        console.error("获取用户评论失败:", error);
      }
    },
    updateItemsCommentStatus() {
      if (!this.order.items) return;
      this.order.items.forEach((item) => {
        this.$set(item, "commented", this.userCommentedItems.has(item.bookId));
      });
    },
    openCommentPopup(item) {
      this.currentCommentItem = item;
      this.commentForm = {
        rating: 5,
        content: "",
        images: [],
      };
      this.showCommentPopup = true;
    },
    closeCommentPopup() {
      this.showCommentPopup = false;
      this.currentCommentItem = null;
    },
    setRating(star) {
      this.commentForm.rating = star;
    },
    insertFormat(type) {
      const formats = {
        bold: "<b>加粗文字</b>",
        italic: "<i>斜体文字</i>",
        underline: "<u>下划线文字</u>",
        br: "\n",
      };
      this.commentForm.content += formats[type] || "";
    },
    clearFormat() {
      this.commentForm.content = "";
    },
    chooseImage() {
      if (this.commentForm.images.length >= 3) {
        uni.showToast({
          title: "最多上传3张图片",
          icon: "none",
        });
        return;
      }
      uni.chooseImage({
        count: 3 - this.commentForm.images.length,
        sizeType: ["compressed"],
        sourceType: ["album", "camera"],
        success: async (res) => {
          for (let tempFilePath of res.tempFilePaths) {
            if (this.commentForm.images.length >= 3) break;
            uni.showLoading({ title: "上传中..." });
            try {
              const uploadRes = await this.uploadImage(tempFilePath);
              this.commentForm.images.push(uploadRes);
              uni.hideLoading();
            } catch (e) {
              uni.hideLoading();
              uni.showToast({
                title: "上传失败",
                icon: "none",
              });
            }
          }
        },
        fail: () => {
          // 用户取消选择
        },
      });
    },
    uploadImage(filePath) {
      return new Promise((resolve, reject) => {
        const userInfo = uni.getStorageSync("userInfo");
        const userId = userInfo ? userInfo.id : "unknown";
        const timestamp = Date.now();
        const randomStr = Math.random().toString(36).substr(2, 9);
        const fileName = `comment_${userId}_${timestamp}_${randomStr}.jpg`;

        uni.uploadFile({
          url: `${
            uni.getStorageSync("baseUrl") || getApp().globalData.baseUrl
          }/upload/image`,
          filePath: filePath,
          name: "file",
          formData: {
            folder: "comments",
          },
          success: (uploadRes) => {
            try {
              const data = JSON.parse(uploadRes.data);
              if (data.code === 200 && data.url) {
                resolve(data.url);
              } else {
                reject(new Error(data.msg || "上传失败"));
              }
            } catch (e) {
              reject(e);
            }
          },
          fail: (err) => {
            reject(err);
          },
        });
      });
    },
    deleteImage(index) {
      this.commentForm.images.splice(index, 1);
    },
    async submitComment() {
      if (!this.commentForm.content.trim()) {
        uni.showToast({
          title: "请输入评价内容",
          icon: "none",
        });
        return;
      }
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
        await addComment({
          bookId: this.currentCommentItem.bookId,
          userId: userInfo.id,
          rating: this.commentForm.rating,
          content: this.commentForm.content,
          orderId: this.order.id,
          images:
            this.commentForm.images.length > 0
              ? this.commentForm.images.join(",")
              : "",
        });
        uni.showToast({
          title: "评价成功",
          icon: "success",
        });

        this.userCommentedItems.add(this.currentCommentItem.bookId);

        this.closeCommentPopup();

        this.order.items.forEach((item) => {
          item.commented = this.userCommentedItems.has(item.bookId);
        });

        try {
          await completeOrder(this.order.id);
        } catch (e) {
          console.error("更新后端状态失败", e);
        }

        setTimeout(() => {
          this.loadOrderDetail();
        }, 500);
      } catch (error) {
        console.error("提交评价失败:", error);
        uni.showToast({
          title: "评价失败",
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
.order-detail-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 140rpx;
}

.order-detail-container .status-section {
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
  padding: 50rpx 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.order-detail-container .status-content {
  display: flex;
  align-items: center;
  justify-content: center;
}

.order-detail-container .status-icon {
  font-size: 56rpx;
  margin-right: 20rpx;
  line-height: 1;
}

.order-detail-container .status-text {
  font-size: 40rpx;
  font-weight: 600;
  color: #1a1a1a;
  letter-spacing: 2rpx;
}

.order-status-text {
  font-size: 40rpx;
  font-weight: 600;
  color: #1a1a1a;
  letter-spacing: 2rpx;
}

/* 状态颜色 - 统一规则：待评价/退款中: 橙色, 待收货/已完成: 绿色, 已取消/已退款: 红色 */
.status-badge.status-orange {
  color: #ff9800;
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
}

.status-badge.status-green {
  color: #4caf50;
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
}

.status-badge.status-red {
  color: #f44336;
  background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
}

.status-badge.status-blue {
  color: #2196f3;
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
}

.status-badge.status-default {
  color: #999;
  background: linear-gradient(135deg, #f5f5f5 0%, #eeeeee 100%);
}

.address-section {
  background-color: #fff;
  padding: 30rpx;
  display: flex;
  align-items: flex-start;
  margin-bottom: 20rpx;
}

.address-icon {
  font-size: 48rpx;
  margin-right: 20rpx;
}

.address-info {
  flex: 1;
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

.address-detail {
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
}

.goods-section {
  background-color: #fff;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 24rpx;
}

.goods-list {
  display: flex;
  flex-direction: column;
}

.goods-item {
  display: flex;
  padding: 20rpx 0;
  border-bottom: 1px solid #f5f5f5;
}

.goods-item:last-child {
  border-bottom: none;
}

.goods-cover {
  width: 140rpx;
  height: 190rpx;
  border-radius: 12rpx;
  background-color: #f5f5f5;
  flex-shrink: 0;
}

.goods-info {
  flex: 1;
  margin-left: 20rpx;
  display: flex;
  flex-direction: column;
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
  line-height: 1.4;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
  flex: 1;
  margin-right: 12rpx;
}

.goods-author {
  font-size: 24rpx;
  color: #999;
  margin-top: 6rpx;
}

.item-status-tag {
  padding: 4rpx 12rpx;
  border-radius: 8rpx;
  font-size: 20rpx;
  display: inline-flex;
  align-items: center;
  gap: 6rpx;
  flex-shrink: 0;
}

.item-status-tag[clickable] {
  cursor: pointer;
}

.express-hint {
  font-size: 18rpx;
  margin-left: 4rpx;
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
  margin-top: auto;
  padding-top: 12rpx;
}

.goods-price {
  font-size: 28rpx;
  color: #15803d;
  font-weight: bold;
}

.goods-quantity {
  font-size: 26rpx;
  color: #999;
}

.info-section {
  background-color: #fff;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1px solid #f5f5f5;
}

.info-row:last-child {
  border-bottom: none;
}

.info-row .label {
  font-size: 28rpx;
  color: #666;
}

.info-row .value {
  font-size: 28rpx;
  color: #333;
}

.value-row {
  display: flex;
  align-items: center;
}

.copy-btn {
  font-size: 24rpx;
  color: #15803d;
  margin-left: 16rpx;
  padding: 4rpx 12rpx;
  border: 1px solid #15803d;
  border-radius: 4rpx;
}

.price-section {
  background-color: #fff;
  padding: 30rpx;
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16rpx 0;
}

.price-row .label {
  font-size: 28rpx;
  color: #666;
}

.price-row .value {
  font-size: 28rpx;
  color: #333;
}

.price-row.total {
  border-top: 1px solid #f5f5f5;
  margin-top: 16rpx;
  padding-top: 24rpx;
}

.price-row.total .label {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
}

.price-row.total .value {
  font-size: 36rpx;
  color: #15803d;
  font-weight: bold;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;
  padding: 20rpx 30rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  box-shadow: 0 -2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.action-buttons {
  display: flex;
  justify-content: flex-end;
}

.btn-default,
.btn-primary {
  height: 64rpx;
  line-height: 64rpx;
  border-radius: 32rpx;
  font-size: 28rpx;
  margin-left: 20rpx;
  padding: 0 36rpx;
  border: none;
}

.btn-default {
  background-color: #f5f5f5;
  color: #666;
}

.btn-primary {
  background-color: #15803d;
  color: #fff;
}

.goods-action {
  margin-top: 12rpx;
  display: flex;
  justify-content: flex-end;
}

.goods-actions {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 16rpx;
  margin-top: 16rpx;
}

.btn-action-small {
  height: 52rpx;
  line-height: 52rpx;
  font-size: 24rpx;
  color: #15803d;
  background-color: #e8f5e9;
  border: 1px solid #15803d;
  border-radius: 26rpx;
  padding: 0 20rpx;
  margin: 0;
}

.btn-action-small.btn-view {
  color: #ff9800;
  background-color: #fff3e0;
}

.btn-action-small.btn-remind {
  color: #15803d;
  background-color: #e8f5e9;
  border-color: #15803d;
}

.btn-action-small.btn-refund {
  color: #ff6b35;
  background-color: #fff4f0;
}

.status-text {
  font-size: 25rpx !important;
  color: #999;
}

.btn-comment {
  height: 52rpx;
  line-height: 52rpx;
  font-size: 24rpx;
  color: #15803d;
  background-color: #e8f5e9;
  border: 1px solid #15803d;
  border-radius: 26rpx;
  padding: 0 20rpx;
}

.commented-tag {
  font-size: 24rpx;
  color: #999;
}

.comment-popup {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 999;
}

.popup-mask {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
}

.popup-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;
  border-radius: 24rpx 24rpx 0 0;
  max-height: 80vh;
}

.popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 32rpx;
  border-bottom: 1px solid #f5f5f5;
}

.popup-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.popup-close {
  font-size: 40rpx;
  color: #999;
}

.popup-body {
  padding: 30rpx;
  max-height: 60vh;
  overflow-y: auto;
}

.comment-book-info {
  display: flex;
  align-items: center;
  margin-bottom: 30rpx;
  padding-bottom: 20rpx;
  border-bottom: 1px solid #f5f5f5;
}

.comment-book-info .book-cover {
  width: 80rpx;
  height: 110rpx;
  border-radius: 8rpx;
  margin-right: 20rpx;
}

.comment-book-info .book-name {
  flex: 1;
  font-size: 28rpx;
  color: #333;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.rating-section {
  display: flex;
  align-items: center;
  margin-bottom: 30rpx;
}

.rating-label {
  font-size: 28rpx;
  color: #333;
  margin-right: 20rpx;
}

.rating-stars {
  display: flex;
}

.star {
  font-size: 44rpx;
  color: #ddd;
  margin-right: 8rpx;
}

.star.active {
  color: #f5a623;
}

.comment-section {
  margin-bottom: 30rpx;
}

.comment-label {
  font-size: 28rpx;
  color: #333;
  display: block;
  margin-bottom: 16rpx;
}

.editor-toolbar {
  display: flex;
  align-items: center;
  padding: 12rpx 16rpx;
  background-color: #f8f8f8;
  border-radius: 12rpx 12rpx 0 0;
  border-bottom: 1rpx solid #e0e0e0;
}

.toolbar-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56rpx;
  height: 56rpx;
  margin-right: 8rpx;
  background-color: #fff;
  border-radius: 8rpx;
  border: 1rpx solid #ddd;
}

.toolbar-icon {
  font-size: 26rpx;
  color: #333;
  font-weight: 600;
}

.toolbar-icon.italic {
  font-style: italic;
}

.toolbar-icon.underline {
  text-decoration: underline;
}

.toolbar-icon.clear {
  font-size: 22rpx;
  font-weight: normal;
  color: #ff6b6b;
}

.toolbar-separator {
  width: 1rpx;
  height: 40rpx;
  background-color: #ddd;
  margin: 0 12rpx;
}

.comment-textarea {
  width: 100%;
  height: 200rpx;
  padding: 20rpx;
  font-size: 28rpx;
  color: #333;
  background-color: #fff;
  border-radius: 0 0 12rpx 12rpx;
  box-sizing: border-box;
  border: 1rpx solid #e0e0e0;
  border-top: none;
}

.image-section {
  margin-bottom: 30rpx;
}

.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
}

.image-item {
  position: relative;
  width: 200rpx;
  height: 200rpx;
}

.preview-image {
  width: 100%;
  height: 100%;
  border-radius: 12rpx;
}

.delete-btn {
  position: absolute;
  top: -16rpx;
  right: -16rpx;
  width: 40rpx;
  height: 40rpx;
  background-color: #ff4d4f;
  color: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28rpx;
  font-weight: bold;
}

.add-image-btn {
  width: 200rpx;
  height: 200rpx;
  background-color: #f5f5f5;
  border: 2rpx dashed #ddd;
  border-radius: 12rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.add-icon {
  font-size: 60rpx;
  color: #999;
  line-height: 1;
}

.add-text {
  font-size: 24rpx;
  color: #999;
  margin-top: 8rpx;
}

.char-count {
  display: block;
  text-align: right;
  font-size: 24rpx;
  color: #999;
  margin-top: 12rpx;
}

.popup-footer {
  display: flex;
  padding-top: 20rpx;
}

.btn-cancel,
.btn-submit {
  flex: 1;
  height: 80rpx;
  line-height: 80rpx;
  border-radius: 40rpx;
  font-size: 30rpx;
  border: none;
}

.btn-cancel {
  background-color: #f5f5f5;
  color: #666;
  margin-right: 20rpx;
}

.btn-submit {
  background-color: #15803d;
  color: #fff;
}

.btn-submit[disabled] {
  background-color: #a5d6a7;
}
</style>
