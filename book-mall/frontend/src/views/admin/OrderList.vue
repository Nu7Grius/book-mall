<template>
  <div
    class="order-container"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-document"></i>
            订单管理
          </h2>
          <p class="header-subtitle">管理平台所有订单</p>
        </div>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="queryForm" class="query-form">
        <el-form-item label="订单编号" class="search-item">
          <el-input
            v-model="queryForm.orderNumber"
            placeholder="请输入订单编号"
            clearable
            prefix-icon="el-icon-search"
          ></el-input>
        </el-form-item>
        <el-form-item label="下单人" class="search-item">
          <el-input
            v-model="queryForm.username"
            placeholder="请输入下单人"
            clearable
            prefix-icon="el-icon-user"
          ></el-input>
        </el-form-item>
        <el-form-item label="商家名称" class="search-item">
          <el-input
            v-model="queryForm.merchantName"
            placeholder="请输入商家名称"
            clearable
            prefix-icon="el-icon-shop"
          ></el-input>
        </el-form-item>
        <el-form-item label="下单时间" class="search-item">
          <el-date-picker
            v-model="queryForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
            style="width: 280px"
          >
          </el-date-picker>
        </el-form-item>
        <el-form-item label="订单状态" class="search-item">
          <el-select
            v-model="queryForm.orderStatus"
            placeholder="请选择状态"
            clearable
            style="width: 140px"
          >
            <el-option label="待付款" value="待付款"></el-option>
            <el-option label="待发货" value="待发货"></el-option>
            <el-option label="待收货" value="待收货"></el-option>
            <el-option label="待评价" value="待评价"></el-option>
            <el-option label="已完成" value="已完成"></el-option>
            <el-option label="已取消" value="已取消"></el-option>
            <el-option label="退款中" value="退款中"></el-option>
            <el-option label="已退款" value="已退款"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item class="search-actions">
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">
            查询
          </el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="orderList" border stripe v-loading="loading">
        <el-table-column prop="orderNumber" label="订单号" width="200">
          <template slot-scope="scope">
            <div class="order-number-cell">
              <span>{{ scope.row.orderNumber || "-" }}</span>
              <el-tooltip
                v-if="scope.row.remindShip === 1"
                :content="
                  '用户催促发货（' + formatDate(scope.row.remindTime) + '）'
                "
                placement="top"
              >
                <i class="remind-icon el-icon-bell"></i>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="bookName" label="商品名称" min-width="150">
          <template slot-scope="scope">
            <div v-if="scope.row.items && scope.row.items.length > 0">
              <div
                v-for="item in scope.row.items"
                :key="item.id"
                class="book-item"
              >
                {{ item.bookName || "-" }}
              </div>
            </div>
            <span v-else>-</span>
          </template>
        </el-table-column>

        <el-table-column label="商品状态" width="90" align="center">
          <template slot-scope="scope">
            <div v-if="scope.row.items && scope.row.items.length > 0">
              <div
                v-for="item in scope.row.items"
                :key="item.id"
                class="status-item"
              >
                <el-tag
                  v-if="item.status"
                  size="mini"
                  :type="getItemStatusTagType(item.status)"
                >
                  {{ item.status }}
                </el-tag>
                <span v-else>-</span>
              </div>
            </div>
            <span v-else>-</span>
          </template>
        </el-table-column>

        <el-table-column label="单价" width="90" align="center">
          <template slot-scope="scope">
            <div v-if="scope.row.items && scope.row.items.length > 0">
              <div
                v-for="item in scope.row.items"
                :key="item.id"
                class="price-item"
              >
                ¥{{ item.price }}
              </div>
            </div>
            <span v-else>-</span>
          </template>
        </el-table-column>

        <el-table-column label="数量" width="70" align="center">
          <template slot-scope="scope">
            <div v-if="scope.row.items && scope.row.items.length > 0">
              <div
                v-for="item in scope.row.items"
                :key="item.id"
                class="quantity-item"
              >
                ×{{ item.quantity }}
              </div>
            </div>
            <span v-else>-</span>
          </template>
        </el-table-column>

        <el-table-column
          prop="totalAmount"
          label="订单金额"
          width="100"
          align="center"
        >
          <template slot-scope="scope">
            <span class="amount-text"
              >¥{{ scope.row.totalAmount || "0.00" }}</span
            >
          </template>
        </el-table-column>

        <el-table-column
          prop="merchantNameDisplay"
          label="商家名称"
          width="120"
        >
          <template slot-scope="scope">
            <span class="merchant-name-text">
              {{ scope.row.merchantNameDisplay || "平台自营" }}
            </span>
          </template>
        </el-table-column>

        <el-table-column prop="username" label="下单人" width="100">
          <template slot-scope="scope">
            {{ scope.row.username || "-" }}
          </template>
        </el-table-column>

        <el-table-column prop="createTime" label="下单时间" width="160">
          <template slot-scope="scope">
            {{ formatDate(scope.row.createTime) }}
          </template>
        </el-table-column>

        <el-table-column
          prop="orderStatus"
          label="订单状态"
          width="110"
          align="center"
        >
          <template slot-scope="scope">
            <el-tag
              v-if="getOrderStatus(scope.row) === '待付款'"
              type="warning"
              size="small"
            >
              <i class="el-icon-time"></i> 待付款
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(scope.row) === '待发货'"
              type="primary"
              size="small"
            >
              <i class="el-icon-box"></i> 待发货
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(scope.row) === '待收货'"
              type="success"
              size="small"
            >
              <i class="el-icon-truck"></i> 待收货
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(scope.row) === '待评价'"
              type="warning"
              size="small"
            >
              <i class="el-icon-edit"></i> 待评价
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(scope.row) === '已完成'"
              type="success"
              size="small"
            >
              <i class="el-icon-circle-check"></i> 已完成
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(scope.row) === '已取消'"
              type="danger"
              size="small"
            >
              <i class="el-icon-circle-close"></i> 已取消
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(scope.row) === '退款中'"
              type="warning"
              size="small"
            >
              <i class="el-icon-warning-outline"></i> 退款中
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(scope.row) === '已退款'"
              type="danger"
              size="small"
            >
              <i class="el-icon-circle-close"></i> 已退款
            </el-tag>
            <el-tag v-else type="info" size="small">
              {{ getOrderStatus(scope.row) }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="180" align="center">
          <template slot-scope="scope">
            <div class="action-buttons">
              <el-button
                size="mini"
                type="primary"
                @click="handleView(scope.row)"
              >
                <i class="el-icon-view"></i> 查看
              </el-button>
              <el-button
                v-if="getOrderStatus(scope.row) === '已完成'"
                size="mini"
                type="danger"
                @click="handleDelete(scope.row)"
              >
                <i class="el-icon-delete"></i> 删除
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="pagination.page"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pagination.pageSize"
        :total="pagination.total"
        layout="total, sizes, prev, pager, next, jumper"
        style="margin-top: 20px; text-align: right"
      >
      </el-pagination>
    </el-card>

    <el-dialog
      title="📋 订单详情"
      :visible.sync="detailVisible"
      width="750px"
      class="detail-dialog"
    >
      <div v-if="currentOrder" class="order-detail">
        <div class="detail-header">
          <div class="order-number-display">
            <i class="el-icon-document"></i>
            <span class="order-number">{{ currentOrder.orderNumber }}</span>
            <el-tag
              v-if="getOrderStatus(currentOrder) === '待付款'"
              type="warning"
              size="small"
            >
              <i class="el-icon-time"></i> 待付款
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(currentOrder) === '待发货'"
              type="primary"
              size="small"
            >
              <i class="el-icon-box"></i> 待发货
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(currentOrder) === '待收货'"
              type="success"
              size="small"
            >
              <i class="el-icon-truck"></i> 待收货
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(currentOrder) === '待评价'"
              type="warning"
              size="small"
            >
              <i class="el-icon-edit"></i> 待评价
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(currentOrder) === '已完成'"
              type="success"
              size="small"
            >
              <i class="el-icon-circle-check"></i> 已完成
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(currentOrder) === '已取消'"
              type="danger"
              size="small"
            >
              <i class="el-icon-circle-close"></i> 已取消
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(currentOrder) === '退款中'"
              type="warning"
              size="small"
            >
              <i class="el-icon-warning-outline"></i> 退款中
            </el-tag>
            <el-tag
              v-else-if="getOrderStatus(currentOrder) === '已退款'"
              type="danger"
              size="small"
            >
              <i class="el-icon-circle-close"></i> 已退款
            </el-tag>
          </div>
        </div>

        <el-divider />

        <div class="detail-section">
          <div class="section-title">
            <i class="el-icon-goods"></i> 订单信息
          </div>
          <div class="info-grid">
            <div class="info-item">
              <div class="info-label">下单人</div>
              <div class="info-value">
                {{ currentOrder.username || currentOrder.userId || "-" }}
              </div>
            </div>
            <div class="info-item">
              <div class="info-label">商家名称</div>
              <div class="info-value">
                {{ currentOrder.merchantNameDisplay || "-" }}
              </div>
            </div>
            <div class="info-item">
              <div class="info-label">下单时间</div>
              <div class="info-value">{{ currentOrder.createTime }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">订单金额</div>
              <div class="info-value total-amount">
                ¥{{ currentOrder.totalAmount }}
              </div>
            </div>
          </div>
        </div>

        <div
          class="detail-section"
          v-if="currentOrder.orderStatus !== '待付款'"
        >
          <div class="section-title">
            <i class="el-icon-truck"></i> 物流信息
          </div>
          <div class="info-grid">
            <div class="info-item">
              <div class="info-label">发货时间</div>
              <div class="info-value">
                {{ currentOrder.shippingTime || "未发货" }}
              </div>
            </div>
            <div class="info-item">
              <div class="info-label">完成时间</div>
              <div class="info-value">
                {{ currentOrder.completionTime || "未完成" }}
              </div>
            </div>
          </div>
        </div>

        <el-divider />

        <div class="detail-section">
          <div class="section-title">
            <i class="el-icon-shopping-cart-full"></i> 商品明细
          </div>
          <div class="order-items">
            <div
              v-if="
                (currentOrder.items && currentOrder.items.length > 0) ||
                (currentOrder.orderItems && currentOrder.orderItems.length > 0)
              "
              v-for="item in currentOrder.items ||
              currentOrder.orderItems ||
              []"
              :key="item.id"
              class="order-item-card"
            >
              <div class="item-info-row">
                <div class="item-name-author">
                  <span class="item-name">{{ item.bookName || "-" }}</span>
                  <span v-if="item.author" class="item-author">
                    <i class="el-icon-user-solid"></i> {{ item.author }}
                  </span>
                </div>
                <span class="item-price">¥{{ item.price }}</span>
              </div>
              <div v-if="item.merchantName" class="item-merchant-row">
                <i class="el-icon-s-shop"></i>
                <span class="merchant-name">{{ item.merchantName }}</span>
              </div>
              <div class="item-quantity-row">
                <span class="quantity-label">数量：</span>
                <span class="quantity-value">×{{ item.quantity }}</span>
                <span class="subtotal"
                  >小计：¥{{ (item.price * item.quantity).toFixed(2) }}</span
                >
              </div>
              <div class="item-status-row">
                <el-tooltip
                  :disabled="
                    !item.expressNo ||
                    !['待收货', '待评价', '已完成'].includes(item.status)
                  "
                  effect="dark"
                  :content="
                    (item.expressCompany || '快递') + '：' + item.expressNo
                  "
                  placement="top"
                  :open-delay="300"
                >
                  <el-tag
                    :type="getItemStatusTagType(item.status)"
                    size="small"
                    :class="{
                      'express-tag':
                        item.expressNo &&
                        ['待收货', '待评价', '已完成'].includes(item.status),
                    }"
                  >
                    <i :class="getItemStatusIcon(item.status)"></i>
                    {{ item.status || "正常" }}
                  </el-tag>
                </el-tooltip>
              </div>
            </div>
            <div v-else class="no-items">暂无商品明细</div>
          </div>
        </div>

        <el-divider v-if="currentOrder.remark" />

        <div v-if="currentOrder.remark" class="detail-section">
          <div class="section-title">
            <i class="el-icon-edit-outline"></i> 备注信息
          </div>
          <div class="remark-content">{{ currentOrder.remark }}</div>
        </div>
      </div>
      <div slot="footer">
        <el-button @click="detailVisible = false" size="medium"
          >关 闭</el-button
        >
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getOrderPage, deleteOrder } from "@/api/order";

