<template>
  <div class="notice-list">
    <el-card>
      <div slot="header" class="card-header">
        <div class="header-left">
          <h2>📢 系统公告</h2>
          <el-tag type="info" size="medium">
            共 {{ noticeList.length }} 条公告
          </el-tag>
        </div>
      </div>

      <el-table
        v-if="noticeList.length > 0"
        :data="noticeList"
        style="width: 100%"
        :show-header="true"
        @row-click="handleRowClick"
        class="notice-table"
      >
        <el-table-column prop="publishTime" label="发布时间" width="180">
          <template slot-scope="scope">
            <i class="el-icon-time" style="margin-right: 6px"></i>
            {{ formatTime(scope.row.publishTime) }}
          </template>
        </el-table-column>

        <el-table-column prop="title" label="公告标题" min-width="300">
          <template slot-scope="scope">
            <div class="notice-title-cell">
              <span
                class="notice-badge"
                :class="getNoticeBadgeClass(scope.row.noticeType)"
              >
                {{ getNoticeTypeName(scope.row.noticeType) }}
              </span>
              <span class="notice-title">{{ scope.row.title }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="content" label="内容摘要" min-width="400">
          <template slot-scope="scope">
            <span class="notice-content-preview">
              {{ stripHtml(scope.row.content) }}
            </span>
          </template>
        </el-table-column>

        <el-table-column
          prop="viewCount"
          label="浏览量"
          width="100"
          align="center"
        >
          <template slot-scope="scope">
            <span class="view-count">
              <i class="el-icon-view"></i>
              {{ scope.row.viewCount || 0 }}
            </span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="100" align="center">
          <template slot-scope="scope">
            <el-button
              type="text"
              size="small"
              @click.stop="showDetail(scope.row)"
            >
              查看详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div v-else class="empty-state">
        <i class="el-icon-bell" style="font-size: 64px; color: #ddd"></i>
        <p style="color: #999; margin-top: 16px; font-size: 16px">
          暂无公告信息
        </p>
      </div>

      <el-pagination
        v-if="pagination.total > 0"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="pagination.page"
        :page-sizes="[5, 10, 20, 50]"
        :page-size="pagination.pageSize"
        :total="pagination.total"
        layout="total, sizes, prev, pager, next, jumper"
        style="margin-top: 20px; text-align: right"
      >
      </el-pagination>

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
            <span class="detail-views">
              <i class="el-icon-view"></i>
              {{ currentNotice.viewCount || 0 }} 次浏览
            </span>
          </div>

          <div class="detail-content">{{ stripHtml(currentNotice.content) }}</div>
        </div>
        <div slot="footer">
          <el-button @click="dialogVisible = false">关闭</el-button>
        </div>
      </el-dialog>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "UserNotice",
  data() {
    return {
      noticeList: [],
      dialogVisible: false,
      currentNotice: null,
      pagination: {
        page: 1,
        pageSize: 10,
        total: 0,
      },
    };
  },
  mounted() {
    this.loadNotices();
    window.addEventListener("storage", this.handleStorageChange);
  },
  beforeDestroy() {
    window.removeEventListener("storage", this.handleStorageChange);
  },
  methods: {
    handleStorageChange(e) {
      if (e.key === "notice-updated-trigger") {
        this.loadNotices();
      }
    },
    loadNotices() {
      this.$http
        .get("/notice/page", {
          params: {
            page: this.pagination.page,
            pageSize: this.pagination.pageSize,
            status: 1,
          },
        })
        .then((res) => {
          if (res.code === 200) {
            const data = res.data;
            if (data.records) {
              this.noticeList = data.records;
              this.pagination.total = data.total || 0;
            } else {
              this.noticeList = [];
              this.pagination.total = 0;
            }
          }
        });
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val;
      this.pagination.page = 1;
      this.loadNotices();
    },
    handleCurrentChange(val) {
      this.pagination.page = val;
      this.loadNotices();
    },
    getNoticeTypeName(type) {
      if (!type || type === "") {
        return "系统消息";
      }
      const typeMap = {
        promotion: "促销活动",
        activity: "精彩活动",
        news: "行业资讯",
        notice: "通知公告",
        system: "系统消息",
      };
      return typeMap[type] || "系统消息";
    },
    getNoticeBadgeClass(type) {
      if (!type || type === "") {
        return "info";
      }
      const typeMap = {
        promotion: "promotion",
        activity: "activity",
        news: "news",
        notice: "notice",
        system: "system",
      };
      return typeMap[type] || "info";
    },
    getNoticeTagType(type) {
      if (!type || type === "") {
        return "info";
      }
      const typeMap = {
        promotion: "danger",
        activity: "success",
        news: "primary",
        notice: "warning",
        system: "info",
      };
      return typeMap[type] || "info";
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
    handleRowClick(row) {
      this.showDetail(row);
    },
    showDetail(notice) {
      this.currentNotice = notice;
      this.dialogVisible = true;
    },
  },
};
</script>

<style scoped>
.notice-list {
  padding: 0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-left h2 {
  margin: 0;
  font-size: 20px;
  color: #333;
}

.empty-state {
  text-align: center;
  padding: 80px 0;
}

.notice-table {
  cursor: pointer;
}

.notice-table:hover {
  background-color: #f5f7fa;
}

.notice-title-cell {
  display: flex;
  align-items: center;
  gap: 10px;
}

.notice-badge {
  padding: 2px 8px;
  border-radius: 3px;
  font-size: 12px;
  font-weight: bold;
  color: #fff;
  white-space: nowrap;
}

.notice-badge.promotion {
  background: #ff6b6b;
}

.notice-badge.activity {
  background: #67c23a;
}

.notice-badge.news {
  background: #409eff;
}

.notice-badge.notice {
  background: #e6a23c;
}

.notice-badge.system {
  background: #909399;
}

.notice-badge.info,
span.notice-badge.info,
.notice-badge[class*="info"],
.notice-badge[style=""] {
  background-color: #909399 !important;
  background: #909399 !important;
}

.notice-title {
  font-weight: 500;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.notice-content-preview {
  font-size: 14px;
  color: #666;
  line-height: 1.5;
}

.view-count {
  color: #909399;
  font-size: 13px;
}

.view-count i {
  margin-right: 4px;
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

.detail-time,
.detail-views {
  font-size: 14px;
  color: #909399;
}

.detail-time i,
.detail-views i {
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
</style>
