<template>
  <div class="my-orders">
    <el-card>
      <div slot="header">
        <span>我的订单</span>
      </div>

      <el-form :inline="true" class="search-form">
        <el-form-item label="图书名称">
          <el-input
            v-model="searchForm.bookName"
            placeholder="搜索图书名称"
            clearable
            @input="handleSearch"
          >
            <i slot="prefix" class="el-icon-search"></i>
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>

      <el-tabs v-model="activeTab" @tab-click="handleTabClick">
        <el-tab-pane label="全部" name="all"></el-tab-pane>
        <el-tab-pane label="待付款" name="待付款"></el-tab-pane>
        <el-tab-pane label="待发货" name="待发货"></el-tab-pane>
        <el-tab-pane label="待收货" name="待收货"></el-tab-pane>
        <el-tab-pane label="待评价" name="待评价"></el-tab-pane>
        <el-tab-pane label="已完成" name="已完成"></el-tab-pane>
        <el-tab-pane label="已取消" name="已取消"></el-tab-pane>
        <el-tab-pane label="退款中" name="退款中"></el-tab-pane>
        <el-tab-pane label="已退款" name="已退款"></el-tab-pane>
      </el-tabs>

      <div class="order-list" v-if="filteredOrders.length > 0">
        <div v-for="order in filteredOrders" :key="order.id" class="order-card">
          <div class="order-header">
            <div class="header-left">
              <span class="order-number">订单号：{{ order.orderNumber }}</span>
              <span class="order-time">{{ formatTime(order.createTime) }}</span>
            </div>
            <div class="header-right">
              <el-tag
                v-if="order.orderStatus === '待付款'"
                type="warning"
                size="small"
                ><i class="el-icon-time"></i> 待付款</el-tag
              >
              <el-tag
                v-else-if="order.orderStatus === '待发货'"
                type="primary"
                size="small"
                ><i class="el-icon-box"></i> 待发货</el-tag
              >
              <el-tag
                v-else-if="order.orderStatus === '待收货'"
                type="success"
                size="small"
                ><i class="el-icon-truck"></i> 待收货</el-tag
              >
              <el-tag
                v-else-if="order.orderStatus === '待评价'"
                type="warning"
                size="small"
                ><i class="el-icon-edit"></i> 待评价</el-tag
              >
              <el-tag
                v-else-if="order.orderStatus === '退款中'"
                type="warning"
                size="small"
                ><i class="el-icon-warning-outline"></i> 退款中</el-tag
              >
              <el-tag
                v-else-if="order.orderStatus === '已完成'"
                type="success"
                size="small"
                ><i class="el-icon-circle-check"></i> 已完成</el-tag
              >
              <el-tag
                v-else-if="order.orderStatus === '已取消'"
                type="danger"
                size="small"
                ><i class="el-icon-circle-close"></i> 已取消</el-tag
              >
              <el-tag
                v-else-if="order.orderStatus === '已退款'"
                type="danger"
                size="small"
                ><i class="el-icon-circle-close"></i> 已退款</el-tag
              >
              <el-tag v-else type="info" size="small">{{
                order.orderStatus
              }}</el-tag>
            </div>
          </div>

          <div class="order-items">
            <div
              v-for="item in filteredItems(order)"
              :key="item.id"
              class="order-item"
              @click="viewOrderDetail(order)"
            >
              <div class="item-image">
                <img
                  v-if="item.coverImage"
                  :src="getImageUrl(item.coverImage)"
                  alt="封面"
                />
                <div v-else class="no-image">暂无图片</div>
              </div>
              <div class="item-info">
                <div class="item-name">{{ item.bookName }}</div>
                <div class="item-meta">
                  <span class="item-author" v-if="item.author">
                    {{ item.author }}
                  </span>
                  <span class="item-merchant" v-if="item.merchantName">
                    {{ item.merchantName }}
                  </span>
                </div>
                <div class="item-price">
                  <span class="unit-price">¥{{ item.price }}</span>
                  <span class="quantity">x{{ item.quantity }}</span>
                  <span class="subtotal"
                    >小计：¥{{
                      item.subtotal || (item.price * item.quantity).toFixed(2)
                    }}</span
                  >
                </div>
              </div>
              <div class="item-status">
                <el-tag
                  v-if="item.status === '待付款'"
                  type="warning"
                  size="small"
                >
                  <i class="el-icon-time"></i> 待付款
                </el-tag>
                <el-tag
                  v-else-if="item.status === '待发货'"
                  type="primary"
                  size="small"
                >
                  <i class="el-icon-box"></i> 待发货
                </el-tag>
                <el-tag
                  v-else-if="item.status === '已发货'"
                  type="success"
                  size="small"
                >
                  <i class="el-icon-truck"></i> 已发货
                </el-tag>
                <el-tag
                  v-else-if="item.status === '待收货'"
                  type="success"
                  size="small"
                >
                  <i class="el-icon-truck"></i> 待收货
                </el-tag>
                <el-tag
                  v-else-if="item.status === '待评价'"
                  type="warning"
                  size="small"
                >
                  <i class="el-icon-edit"></i> 待评价
                </el-tag>
                <el-tag
                  v-else-if="item.status === '已完成'"
                  type="success"
                  size="small"
                >
                  <i class="el-icon-circle-check"></i> 已完成
                </el-tag>
                <el-tag
                  v-else-if="item.status === '退款中'"
                  type="warning"
                  size="small"
                >
                  <i class="el-icon-warning-outline"></i> 退款中
                </el-tag>
                <el-tag
                  v-else-if="item.status === '已退款'"
                  type="danger"
                  size="small"
                >
                  <i class="el-icon-circle-close"></i> 已退款
                </el-tag>
                <el-tag
                  v-else-if="item.status === '已取消'"
                  type="danger"
                  size="small"
                >
                  <i class="el-icon-circle-close"></i> 已取消
                </el-tag>
                <el-tag v-else type="info" size="small">
                  {{ item.status }}
                </el-tag>
              </div>
            </div>
            <div
              v-if="!order.items || order.items.length === 0"
              class="no-items"
            >
              暂无商品信息
            </div>
          </div>

          <div class="order-summary">
            <div class="receiver-info" v-if="order.receiverName">
              <i class="el-icon-user"></i>
              <span>{{ order.receiverName }}</span>
              <span class="phone">{{
                order.receiverPhone || order.phone
              }}</span>
            </div>
            <div class="total-info">
              <span class="total-label">订单总额：</span>
              <span class="total-amount">¥{{ order.totalAmount }}</span>
            </div>
          </div>

          <div class="order-footer">
            <el-button
              v-if="order.orderStatus === '待付款'"
              type="primary"
              size="small"
              @click="payOrder(order)"
            >
              <i class="el-icon-goods"></i> 去支付
            </el-button>
            <el-button
              v-if="order.orderStatus === '待发货'"
              size="small"
              @click="remindShip(order)"
            >
              <i class="el-icon-bell"></i> 提醒发货
            </el-button>
            <el-button
              v-if="order.orderStatus === '待收货'"
              type="success"
              size="small"
              @click="confirmReceive(order)"
            >
              <i class="el-icon-circle-check"></i> 确认收货
            </el-button>
            <el-button size="small" @click="viewOrderDetail(order)">
              <i class="el-icon-view"></i> 查看详情
            </el-button>
          </div>
        </div>
      </div>
      <div v-else class="empty">
        <p>暂无符合条件的订单</p>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "MyOrders",
  data() {
    return {
      orderList: [],
      activeTab: "all",
      searchForm: {
        bookName: "",
      },
    };
  },
  computed: {
    filteredOrders() {
      let orders = this.orderList;

      if (this.activeTab !== "all") {
        orders = orders.filter((order) => {
          if (!order.items || order.items.length === 0) {
            return order.orderStatus === this.activeTab;
          }
          return order.items.some((item) => item.status === this.activeTab);
        });
      }

      if (this.searchForm.bookName) {
        const keyword = this.searchForm.bookName.toLowerCase();
        orders = orders.filter((order) => {
          const bookNames = order.items
            ? order.items
                .map((item) => (item.bookName || "").toLowerCase())
                .join(" ")
            : "";
          return bookNames.includes(keyword);
        });
      }

      return orders;
    },
    filteredItems() {
      return function (order) {
        if (this.activeTab === "all") {
          return order.items || [];
        }
        return (order.items || []).filter(
          (item) => item.status === this.activeTab
        );
      };
    },
  },
  mounted() {
    this.loadOrders();
  },
  methods: {
    async loadOrders() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login");
        return;
      }

      try {
        const res = await this.$http.get(`/order/user/${userId}`);
        if (res.code !== 200) return;

        const orders = res.data?.records || res.data || [];
        const ordersWithItems = await Promise.all(
          orders.map(async (order) => {
            try {
              const itemRes = await this.$http.get(`/order/items/${order.id}`);
              return {
                ...order,
                items: itemRes.code === 200 ? itemRes.data || [] : [],
              };
            } catch (e) {
              return { ...order, items: [] };
            }
          })
        );

        this.orderList = ordersWithItems;
      } catch (e) {
        this.$message.error("加载订单失败，请稍后重试");
      }
    },
    handleSearch() {
      // 筛选由 computed 属性自动处理
    },
    resetSearch() {
      this.searchForm = {
        bookName: "",
      };
    },
    handleTabClick() {
      // 状态切换由 computed 属性自动处理
    },
    payOrder(order) {
      this.$confirm("确认支付此订单吗？", "支付确认", {
        confirmButtonText: "确认支付",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$http.put("/order/pay", { id: order.id }).then((res) => {
            if (res.code === 200) {
              this.$message.success("支付成功");
              this.loadOrders();
            } else {
              this.$message.error(res.message || "支付失败");
            }
          });
        })
        .catch(() => {});
    },
    viewOrderDetail(order) {
      this.$router.push(`/home/order-detail/${order.id}`);
    },
    getImageUrl(path) {
      if (!path) return "";
      if (path.startsWith("http")) return path;
      if (path.startsWith("data:")) return path;
      return "http://localhost:8080" + path;
    },
    getStatusType(status) {
      const typeMap = {
        待付款: "warning",
        待发货: "primary",
        待收货: "success",
        已完成: "success",
        已取消: "danger",
        退款中: "warning",
        已退款: "danger",
      };
      return typeMap[status] || "info";
    },
    formatTime(time) {
      if (!time) return "";
      const date = new Date(time);
      const year = date.getFullYear();
      const month = (date.getMonth() + 1).toString().padStart(2, "0");
      const day = date.getDate().toString().padStart(2, "0");
      const hour = date.getHours().toString().padStart(2, "0");
      const minute = date.getMinutes().toString().padStart(2, "0");
      return `${year}-${month}-${day} ${hour}:${minute}`;
    },
    remindShip(order) {
      this.$http
        .put("/order/remind-ship", { id: order.id })
        .then((res) => {
          if (res.code === 200) {
            this.$message.success("已提醒商家发货，请耐心等待");
            this.loadOrders();
          } else {
            this.$message.warning(res.message || "提醒失败");
          }
        })
        .catch(() => {
          this.$message.error("提醒发货失败，请稍后重试");
        });
    },
    confirmReceive(order) {
      this.$confirm("确认已收到商品吗？", "确认收货", {
        confirmButtonText: "确认收货",
        cancelButtonText: "取消",
        type: "info",
      })
        .then(() => {
          this.$http.put("/order/confirm", { id: order.id }).then((res) => {
            if (res.code === 200) {
              this.$message.success("确认收货成功");
              this.loadOrders();
            } else {
              this.$message.error(res.message || "确认收货失败");
            }
          });
        })
        .catch(() => {});
    },
    goToComment(order, item) {
      if (!item || !item.bookId) {
        this.$message.error("商品信息不完整");
        return;
      }

      this.$router
        .push({
          path: "/home/book-detail/" + item.bookId,
          query: {
            orderId: order.id,
            orderItemId: item.id,
          },
        })
        .catch(() => {});
    },
  },
};
</script>

