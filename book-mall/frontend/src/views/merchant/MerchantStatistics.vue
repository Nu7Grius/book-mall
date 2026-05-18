<template>
  <div class="merchant-statistics">
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-title">
          <h2>
            <i class="el-icon-data-analysis"></i>
            数据统计
          </h2>
          <p class="subtitle">深入分析店铺经营数据</p>
        </div>
        <div class="time-selector">
          <el-radio-group
            v-model="timeRange"
            size="medium"
            @change="handleTimeRangeChange"
          >
            <el-radio-button label="day">今日</el-radio-button>
            <el-radio-button label="week">近7天</el-radio-button>
            <el-radio-button label="month">近30天</el-radio-button>
            <el-radio-button label="all">全部</el-radio-button>
          </el-radio-group>
        </div>
      </div>
    </el-card>

    <el-row :gutter="20" class="stats-row">
      <el-col :xs="12" :sm="12" :md="6">
        <el-card class="stat-card stat-actual" shadow="hover">
          <div class="stat-icon-wrapper">
            <i class="el-icon-wallet"></i>
          </div>
          <div class="stat-content">
            <div class="stat-value">¥{{ statistics.actualSales }}</div>
            <div class="stat-label">实际成交额</div>
            <div class="stat-compare">
              <span class="compare-text">实际收入</span>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="12" :sm="12" :md="6">
        <el-card class="stat-card stat-completed" shadow="hover">
          <div class="stat-icon-wrapper">
            <i class="el-icon-circle-check"></i>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ statistics.completedOrders }}</div>
            <div class="stat-label">已完成订单</div>
            <div class="stat-compare">
              <span class="compare-text">交易成功</span>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="12" :sm="12" :md="6">
        <el-card class="stat-card stat-avg" shadow="hover">
          <div class="stat-icon-wrapper">
            <i class="el-icon-coin"></i>
          </div>
          <div class="stat-content">
            <div class="stat-value">¥{{ statistics.avgOrderValue }}</div>
            <div class="stat-label">客单价</div>
            <div class="stat-compare">
              <span class="compare-text">平均每单</span>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="12" :sm="12" :md="6">
        <el-card class="stat-card stat-refund" shadow="hover">
          <div class="stat-icon-wrapper">
            <i class="el-icon-warning-outline"></i>
          </div>
          <div class="stat-content">
            <div class="stat-value">¥{{ statistics.refundAmount }}</div>
            <div class="stat-label">退款总额</div>
            <div class="stat-compare">
              <span class="compare-text refund">需关注</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="charts-row">
      <el-col :span="24">
        <el-card class="chart-card">
          <div slot="header" class="card-header">
            <span>📈 销售趋势分析</span>
            <el-tag size="small" type="info">{{ getTimeRangeText() }}</el-tag>
          </div>
          <div ref="salesChart" style="width: 100%; height: 350px"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-card class="detail-card">
      <div slot="header" class="card-header">
        <div class="detail-header-left">
          <span>📋 每日明细</span>
          <div class="detail-summary">
            <span
              >共 <strong>{{ statistics.orders }}</strong> 笔订单，</span
            >
            <span
              >总销售额 <strong>¥{{ statistics.sales }}</strong></span
            >
          </div>
        </div>
        <div class="detail-header-right">
          <el-radio-group
            v-model="viewMode"
            size="small"
            class="view-mode-switch"
          >
            <el-radio-button label="card">
              <i class="el-icon-s-grid"></i> 卡片
            </el-radio-button>
            <el-radio-button label="table">
              <i class="el-icon-s-fold"></i> 表格
            </el-radio-button>
          </el-radio-group>
          <el-button
            v-if="salesDetail.length > displayLimit"
            size="small"
            type="text"
            @click="toggleExpand"
          >
            {{ isExpanded ? "收起" : "展开全部" }}
            <i
              :class="isExpanded ? 'el-icon-arrow-up' : 'el-icon-arrow-down'"
            ></i>
          </el-button>
        </div>
      </div>

      <div v-if="salesDetail.length === 0" class="empty-state">
        <i class="el-icon-document"></i>
        <p>暂无销售明细</p>
      </div>

      <!-- 卡片视图 -->
      <div v-else-if="viewMode === 'card'" class="detail-grid">
        <div
          v-for="(item, index) in displayedDetail"
          :key="index"
          class="detail-item"
        >
          <div class="detail-date">
            <span class="date-day">{{ formatDay(item.date) }}</span>
            <span class="date-week">{{ formatWeek(item.date) }}</span>
          </div>
          <div class="detail-stats">
            <div class="detail-stat">
              <span class="detail-label">订单</span>
              <span class="detail-value">{{ item.orders }}</span>
            </div>
            <div class="detail-stat">
              <span class="detail-label">销售额</span>
              <span class="detail-value highlight"
                >¥{{ formatNumber(item.sales) }}</span
              >
            </div>
            <div class="detail-stat">
              <span class="detail-label">客户</span>
              <span class="detail-value">{{ item.customers }}</span>
            </div>
            <div class="detail-stat">
              <span class="detail-label">客单价</span>
              <span class="detail-value"
                >¥{{ formatNumber(item.avgOrderValue) }}</span
              >
            </div>
          </div>
        </div>
      </div>

      <!-- 表格视图 -->
      <div v-else class="detail-table-wrapper">
        <el-table
          :data="displayedDetail"
          stripe
          border
          class="detail-table"
          :header-cell-style="{ background: '#f5f7fa', color: '#606266' }"
        >
          <el-table-column label="日期" width="120" align="center">
            <template slot-scope="scope">
              <div class="table-date">
                <span class="table-date-day">{{
                  formatDay(scope.row.date)
                }}</span>
                <span class="table-date-week">{{
                  formatWeek(scope.row.date)
                }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column
            prop="orders"
            label="订单数"
            width="100"
            align="center"
          >
            <template slot-scope="scope">
              <el-tag size="medium" type="info">{{ scope.row.orders }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="销售额" align="center">
            <template slot-scope="scope">
              <span class="table-sales"
                >¥{{ formatNumber(scope.row.sales) }}</span
              >
            </template>
          </el-table-column>
          <el-table-column
            prop="customers"
            label="客户数"
            width="100"
            align="center"
          >
            <template slot-scope="scope">
              <el-tag size="medium" type="warning">{{
                scope.row.customers
              }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="客单价" align="center">
            <template slot-scope="scope">
              <span class="table-avg"
                >¥{{ formatNumber(scope.row.avgOrderValue) }}</span
              >
            </template>
          </el-table-column>
        </el-table>

        <div v-if="salesDetail.length > displayLimit" class="table-expand-hint">
          <span>共 {{ salesDetail.length }} 天数据，</span>
          <el-button type="text" size="small" @click="toggleExpand">
            {{ isExpanded ? "收起部分" : "展开全部" }}
          </el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
import * as echarts from "echarts";

export default {
  name: "MerchantStatistics",
  data() {
    return {
      timeRange: "week",
      viewMode: "card",
      isExpanded: false,
      displayLimit: 6,
      statistics: {
        actualSales: "0.00",
        completedOrders: 0,
        avgOrderValue: "0.00",
        refundAmount: "0.00",
      },
      previousStatistics: {
        actualSales: "0.00",
        completedOrders: 0,
        avgOrderValue: "0.00",
        refundAmount: "0.00",
      },
      productRanking: [],
      salesDetail: [],
      salesTrendChart: null,
      autoRefreshTimer: null,
    };
  },
  computed: {
    displayedDetail() {
      if (this.isExpanded) {
        return this.salesDetail;
      }
      return this.salesDetail.slice(0, this.displayLimit);
    },
  },
  mounted() {
    this.loadData();
    window.addEventListener(
      "order-status-updated",
      this.handleOrderStatusUpdate
    );
    window.addEventListener(
      "merchant-info-updated",
      this.handleMerchantInfoUpdate
    );
    this.startAutoRefresh();
  },
  beforeDestroy() {
    if (this.salesTrendChart) {
      this.salesTrendChart.dispose();
    }
    window.removeEventListener(
      "order-status-updated",
      this.handleOrderStatusUpdate
    );
    window.removeEventListener(
      "merchant-info-updated",
      this.handleMerchantInfoUpdate
    );
    this.stopAutoRefresh();
  },
  methods: {
    startAutoRefresh() {
      if (this.autoRefreshTimer) {
        clearInterval(this.autoRefreshTimer);
      }
      this.autoRefreshTimer = setInterval(() => {
        this.loadData();
      }, 30000);
    },
    stopAutoRefresh() {
      if (this.autoRefreshTimer) {
        clearInterval(this.autoRefreshTimer);
        this.autoRefreshTimer = null;
      }
    },
    handleOrderStatusUpdate() {
      this.loadData();
    },
    handleMerchantInfoUpdate() {
      this.loadData();
    },
    handleTimeRangeChange() {
      this.loadData();
    },
    loadData() {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) {
        this.$message.error("未获取到商家信息");
        return;
      }

      this.loadStatistics();
      this.loadSalesDetail();
    },
    loadStatistics() {
      const merchantId = localStorage.getItem("merchantId");
      this.previousStatistics = { ...this.statistics };

      this.$http
        .get("/merchant/detailed-statistics", {
          params: {
            merchantId: parseInt(merchantId),
            range: this.timeRange,
          },
        })
        .then((res) => {
          const data = res.data || {};

          this.statistics = {
            actualSales:
              data.actualSales != null
                ? parseFloat(data.actualSales).toFixed(2)
                : "0.00",
            completedOrders: data.orders || 0,
            avgOrderValue:
              data.avgOrderValue != null
                ? parseFloat(data.avgOrderValue).toFixed(2)
                : "0.00",
            refundAmount:
              data.refundAmount != null
                ? parseFloat(data.refundAmount).toFixed(2)
                : "0.00",
          };
        })
        .catch(() => {});
    },
    loadProductRanking() {
      const merchantId = localStorage.getItem("merchantId");

      this.$http
        .get("/merchant/hot-books", {
          params: { merchantId: parseInt(merchantId), limit: 5 },
        })
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.productRanking = res.data;
          }
        })
        .catch(() => {});
    },
    loadSalesDetail() {
      const merchantId = localStorage.getItem("merchantId");

      let days = 7;
      switch (this.timeRange) {
        case "day":
          days = 1;
          break;
        case "week":
          days = 7;
          break;
        case "month":
          days = 30;
          break;
        case "all":
          days = 90;
          break;
      }

      this.$http
        .get("/merchant/sales-detail", {
          params: { merchantId: parseInt(merchantId), days: days },
        })
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.salesDetail = res.data.map((item) => ({
              ...item,
              sales: item.sales !== null ? parseFloat(item.sales) : 0,
              avgOrderValue:
                item.avgOrderValue !== null
                  ? parseFloat(item.avgOrderValue)
                  : 0,
            }));
            this.updateChart();
          }
        })
        .catch(() => {});
    },
    updateChart() {
      this.$nextTick(() => {
        if (!this.$refs.salesChart) return;

        if (!this.salesTrendChart) {
          this.salesTrendChart = echarts.init(this.$refs.salesChart);
        }

        const dates = this.salesDetail.map((item) => this.formatDay(item.date));
        const salesData = this.salesDetail.map((item) =>
          item.sales ? parseFloat(item.sales) : 0
        );

        const option = {
          tooltip: {
            trigger: "axis",
            backgroundColor: "rgba(50, 50, 50, 0.9)",
            borderColor: "#409EFF",
            textStyle: {
              color: "#fff",
            },
            formatter: function (params) {
              const data = params[0];
              return (
                "<div style='padding: 5px;'>" +
                "<div style='font-weight: bold; margin-bottom: 5px;'>" +
                data.axisValue +
                "</div>" +
                "<div>销售额：<span style='color: #409EFF; font-weight: bold;'>¥" +
                data.value.toFixed(2) +
                "</span></div>" +
                "</div>"
              );
            },
          },
          grid: {
            left: "3%",
            right: "4%",
            bottom: "3%",
            top: "10%",
            containLabel: true,
          },
          xAxis: {
            type: "category",
            data: dates,
            axisLine: {
              lineStyle: {
                color: "#E4E7ED",
              },
            },
            axisLabel: {
              color: "#606266",
            },
          },
          yAxis: {
            type: "value",
            axisLine: {
              show: false,
            },
            axisTick: {
              show: false,
            },
            axisLabel: {
              color: "#909399",
              formatter: "¥{value}",
            },
            splitLine: {
              lineStyle: {
                color: "#F5F7FA",
              },
            },
          },
          series: [
            {
              name: "销售额",
              type: "line",
              smooth: true,
              symbol: "circle",
              symbolSize: 8,
              data: salesData,
              itemStyle: {
                color: "#409EFF",
              },
              lineStyle: {
                width: 3,
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

        this.salesTrendChart.setOption(option);

        window.addEventListener("resize", () => {
          if (this.salesTrendChart) {
            this.salesTrendChart.resize();
          }
        });
      });
    },
    formatNumber(value) {
      if (value === null || value === undefined) return "0.00";
      return parseFloat(value).toFixed(2);
    },
    formatDay(dateStr) {
      if (!dateStr) return "";
      const parts = dateStr.split("-");
      return `${parseInt(parts[1])}/${parseInt(parts[2])}`;
    },
    formatWeek(dateStr) {
      if (!dateStr) return "";
      const date = new Date(dateStr);
      const weeks = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"];
      return weeks[date.getDay()];
    },
    getTrendClass(key) {
      const current = parseFloat(this.statistics[key]) || 0;
      const previous = parseFloat(this.previousStatistics[key]) || 0;
      if (current > previous) return "trend-up";
      if (current < previous) return "trend-down";
      return "trend-same";
    },
    getTrendText(key) {
      const current = parseFloat(this.statistics[key]) || 0;
      const previous = parseFloat(this.previousStatistics[key]) || 0;
      if (previous === 0) return "数据不足";
      const change = (((current - previous) / previous) * 100).toFixed(1);
      if (current > previous) return `↑ ${change}%`;
      if (current < previous) return `↓ ${Math.abs(change)}%`;
      return "持平";
    },
    getSalesBarWidth(salesCount) {
      if (!this.productRanking || this.productRanking.length === 0) return "0%";
      const maxSales = Math.max(
        ...this.productRanking.map((p) => p.salesCount || 0)
      );
      if (maxSales === 0) return "0%";
      return `${((salesCount / maxSales) * 100).toFixed(0)}%`;
    },
    getTimeRangeText() {
      const map = {
        day: "今日",
        week: "近7天",
        month: "近30天",
        all: "全部时间",
      };
      return map[this.timeRange] || "近7天";
    },
    viewAllRanking() {
      this.$message.info("查看全部商品排行功能开发中...");
    },
    toggleExpand() {
      this.isExpanded = !this.isExpanded;
    },
  },
};
</script>

<style scoped>
.merchant-statistics {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 60px);
}

.header-card {
  margin-bottom: 20px;
  border: none;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.header-card ::v-deep .el-card__body {
  padding: 25px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
}

.header-title h2 {
  margin: 0 0 5px 0;
  font-size: 24px;
  font-weight: 600;
}

.subtitle {
  margin: 0;
  font-size: 14px;
  opacity: 0.9;
}

.time-selector ::v-deep .el-radio-button__inner {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
}

.time-selector
  ::v-deep
  .el-radio-button__orig-radio:checked
  + .el-radio-button__inner {
  background: white;
  border-color: white;
  color: #409eff;
  box-shadow: none;
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  border: none;
  border-radius: 12px;
  transition: transform 0.3s, box-shadow 0.3s;
  overflow: hidden;
  height: 100%;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.stat-icon-wrapper {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  margin: 0 auto 15px;
}

.stat-actual .stat-icon-wrapper {
  background: linear-gradient(135deg, #67c23a 0%, #85ce61 100%);
}

.stat-completed .stat-icon-wrapper {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
}

.stat-avg .stat-icon-wrapper {
  background: linear-gradient(135deg, #e6a23c 0%, #ebb563 100%);
}

.stat-refund .stat-icon-wrapper {
  background: linear-gradient(135deg, #f56c6c 0%, #f78989 100%);
}

.stat-content {
  text-align: center;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.stat-compare {
  margin-top: 8px;
}

.compare-text {
  font-size: 12px;
  padding: 3px 10px;
  border-radius: 10px;
  background: #f5f7fa;
  color: #909399;
}

.compare-text.refund {
  background: #fef0f0;
  color: #f56c6c;
}

.charts-row {
  margin-bottom: 20px;
}

.chart-card,
.detail-card {
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

.detail-summary {
  font-size: 14px;
  color: #909399;
}

.detail-summary strong {
  color: #409eff;
  font-weight: 600;
}

.detail-header-left {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.detail-header-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.view-mode-switch ::v-deep .el-radio-button__inner {
  padding: 7px 12px;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 15px;
}

.detail-item {
  background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
  border-radius: 10px;
  padding: 15px;
  display: flex;
  gap: 15px;
  transition: all 0.3s;
  border: 1px solid #ebeef5;
}

.detail-item:hover {
  background: white;
  border-color: #409eff;
  box-shadow: 0 4px 15px rgba(64, 158, 255, 0.15);
  transform: translateY(-2px);
}

.detail-date {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-width: 60px;
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border-radius: 8px;
  padding: 10px 8px;
  color: white;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);
}

.date-day {
  font-size: 18px;
  font-weight: bold;
}

.date-week {
  font-size: 11px;
  opacity: 0.9;
}

.detail-stats {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
}

.detail-stat {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.detail-label {
  font-size: 11px;
  color: #909399;
  margin-bottom: 3px;
}

.detail-value {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}

.detail-value.highlight {
  color: #409eff;
}

.detail-table-wrapper {
  padding: 5px 0;
}

.detail-table {
  border-radius: 8px;
  overflow: hidden;
}

.detail-table ::v-deep .el-table__header th {
  font-weight: 600;
}

.table-date {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.table-date-day {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}

.table-date-week {
  font-size: 11px;
  color: #909399;
}

.table-sales {
  font-size: 15px;
  font-weight: 600;
  color: #f56c6c;
}

.table-avg {
  font-size: 14px;
  color: #e6a23c;
}

.table-expand-hint {
  margin-top: 15px;
  text-align: center;
  font-size: 13px;
  color: #909399;
  padding: 10px;
  background: #f5f7fa;
  border-radius: 6px;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #909399;
}

.empty-state i {
  font-size: 48px;
  margin-bottom: 15px;
  opacity: 0.5;
}

.empty-state p {
  margin: 0;
  font-size: 14px;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .detail-grid {
    grid-template-columns: 1fr;
  }
}
</style>