export default {
  name: "OrderList",
  data() {
    return {
      orderList: [],
      loading: false,
      queryForm: {
        orderNumber: "",
        username: "",
        merchantName: "",
        dateRange: null,
        orderStatus: "",
      },
      pagination: {
        page: 1,
        pageSize: 10,
        total: 0,
      },
      detailVisible: false,
      currentOrder: null,
    };
  },
  computed: {
    currentUserRole() {
      const userInfo = localStorage.getItem("userInfo");
      if (userInfo) {
        try {
          return JSON.parse(userInfo).role;
        } catch (e) {}
      }
      return null;
    },
    getOrderStatus() {
      return (order) => {
        if (!order) return "";
        const items = order.items || order.orderItems || [];
        const hasRefundingItem = items.some((item) => item.status === "退款中");
        if (hasRefundingItem) {
          return "退款中";
        }
        return order.orderStatus;
      };
    },
  },
  mounted() {
    this.loadOrderList();
  },
  watch: {
    "queryForm.orderNumber"() {
      this.pagination.page = 1;
      this.loadOrderList();
    },
    "queryForm.username"() {
      this.pagination.page = 1;
      this.loadOrderList();
    },
    "queryForm.merchantName"() {
      this.pagination.page = 1;
      this.loadOrderList();
    },
    "queryForm.orderStatus"() {
      this.pagination.page = 1;
      this.loadOrderList();
    },
  },
  methods: {
    getItemStatusTagType(status) {
      if (!status) return "info";
      const typeMap = {
        待发货: "primary",
        待付款: "warning",
        退款中: "warning",
        待评价: "warning",
        待收货: "success",
        已完成: "success",
        已退款: "danger",
        已取消: "danger",
      };
      return typeMap[status] || "info";
    },
    getItemStatusIcon(status) {
      if (!status) return "el-icon-info";
      const iconMap = {
        待发货: "el-icon-box",
        待付款: "el-icon-time",
        退款中: "el-icon-warning-outline",
        待评价: "el-icon-edit",
        待收货: "el-icon-truck",
        已完成: "el-icon-circle-check",
        已退款: "el-icon-circle-close",
        已取消: "el-icon-circle-close",
      };
      return iconMap[status] || "el-icon-info";
    },
    formatDate(date) {
      if (!date) return "-";
      const d = new Date(date);
      const year = d.getFullYear();
      const month = String(d.getMonth() + 1).padStart(2, "0");
      const day = String(d.getDate()).padStart(2, "0");
      const hours = String(d.getHours()).padStart(2, "0");
      const minutes = String(d.getMinutes()).padStart(2, "0");
      return `${year}-${month}-${day} ${hours}:${minutes}`;
    },
    loadOrderList() {
      this.loading = true;
      const params = {
        page: this.pagination.page,
        pageSize: this.pagination.pageSize,
      };
      if (this.queryForm.orderNumber) {
        params.orderNumber = this.queryForm.orderNumber;
      }
      if (this.queryForm.username) {
        params.username = this.queryForm.username;
      }
      if (this.queryForm.orderStatus) {
        params.orderStatus = this.queryForm.orderStatus;
      }
      if (this.queryForm.merchantName) {
        params.merchantName = this.queryForm.merchantName;
      }
      if (this.queryForm.dateRange && this.queryForm.dateRange.length === 2) {
        params.startDate = this.queryForm.dateRange[0];
        params.endDate = this.queryForm.dateRange[1];
      }

      getOrderPage(params)
        .then((res) => {
          if (res.code === 200) {
            this.orderList = res.data.records || [];
            this.pagination.total = res.data.total || 0;
          }
        })
        .finally(() => {
          this.loading = false;
        });
    },
    handleQuery() {
      this.pagination.page = 1;
      this.loadOrderList();
    },
    handleReset() {
      this.queryForm = {
        orderNumber: "",
        username: "",
        merchantName: "",
        dateRange: null,
        orderStatus: "",
      };
      this.pagination.page = 1;
      this.loadOrderList();
    },
    handleSizeChange(size) {
      this.pagination.pageSize = size;
      this.pagination.page = 1;
      this.loadOrderList();
    },
    handleCurrentChange(page) {
      this.pagination.page = page;
      this.loadOrderList();
    },
    handleView(row) {
      this.currentOrder = row;
      this.detailVisible = true;
    },
    async handleDelete(row) {
      try {
        await this.$confirm(
          "确定要删除这个已完成订单吗？删除后无法恢复。",
          "删除确认",
          {
            confirmButtonText: "确定删除",
            cancelButtonText: "取消",
            type: "warning",
          }
        );
        const res = await deleteOrder(row.id);
        if (res.code === 200) {
          this.$message.success("删除成功");
          this.loadOrderList();
        }
      } catch (e) {
        // 用户点击取消，不做任何处理
      }
    },
  },
};
</script>

