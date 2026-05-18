<template>
  <div
    class="merchant-home"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-s-home"></i>
            店铺信息中心
          </h2>
          <p class="header-subtitle">管理您的店铺信息</p>
        </div>
        <el-button
          type="primary"
          size="medium"
          @click="refreshData"
          class="refresh-btn"
        >
          <i class="el-icon-refresh"></i> 刷新数据
        </el-button>
      </div>
    </el-card>

    <el-row :gutter="20" class="stats-row">
      <el-col :xs="12" :sm="12" :md="6">
        <el-card class="stat-card stat-books" shadow="hover">
          <div class="stat-icon-wrapper">
            <i class="el-icon-reading"></i>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ statistics.totalBooks }}</div>
            <div class="stat-label">图书总数</div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="12" :sm="12" :md="6">
        <el-card class="stat-card stat-orders" shadow="hover">
          <div class="stat-icon-wrapper">
            <i class="el-icon-document"></i>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ statistics.totalOrders }}</div>
            <div class="stat-label">订单总数</div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="12" :sm="12" :md="6">
        <el-card class="stat-card stat-sales" shadow="hover">
          <div class="stat-icon-wrapper">
            <i class="el-icon-sell"></i>
          </div>
          <div class="stat-content">
            <div class="stat-value">¥{{ statistics.totalSales }}</div>
            <div class="stat-label">销售总额</div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="12" :sm="12" :md="6">
        <el-card class="stat-card stat-customers" shadow="hover">
          <div class="stat-icon-wrapper">
            <i class="el-icon-user"></i>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ statistics.totalCustomers }}</div>
            <div class="stat-label">客户总数</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="charts-row">
      <el-col :xs="24" :lg="16">
        <el-card class="chart-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-s-marketing"></i> 销售趋势（近7天）</span>
            <el-tag size="small" type="info">实时数据</el-tag>
          </div>
          <div ref="salesChart" style="width: 100%; height: 320px"></div>
        </el-card>
      </el-col>

      <el-col :xs="24" :lg="8">
        <el-card class="shop-info-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-s-shop"></i> 店铺信息</span>
          </div>
          <div class="shop-info">
            <div class="shop-logo">
              <el-avatar
                v-if="shopInfo.logo"
                :size="60"
                :src="getImageUrl(shopInfo.logo)"
              ></el-avatar>
              <el-avatar v-else :size="60" icon="el-icon-shop"></el-avatar>
            </div>
            <div class="shop-name">{{ shopInfo.shopName }}</div>
            <div class="info-grid">
              <div class="info-item">
                <i class="el-icon-user"></i>
                <span>{{ shopInfo.realName }}</span>
              </div>
              <div class="info-item">
                <i class="el-icon-phone"></i>
                <span>{{ shopInfo.phone }}</span>
              </div>
              <div class="info-item">
                <i class="el-icon-location"></i>
                <span>{{ shopInfo.address }}</span>
              </div>
              <div class="info-item">
                <i class="el-icon-date"></i>
                <span>{{ shopInfo.createTime }}</span>
              </div>
            </div>
            <el-button
              type="primary"
              size="small"
              class="edit-btn"
              @click="$router.push('/merchant/shop-info')"
            >
              <i class="el-icon-edit"></i> 编辑店铺信息
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="tables-row">
      <el-col :xs="24" :lg="12">
        <el-card class="table-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-document"></i> 最新订单</span>
            <el-button
              type="text"
              size="small"
              @click="$router.push('/merchant/orders')"
            >
              查看全部 <i class="el-icon-arrow-right"></i>
            </el-button>
          </div>
          <el-table :data="recentOrders" style="width: 100%" :stripe="true">
            <el-table-column prop="orderNo" label="订单号" width="140" />
            <el-table-column prop="bookName" label="商品名称" min-width="140" />
            <el-table-column
              prop="quantity"
              label="数量"
              width="70"
              align="center"
            />
            <el-table-column label="金额" width="100" align="center">
              <template slot-scope="scope">
                <span class="amount">¥{{ scope.row.totalPrice }}</span>
              </template>
            </el-table-column>
            <el-table-column label="状态" width="90" align="center">
              <template slot-scope="scope">
                <el-tag :type="getStatusType(scope.row.status)" size="small">
                  {{ scope.row.status }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <el-col :xs="24" :lg="12">
        <el-card class="table-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-reading"></i> 热门图书 TOP 5</span>
            <el-button
              type="text"
              size="small"
              @click="$router.push('/merchant/books')"
            >
              查看全部 <i class="el-icon-arrow-right"></i>
            </el-button>
          </div>
          <div class="hot-books-list">
            <div
              v-for="(book, index) in hotBooks"
              :key="index"
              class="hot-book-item"
            >
              <div class="rank-badge" :class="'rank-' + (index + 1)">
                {{ index + 1 }}
              </div>
              <div class="book-info">
                <div class="book-name">{{ book.name }}</div>
                <div class="book-meta">
                  <span class="sales-count">已售 {{ book.salesCount }}</span>
                </div>
              </div>
              <div class="book-price">¥{{ book.price }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from "echarts";

export default {
  name: "MerchantHome",
  data() {
    return {
      statistics: {
        totalBooks: 0,
        totalOrders: 0,
        completedOrders: 0,
        pendingOrders: 0,
        totalSales: 0,
        refundAmount: 0,
        actualSales: 0,
        avgOrderValue: 0,
        totalCustomers: 0,
      },
      shopInfo: {
        shopName: "",
        realName: "",
        phone: "",
        address: "",
        createTime: "",
      },
      recentOrders: [],
      hotBooks: [],
      salesChart: null,
      loading: false,
    };
  },
  mounted() {
    this.loadStatistics();
    this.loadShopInfo();
    this.loadRecentOrders();
    this.loadHotBooks();
    this.initChart();
    window.addEventListener(
      "order-status-updated",
      this.handleOrderStatusUpdate
    );
    window.addEventListener(
      "merchant-info-updated",
      this.handleMerchantInfoUpdate
    );
  },
  beforeDestroy() {
    if (this.salesChart) {
      this.salesChart.dispose();
    }
    window.removeEventListener(
      "order-status-updated",
      this.handleOrderStatusUpdate
    );
    window.removeEventListener(
      "merchant-info-updated",
      this.handleMerchantInfoUpdate
    );
  },
  methods: {
    getImageUrl(path) {
      if (!path) return "";
      if (path.startsWith("http")) return path;
      return "http://localhost:8080" + path;
    },
    handleOrderStatusUpdate() {
      this.loadStatistics();
      this.loadRecentOrders();
      this.loadSalesTrend();
    },
    handleMerchantInfoUpdate() {
      this.loadShopInfo();
    },
    loadStatistics() {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) return;

      this.$http
        .get("/merchant/statistics", {
          params: { merchantId: parseInt(merchantId) },
        })
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.statistics = {
              totalBooks: res.data.totalBooks || 0,
              totalOrders: res.data.totalOrders || 0,
              completedOrders: res.data.completedOrders || 0,
              pendingOrders: res.data.pendingOrders || 0,
              totalSales: res.data.totalSales
                ? parseFloat(res.data.totalSales).toFixed(2)
                : "0.00",
              refundAmount: res.data.refundAmount
                ? parseFloat(res.data.refundAmount).toFixed(2)
                : "0.00",
              actualSales: res.data.actualSales
                ? parseFloat(res.data.actualSales).toFixed(2)
                : "0.00",
              avgOrderValue: res.data.avgOrderValue
                ? parseFloat(res.data.avgOrderValue).toFixed(2)
                : "0.00",
              totalCustomers: res.data.totalCustomers || 0,
            };
          }
        })
        .catch(() => {});
    },
    loadShopInfo() {
      const merchantInfo = localStorage.getItem("merchantInfo");
      if (merchantInfo) {
        const info = JSON.parse(merchantInfo);
        this.shopInfo = {
          shopName: info.shopName || "我的书店",
          logo: info.logo || "",
          realName: info.realName || "未设置",
          phone: info.phone || "未设置",
          address: info.address || "未设置",
          createTime: info.createTime || new Date().toLocaleDateString(),
        };
      } else {
        this.shopInfo = {
          shopName: "我的书店",
          logo: "",
          realName: "未设置",
          phone: "未设置",
          address: "未设置",
          createTime: new Date().toLocaleDateString(),
        };
      }
    },
    loadRecentOrders() {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) return;

      this.$http
        .get("/merchant/recent-orders", {
          params: { merchantId: parseInt(merchantId), limit: 5 },
        })
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.recentOrders = res.data.map((order) => ({
              orderNo: order.orderNo,
              bookName: order.bookName || "未知图书",
              quantity: order.quantity || 1,
              totalPrice: order.totalPrice || 0,
              status: this.getStatusText(order.status),
            }));
          }
        })
        .catch(() => {});
    },
    loadHotBooks() {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) return;

      this.$http
        .get("/merchant/hot-books", {
          params: { merchantId: parseInt(merchantId), limit: 5 },
        })
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.hotBooks = res.data.map((book) => ({
              name: book.name,
              salesCount: book.salesCount || 0,
              price: book.price || 0,
            }));
          }
        })
        .catch(() => {});
    },
    getStatusText(status) {
      const statusMap = {
        pending: "待处理",
        processing: "处理中",
        shipped: "已发货",
        completed: "已完成",
        cancelled: "已取消",
      };
      return statusMap[status] || status || "未知";
    },
    getStatusType(status) {
      const typeMap = {
        待处理: "warning",
        处理中: "primary",
        已发货: "info",
        已完成: "success",
        已取消: "danger",
      };
      return typeMap[status] || "info";
    },
    refreshData() {
      this.loading = true;
      setTimeout(() => {
        this.loadStatistics();
        this.loadShopInfo();
        this.loadRecentOrders();
        this.loadHotBooks();
        this.$message.success("数据已刷新");
        this.loading = false;
      }, 500);
    },
    initChart() {
      this.loadSalesTrend();
    },
    loadSalesTrend() {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) {
        this.initEmptyChart();
        return;
      }

      this.$http
        .get("/merchant/sales-trend", {
          params: { merchantId: parseInt(merchantId) },
        })
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.updateChart(res.data);
          } else {
            this.initEmptyChart();
          }
        })
        .catch(() => {
          this.initEmptyChart();
        });
    },
    updateChart(trendData) {
      this.$nextTick(() => {
        if (!this.$refs.salesChart) return;

        if (!this.salesChart) {
          this.salesChart = echarts.init(this.$refs.salesChart);
        }

        const xAxisData = trendData.map((item) => item.dayName);
        const seriesData = trendData.map((item) =>
          item.sales ? parseFloat(item.sales) : 0
        );

        const option = {
          tooltip: {
            trigger: "axis",
            formatter: function (params) {
              const data = params[0];
              return (
                data.axisValue + "<br/>" + "日销售额：¥" + data.value.toFixed(2)
              );
            },
          },
          xAxis: {
            type: "category",
            data: xAxisData,
          },
          yAxis: {
            type: "value",
            axisLabel: {
              formatter: "¥{value}",
            },
          },
          series: [
            {
              name: "日销售额",
              type: "line",
              smooth: true,
              data: seriesData,
              itemStyle: {
                color: "#409EFF",
              },
              areaStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                  { offset: 0, color: "rgba(64, 158, 255, 0.3)" },
                  { offset: 1, color: "rgba(64, 158, 255, 0.05)" },
                ]),
              },
            },
          ],
        };

        this.salesChart.setOption(option);

        window.addEventListener("resize", () => {
          if (this.salesChart) {
            this.salesChart.resize();
          }
        });
      });
    },
    initEmptyChart() {
      this.$nextTick(() => {
        if (!this.$refs.salesChart) return;

        if (!this.salesChart) {
          this.salesChart = echarts.init(this.$refs.salesChart);
        }

        const option = {
          tooltip: {
            trigger: "axis",
          },
          xAxis: {
            type: "category",
            data: ["暂无数据"],
          },
          yAxis: {
            type: "value",
            axisLabel: {
              formatter: "¥{value}",
            },
          },
          series: [
            {
              name: "日销售额",
              type: "line",
              smooth: true,
              data: [0],
              itemStyle: {
                color: "#409EFF",
              },
            },
          ],
        };

        this.salesChart.setOption(option);

        window.addEventListener("resize", () => {
          if (this.salesChart) {
            this.salesChart.resize();
          }
        });
      });
    },
  },
};
</script>