<style scoped>
.my-orders {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.search-form {
  margin-bottom: 20px;
}

.order-list {
  margin-top: 20px;
}

.order-card {
  background: #fff;
  border-radius: 12px;
  margin-bottom: 20px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.order-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.header-left {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.order-number {
  font-weight: 600;
  font-size: 14px;
}

.order-time {
  font-size: 12px;
  opacity: 0.9;
}

.order-items {
  padding: 16px 20px;
  background: #fff;
}

.order-item {
  display: flex;
  gap: 12px;
  padding: 10px;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background-color 0.2s;
  border-radius: 6px;
  margin-bottom: 6px;
}

.order-item:hover {
  background-color: #f8f9fa;
}

.order-item:last-child {
  border-bottom: none;
  margin-bottom: 0;
}

.item-image {
  width: 60px;
  height: 75px;
  border-radius: 4px;
  overflow: hidden;
  flex-shrink: 0;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image {
  color: #ccc;
  font-size: 10px;
  text-align: center;
}

.item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
  min-height: 75px;
}

.item-status {
  display: flex;
  align-items: flex-start;
  flex-shrink: 0;
  padding-top: 0;
  margin-left: 12px;
}

.item-actions {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  margin-left: 12px;
}

.item-name {
  font-weight: 500;
  font-size: 14px;
  color: #333;
  line-height: 1.3;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
}

.item-author {
  font-size: 12px;
  color: #999;
}

.item-meta {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-top: 4px;
}

.item-merchant {
  font-size: 12px;
  color: #909399;
}

.item-price {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: auto;
  padding-top: 4px;
  width: 100%;
}

.unit-price {
  font-weight: 600;
  color: #ff4400;
  font-size: 14px;
}

.quantity {
  color: #999;
  font-size: 12px;
  background: #f5f5f5;
  padding: 2px 6px;
  border-radius: 3px;
}

.subtotal {
  color: #666;
  font-size: 12px;
  margin-left: auto;
}

.no-items {
  text-align: center;
  padding: 20px;
  color: #999;
  font-size: 14px;
}

.order-summary {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background: #fafafa;
  border-top: 1px solid #f0f0f0;
}

.receiver-info {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #666;
}

.receiver-info i {
  color: #667eea;
}

.phone {
  color: #999;
  margin-left: 4px;
}

.total-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.total-label {
  color: #666;
  font-size: 14px;
}

.total-amount {
  font-size: 24px;
  font-weight: bold;
  color: #ff4400;
}

.order-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 20px;
  background: #fff;
  border-top: 1px solid #f0f0f0;
}

.order-footer .el-button {
  border-radius: 20px;
}

.empty {
  text-align: center;
  padding: 80px 0;
  color: #999;
  background: #fff;
  border-radius: 12px;
}

.empty i {
  font-size: 64px;
  display: block;
  margin-bottom: 20px;
  color: #ddd;
}

.empty p {
  font-size: 16px;
}
</style>