<style scoped>
.order-container {
  padding: 20px;
}

.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.last-update {
  font-size: 12px;
  color: #909399;
  display: flex;
  align-items: center;
  gap: 4px;
}

.order-container {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  min-height: calc(100vh - 60px);
}

.header-card {
  margin-bottom: 20px;
  border: none;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
}

.header-card ::v-deep .el-card__body {
  padding: 20px 25px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  flex: 1;
}

.header-title {
  margin: 0 0 5px 0;
  font-size: 24px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-subtitle {
  margin: 0;
  font-size: 14px;
  opacity: 0.9;
}

.search-card {
  margin-bottom: 20px;
  border: none;
  border-radius: 12px;
}

.query-form {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  align-items: flex-end;
}

.search-item {
  margin-bottom: 0;
}

.search-actions {
  margin-bottom: 0;
}

.table-card {
  border: none;
  border-radius: 12px;
}

.book-item,
.price-item,
.quantity-item,
.status-item {
  height: 28px;
  line-height: 28px;
  border-bottom: 1px solid #f0f0f0;
}

.book-item:last-child,
.price-item:last-child,
.quantity-item:last-child,
.status-item:last-child {
  border-bottom: none;
}

.book-item {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #303133;
  font-weight: 500;
}

.merchant-name-text {
  color: #303133;
  font-weight: 500;
}

.item-status-row {
  margin-top: 8px;
  display: flex;
  align-items: center;
}

.express-tag {
  cursor: pointer;
  transition: all 0.3s;
}

.express-tag:hover {
  box-shadow: 0 2px 8px rgba(103, 194, 58, 0.4);
  transform: translateY(-1px);
}

.price-item {
  color: #f56c6c;
  font-weight: 600;
}

.quantity-item {
  color: #909399;
}

.status-item {
  display: flex;
  align-items: center;
  justify-content: center;
}

.order-number-cell {
  display: flex;
  align-items: center;
  gap: 6px;
}

.remind-icon {
  color: #f56c6c;
  font-size: 16px;
  cursor: pointer;
  animation: shake 1s ease-in-out infinite;
}

@keyframes shake {
  0%,
  100% {
    transform: rotate(0deg);
  }
  25% {
    transform: rotate(15deg);
  }
  50% {
    transform: rotate(-15deg);
  }
  75% {
    transform: rotate(10deg);
  }
}

.amount-text {
  color: #f56c6c;
  font-weight: bold;
  font-size: 14px;
}

.action-buttons {
  display: flex;
  flex-wrap: nowrap;
  justify-content: center;
  gap: 5px;
}

.detail-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.detail-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
}

