<template>
  <div class="home-container">
    <el-row :gutter="20">
      <el-col :span="4">
        <el-card class="stat-card" shadow="hover">
          <div
            class="stat-icon"
            style="
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            "
          >
            <i class="el-icon-s-custom"></i>
          </div>
          <div class="stat-info">
            <p class="stat-title">管理员</p>
            <p class="stat-value">{{ statistics.adminCount }}</p>
          </div>
        </el-card>
      </el-col>

      <el-col :span="4">
        <el-card class="stat-card" shadow="hover">
          <div
            class="stat-icon"
            style="
              background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
            "
          >
            <i class="el-icon-user"></i>
          </div>
          <div class="stat-info">
            <p class="stat-title">会员总数</p>
            <p class="stat-value">{{ statistics.userCount }}</p>
          </div>
        </el-card>
      </el-col>

      <el-col :span="4">
        <el-card class="stat-card" shadow="hover">
          <div
            class="stat-icon"
            style="
              background: linear-gradient(135deg, #67c23a 0%, #85ce61 100%);
            "
          >
            <i class="el-icon-s-shop"></i>
          </div>
          <div class="stat-info">
            <p class="stat-title">商家数量</p>
            <p class="stat-value">{{ statistics.merchantCount }}</p>
          </div>
        </el-card>
      </el-col>

      <el-col :span="4">
        <el-card class="stat-card" shadow="hover">
          <div
            class="stat-icon"
            style="
              background: linear-gradient(135deg, #e6a23c 0%, #ebb563 100%);
            "
          >
            <i class="el-icon-reading"></i>
          </div>
          <div class="stat-info">
            <p class="stat-title">图书总数</p>
            <p class="stat-value">{{ statistics.bookCount }}</p>
          </div>
        </el-card>
      </el-col>

      <el-col :span="4">
        <el-card class="stat-card" shadow="hover">
          <div
            class="stat-icon"
            style="
              background: linear-gradient(135deg, #f56c6c 0%, #f78989 100%);
            "
          >
            <i class="el-icon-document"></i>
          </div>
          <div class="stat-info">
            <p class="stat-title">订单总数</p>
            <p class="stat-value">{{ statistics.orderCount }}</p>
          </div>
        </el-card>
      </el-col>

      <el-col :span="4">
        <el-card class="stat-card" shadow="hover">
          <div
            class="stat-icon"
            style="
              background: linear-gradient(135deg, #909399 0%, #a6a9ad 100%);
            "
          >
            <i class="el-icon-shopping-cart-2"></i>
          </div>
          <div class="stat-info">
            <p class="stat-title">今日订单</p>
            <p class="stat-value">{{ statistics.todayOrderCount }}</p>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="24">
        <el-card>
          <div slot="header">
            <span>🏆 热门图书 TOP 5</span>
          </div>
          <el-table
            :data="hotBooks"
            style="width: 100%"
            v-loading="loadingBooks"
            stripe
          >
            <el-table-column prop="rank" label="排名" width="80" align="center">
              <template slot-scope="scope">
                <div class="book-rank" :class="'rank-' + (scope.$index + 1)">
                  {{ scope.$index + 1 }}
                </div>
              </template>
            </el-table-column>
            <el-table-column
              prop="bookName"
              label="书名"
              min-width="180"
            ></el-table-column>
            <el-table-column
              prop="author"
              label="作者"
              width="240"
            ></el-table-column>
            <el-table-column prop="price" label="价格" width="80">
              <template slot-scope="scope">
                <span style="color: #ff4400; font-weight: bold"
                  >¥{{ scope.row.price }}</span
                >
              </template>
            </el-table-column>
            <el-table-column
              prop="sales"
              label="销量"
              width="80"
              align="center"
            ></el-table-column>
            <el-table-column
              prop="shopType"
              label="店铺类型"
              width="100"
              align="center"
            >
              <template slot-scope="scope">
                <el-tag
                  v-if="scope.row.shopType === '旗舰'"
                  type="warning"
                  size="mini"
                >
                  旗舰
                </el-tag>
                <el-tag
                  v-else-if="scope.row.shopType === '第三方'"
                  type="info"
                  size="mini"
                >
                  第三方
                </el-tag>
                <el-tag
                  v-else-if="scope.row.shopType === '自营'"
                  type="success"
                  size="mini"
                >
                  自营
                </el-tag>
                <span v-else>-</span>
              </template>
            </el-table-column>
            <el-table-column
              prop="shopName"
              label="店铺名称"
              min-width="100"
              align="center"
            >
              <template slot-scope="scope">
                <span style="font-weight: 500">{{ scope.row.shopName }}</span>
              </template>
            </el-table-column>
          </el-table>
          <div
            v-if="hotBooks.length === 0 && !loadingBooks"
            style="text-align: center; padding: 40px; color: #999"
          >
            暂无图书数据
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="24">
        <el-card>
          <div slot="header">
            <span>🏪 热门店铺 TOP 5</span>
          </div>
          <el-row :gutter="20" v-loading="loadingMerchants">
            <el-col
              :span="4.8"
              v-for="(merchant, index) in hotMerchants"
              :key="merchant.id"
            >
              <el-card class="merchant-card" shadow="hover">
                <div class="merchant-rank" :class="'rank-' + (index + 1)">
                  {{ index + 1 }}
                </div>
                <div class="merchant-info">
                  <el-avatar
                    :size="60"
                    :src="getImageUrl(merchant.avatar)"
                    class="merchant-avatar"
                  >
                    {{ merchant.shopName ? merchant.shopName.charAt(0) : "店" }}
                  </el-avatar>
                  <el-tag
                    v-if="merchant.shopType === '旗舰'"
                    type="warning"
                    size="mini"
                    style="margin: 10px 0"
                  >
                    旗舰
                  </el-tag>
                  <el-tag
                    v-else-if="merchant.shopType === '第三方'"
                    type="info"
                    size="mini"
                    style="margin: 10px 0"
                  >
                    第三方
                  </el-tag>
                  <el-tag
                    v-else-if="merchant.shopType === '自营'"
                    type="success"
                    size="mini"
                    style="margin: 10px 0"
                  >
                    自营
                  </el-tag>
                  <h4 class="merchant-name">{{ merchant.shopName }}</h4>
                  <div class="merchant-stats">
                    <div class="stat-item">
                      <span class="stat-label">总销量</span>
                      <span class="stat-value">{{ merchant.totalSales }}</span>
                    </div>
                    <div class="stat-item">
                      <span class="stat-label">图书数</span>
                      <span class="stat-value">{{ merchant.bookCount }}</span>
                    </div>
                  </div>
                </div>
              </el-card>
            </el-col>
          </el-row>
          <div
            v-if="hotMerchants.length === 0 && !loadingMerchants"
            style="text-align: center; padding: 40px; color: #999"
          >
            暂无店铺数据
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="24">
        <el-card>
          <div slot="header">
            <span>📢 系统公告</span>
          </div>
          <el-table
            :data="currentNotices"
            style="width: 100%"
            v-loading="loadingNotices"
            stripe
            @row-click="handleNoticeClick"
          >
            <el-table-column prop="publishTime" label="发布时间" width="180">
              <template slot-scope="scope">
                <i class="el-icon-time" style="margin-right: 4px"></i>
                {{ formatTime(scope.row.publishTime) }}
              </template>
            </el-table-column>
            <el-table-column
              prop="title"
              label="公告标题"
              min-width="300"
            ></el-table-column>
            <el-table-column prop="content" label="内容摘要" min-width="400">
              <template slot-scope="scope">
                <span style="color: #666">{{
                  stripHtml(scope.row.content)
                }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="100" align="center">
              <template slot-scope="scope">
                <el-button
                  type="text"
                  size="small"
                  @click.stop="showNoticeDetail(scope.row)"
                >
                  查看详情
                </el-button>
              </template>
            </el-table-column>
          </el-table>
          <el-pagination
            v-if="notices.length > 0"
            @current-change="handleNoticePageChange"
            :current-page="noticePage"
            :page-size="noticePageSize"
            layout="total, prev, pager, next"
            :total="notices.length"
            style="margin-top: 20px; text-align: right"
          >
          </el-pagination>
          <div
            v-if="notices.length === 0 && !loadingNotices"
            style="text-align: center; padding: 40px; color: #999"
          >
            暂无公告信息
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-dialog
      :title="currentNotice ? currentNotice.title : ''"
      :visible.sync="dialogVisible"
      width="60%"
      top="10vh"
    >
      <div v-if="currentNotice" class="notice-detail">
        <div class="detail-meta">
          <el-tag
            :type="getNoticeTagType(currentNotice.noticeType)"
            size="medium"
          >
            {{ getNoticeTypeName(currentNotice.noticeType) }}
          </el-tag>
          <span class="detail-time">
            <i class="el-icon-time"></i>
            {{ formatTime(currentNotice.publishTime) }}
          </span>
        </div>
        <div class="detail-content" v-html="currentNotice.content"></div>
      </div>
      <div slot="footer">
        <el-button @click="dialogVisible = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  getStatisticsOverview,
  getHotBooks,
  getNoticeList,
  getHotMerchants,
} from "@/api/statistics";

export default {
  name: "Home",
  data() {
    return {
      statistics: {
        adminCount: 0,
        userCount: 0,
        merchantCount: 0,
        bookCount: 0,
        orderCount: 0,
        todayOrderCount: 0,
      },
      hotBooks: [],
      hotMerchants: [],
      notices: [],
      noticePage: 1,
      noticePageSize: 5,
      loadingBooks: false,
      loadingMerchants: false,
      loadingNotices: false,
      dialogVisible: false,
      currentNotice: null,
    };
  },
  computed: {
    currentNotices() {
      const start = (this.noticePage - 1) * this.noticePageSize;
      const end = start + this.noticePageSize;
      return this.notices.slice(start, end);
    },
  },
  mounted() {
    this.loadStatistics();
    this.loadHotBooks();
    this.loadHotMerchants();
    this.loadNotices();
  },
  methods: {
    async loadStatistics() {
      try {
        const res = await getStatisticsOverview();
        if (res.code === 200) {
          this.statistics = res.data;
        }
      } catch (error) {}
    },
    async loadHotBooks() {
      this.loadingBooks = true;
      try {
        const res = await getHotBooks(5);
        if (res.code === 200) {
          this.hotBooks = res.data || [];
        }
      } catch (error) {
      } finally {
        this.loadingBooks = false;
      }
    },
    async loadHotMerchants() {
      this.loadingMerchants = true;
      try {
        const res = await getHotMerchants(5);
        if (res.code === 200) {
          this.hotMerchants = res.data || [];
        }
      } catch (error) {
      } finally {
        this.loadingMerchants = false;
      }
    },
    async loadNotices() {
      this.loadingNotices = true;
      try {
        const res = await getNoticeList();
        if (res.code === 200) {
          this.notices = res.data.filter((n) => n.status === 1);
        }
      } catch (error) {
      } finally {
        this.loadingNotices = false;
      }
    },
    formatTime(time) {
      if (!time) return "";
      const date = new Date(time);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hours = String(date.getHours()).padStart(2, "0");
      const minutes = String(date.getMinutes()).padStart(2, "0");
      return `${year}-${month}-${day} ${hours}:${minutes}`;
    },
    stripHtml(html) {
      if (!html) return "暂无内容";
      const div = document.createElement("div");
      div.innerHTML = html;
      const text = div.textContent || div.innerText || "";
      return text.length > 80
        ? text.substring(0, 80) + "..."
        : text || "暂无内容";
    },
    getNoticeTypeName(type) {
      if (!type || type === "") return "系统消息";
      const typeMap = {
        promotion: "促销活动",
        activity: "精彩活动",
        news: "行业资讯",
        notice: "通知公告",
        system: "系统消息",
      };
      return typeMap[type] || "系统消息";
    },
    getNoticeTagType(type) {
      if (!type || type === "") return "info";
      const typeMap = {
        promotion: "danger",
        activity: "success",
        news: "primary",
        notice: "warning",
        system: "info",
      };
      return typeMap[type] || "info";
    },
    getImageUrl(path) {
      if (!path) return "";
      if (path.startsWith("http")) return path;
      return "http://localhost:8080" + path;
    },
    showNoticeDetail(notice) {
      this.currentNotice = notice;
      this.dialogVisible = true;
    },
    handleNoticeClick(row) {
      this.showNoticeDetail(row);
    },
    handleNoticePageChange(page) {
      this.noticePage = page;
    },
  },
};
</script>

<style scoped>
.home-container {
  padding: 0;
}

.stat-card {
  display: flex;
  align-items: center;
  padding: 15px;
  transition: all 0.3s;
  cursor: pointer;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stat-icon i {
  font-size: 28px;
  color: #fff;
}

.stat-info {
  flex: 1;
}

.stat-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
  font-weight: 500;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #303133;
}

.merchant-card {
  text-align: center;
  transition: all 0.3s;
  position: relative;
  overflow: hidden;
}

.merchant-card:hover {
  transform: translateY(-5px);
}

.merchant-rank {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-weight: bold;
  font-size: 14px;
}

.merchant-rank.rank-1 {
  background: linear-gradient(135deg, #ffd700 0%, #ffb347 100%);
  box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
}

.merchant-rank.rank-2 {
  background: linear-gradient(135deg, #c0c0c0 0%, #a0a0a0 100%);
  box-shadow: 0 2px 8px rgba(192, 192, 192, 0.4);
}

.merchant-rank.rank-3 {
  background: linear-gradient(135deg, #cd7f32 0%, #b87333 100%);
  box-shadow: 0 2px 8px rgba(205, 127, 50, 0.4);
}

.merchant-rank.rank-4,
.merchant-rank.rank-5 {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.4);
}

.book-rank {
  display: inline-block;
  width: 32px;
  height: 32px;
  line-height: 32px;
  border-radius: 50%;
  font-weight: bold;
  font-size: 14px;
  color: #fff;
}

.book-rank.rank-1 {
  background: linear-gradient(135deg, #ffd700 0%, #ffb347 100%);
  box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
}

.book-rank.rank-2 {
  background: linear-gradient(135deg, #c0c0c0 0%, #a0a0a0 100%);
  box-shadow: 0 2px 8px rgba(192, 192, 192, 0.4);
}

.book-rank.rank-3 {
  background: linear-gradient(135deg, #cd7f32 0%, #b87333 100%);
  box-shadow: 0 2px 8px rgba(205, 127, 50, 0.4);
}

.book-rank.rank-4,
.book-rank.rank-5 {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.4);
}

.merchant-info {
  padding-top: 10px;
}

.merchant-avatar {
  margin: 0 auto 15px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  font-size: 24px;
  font-weight: bold;
}

.merchant-name {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin: 10px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.merchant-stats {
  display: flex;
  justify-content: space-around;
  margin-top: 15px;
}

.stat-item {
  text-align: center;
}

.stat-label {
  display: block;
  font-size: 12px;
  color: #909399;
  margin-bottom: 4px;
}

.stat-value {
  font-size: 18px;
  font-weight: bold;
  color: #409eff;
}

.notice-detail {
  padding: 10px 0;
}

.detail-meta {
  display: flex;
  align-items: center;
  gap: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid #eee;
  margin-bottom: 20px;
}

.detail-time {
  font-size: 14px;
  color: #909399;
}

.detail-time i {
  margin-right: 4px;
}

.detail-content {
  font-size: 15px;
  line-height: 1.8;
  color: #555;
}

.detail-content p {
  margin: 12px 0;
}

.detail-content img {
  max-width: 100%;
  border-radius: 4px;
  margin: 10px 0;
}

.el-table {
  cursor: pointer;
}
</style>