<style scoped>
.merchant-home {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  min-height: calc(100vh - 60px);
}

.header-card {
  margin-bottom: 20px;
  border: none;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

.refresh-btn {
  background: white;
  border: none;
  color: #409eff;
  font-weight: 500;
  transition: all 0.3s;
}

.refresh-btn:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  border: none;
  border-radius: 12px;
  padding: 20px;
  transition: all 0.3s;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 15px;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.stat-icon-wrapper {
  width: 55px;
  height: 55px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  flex-shrink: 0;
}

.stat-books .stat-icon-wrapper {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.stat-orders .stat-icon-wrapper {
  background: linear-gradient(135deg, #67c23a 0%, #85ce61 100%);
  box-shadow: 0 4px 12px rgba(103, 194, 58, 0.4);
}

.stat-completed .stat-icon-wrapper {
  background: linear-gradient(135deg, #00d8a0 0%, #4cd964 100%);
  box-shadow: 0 4px 12px rgba(0, 216, 160, 0.4);
}

.stat-sales .stat-icon-wrapper {
  background: linear-gradient(135deg, #e6a23c 0%, #ebb563 100%);
  box-shadow: 0 4px 12px rgba(230, 162, 60, 0.4);
}

.stat-refund .stat-icon-wrapper {
  background: linear-gradient(135deg, #f56c6c 0%, #e04040 100%);
  box-shadow: 0 4px 12px rgba(245, 108, 108, 0.4);
}

.stat-actual .stat-icon-wrapper {
  background: linear-gradient(135deg, #9c27b0 0%, #ba68c8 100%);
  box-shadow: 0 4px 12px rgba(156, 39, 176, 0.4);
}

.stat-customers .stat-icon-wrapper {
  background: linear-gradient(135deg, #ff9800 0%, #ffb74d 100%);
  box-shadow: 0 4px 12px rgba(255, 152, 0, 0.4);
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 26px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 13px;
  color: #909399;
}

.charts-row {
  margin-bottom: 20px;
}

.chart-card,
.shop-info-card,
.table-card {
  border: none;
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
  font-weight: 600;
}

.card-header span {
  display: flex;
  align-items: center;
  gap: 8px;
}

.shop-info {
  text-align: center;
  padding: 10px 0;
}

.shop-logo {
  margin-bottom: 15px;
}

.shop-logo ::v-deep .el-avatar {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  font-size: 28px;
}

.shop-name {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 20px;
}

.info-grid {
  text-align: left;
  margin-bottom: 20px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
  font-size: 14px;
  color: #606266;
}

.info-item:last-child {
  border-bottom: none;
}

.info-item i {
  color: #409eff;
  font-size: 16px;
  width: 20px;
  text-align: center;
}

.edit-btn {
  width: 100%;
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border: none;
  transition: all 0.3s;
}

.edit-btn:hover {
  transform: scale(1.02);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.amount {
  font-weight: 600;
  color: #f56c6c;
}

.hot-books-list {
  padding: 5px 0;
}

.hot-book-item {
  display: flex;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
  transition: all 0.3s;
}

.hot-book-item:last-child {
  border-bottom: none;
}

.hot-book-item:hover {
  background: #f5f7fa;
  padding-left: 10px;
}

.rank-badge {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px;
  font-weight: bold;
  color: white;
  margin-right: 12px;
  background: #909399;
  flex-shrink: 0;
}

.rank-badge.rank-1 {
  background: linear-gradient(135deg, #ffd700 0%, #ffb347 100%);
}

.rank-badge.rank-2 {
  background: linear-gradient(135deg, #c0c0c0 0%, #a0a0a0 100%);
}

.rank-badge.rank-3 {
  background: linear-gradient(135deg, #cd7f32 0%, #b87333 100%);
}

.book-info {
  flex: 1;
  min-width: 0;
}

.book-name {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.book-meta {
  display: flex;
  gap: 10px;
  font-size: 12px;
  color: #909399;
}

.sales-count {
  color: #67c23a;
}

.book-price {
  font-size: 15px;
  font-weight: 600;
  color: #f56c6c;
  margin-left: 10px;
}

.tables-row {
  margin-bottom: 20px;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
}
</style>