.detail-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.detail-dialog ::v-deep .el-dialog__body {
  padding: 25px;
}

.order-detail {
  padding: 10px;
}

.detail-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
}

.order-number-display {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
}

.order-number {
  font-weight: 600;
  color: #303133;
}

.detail-section {
  margin: 20px 0;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: #606266;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title i {
  color: #409eff;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
  padding: 0 10px;
}

.info-item {
  padding: 12px;
  background: #f5f7fa;
  border-radius: 6px;
}

.info-label {
  font-size: 12px;
  color: #909399;
  margin-bottom: 8px;
}

.info-value {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}

.info-value.total-amount {
  font-size: 18px;
  font-weight: 700;
  color: #f56c6c;
}

.order-items {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 15px;
}

.order-item-card {
  background: white;
  border-radius: 6px;
  padding: 12px;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.order-item-card:last-child {
  margin-bottom: 0;
}

.item-info-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8px;
}

.item-name-author {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
  margin-right: 15px;
}

.item-name {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
}

.item-author {
  font-size: 12px;
  color: #909399;
  display: flex;
  align-items: center;
  gap: 4px;
}

.item-author i {
  font-size: 11px;
}

.item-price {
  font-size: 14px;
  color: #409eff;
  font-weight: 600;
  flex-shrink: 0;
}

.item-quantity-row {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 13px;
  color: #909399;
  padding-top: 8px;
  border-top: 1px dashed #e4e7ed;
}

.quantity-label {
  color: #909399;
}

.quantity-value {
  color: #606266;
  font-weight: 500;
}

.subtotal {
  color: #f56c6c;
  font-weight: 600;
  margin-left: auto;
}

.item-merchant-row {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: #409eff;
  padding: 6px 0;
  border-top: 1px dashed #e4e7ed;
  margin-top: 6px;
}

.merchant-name {
  font-weight: 500;
}

.no-items {
  text-align: center;
  color: #909399;
  padding: 20px;
}

.remark-content {
  background: #f5f7fa;
  padding: 15px;
  border-radius: 6px;
  color: #606266;
  line-height: 1.8;
  font-size: 13px;
}

@media (max-width: 768px) {
  .info-grid {
    grid-template-columns: 1fr;
  }

  .order-items {
    padding: 10px;
  }

  .item-info-row {
    flex-direction: column;
    align-items: flex-start;
  }

  .item-price {
    margin-top: 5px;
  }
}
</style>
