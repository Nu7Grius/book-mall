<template>
  <div
    class="comment-management"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-chat-line-round"></i>
            评论管理
          </h2>
          <p class="header-subtitle">管理用户评价和回复</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-value">{{ pagination.total }}</span>
            <span class="stat-label">总评论</span>
          </div>
        </div>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="图书名称" class="search-item">
          <el-input
            v-model="searchForm.bookName"
            placeholder="请输入图书名称"
            clearable
            prefix-icon="el-icon-search"
          ></el-input>
        </el-form-item>
        <el-form-item label="评价状态" class="search-item">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="待审核" value="pending"></el-option>
            <el-option label="已通过" value="approved"></el-option>
            <el-option label="已拒绝" value="rejected"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围" class="search-item">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
          >
          </el-date-picker>
        </el-form-item>
        <el-form-item class="search-actions">
          <el-button
            type="primary"
            @click="searchComments"
            icon="el-icon-search"
          >
            搜索
          </el-button>
          <el-button @click="resetSearch" icon="el-icon-refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="commentList" border stripe>
        <el-table-column
          type="index"
          label="序号"
          width="70"
          align="center"
          :index="getRowIndex"
        />
        <el-table-column label="图书信息" min-width="220">
          <template slot-scope="scope">
            <div class="book-info">
              <el-image
                :src="getImageUrl(scope.row.bookCover)"
                fit="cover"
                style="
                  width: 60px;
                  height: 80px;
                  border-radius: 4px;
                  flex-shrink: 0;
                "
                :preview-src-list="[getImageUrl(scope.row.bookCover)]"
                class="book-cover"
              >
                <div slot="error" class="image-error">
                  <i class="el-icon-picture-outline"></i>
                </div>
                <div slot="placeholder" class="image-placeholder">
                  <i class="el-icon-loading"></i>
                </div>
              </el-image>
              <div class="book-detail">
                <div class="book-name" :title="scope.row.bookName">
                  {{ scope.row.bookName }}
                </div>
                <div class="book-author">{{ scope.row.bookAuthor }}</div>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="用户" width="120" align="center">
          <template slot-scope="scope">
            <div class="user-name">
              <i class="el-icon-user"></i>
              {{ scope.row.userName }}
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="rating" label="评分" width="150" align="center">
          <template slot-scope="scope">
            <el-rate v-model="scope.row.rating" disabled text-color="#ff9900" />
          </template>
        </el-table-column>
        <el-table-column prop="content" label="评论内容" min-width="220">
          <template slot-scope="scope">
            <div class="comment-content" v-html="scope.row.content"></div>
          </template>
        </el-table-column>
        <el-table-column
          prop="createTime"
          label="评论时间"
          width="110"
          align="center"
        />
        <el-table-column label="状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)" size="small">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right" align="center">
          <template slot-scope="scope">
            <div class="action-buttons">
              <el-button
                size="mini"
                type="primary"
                @click="viewDetail(scope.row)"
                icon="el-icon-view"
              >
                详情
              </el-button>
              <el-dropdown
                v-if="scope.row.status === 0"
                @command="(command) => handleCommand(command, scope.row)"
                trigger="click"
              >
                <el-button size="mini" type="warning">
                  审核 <i class="el-icon-arrow-down el-icon--right"></i>
                </el-button>
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item command="approve">
                    <i class="el-icon-check" style="color: #67c23a"></i> 通过
                  </el-dropdown-item>
                  <el-dropdown-item command="reject">
                    <i class="el-icon-close" style="color: #f56c6c"></i> 拒绝
                  </el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
              <el-button
                v-else
                size="mini"
                type="info"
                @click="handleReply(scope.row)"
                icon="el-icon-chat-dot-round"
              >
                回复
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrapper">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pagination.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="pagination.size"
          layout="total, sizes, prev, pager, next, jumper"
          :total="pagination.total"
        />
      </div>
    </el-card>

    <el-dialog
      title="💬 评论详情"
      :visible.sync="detailDialogVisible"
      width="600px"
      class="detail-dialog"
    >
      <div v-if="currentComment" class="comment-detail">
        <div class="detail-header">
          <div class="comment-header-display">
            <div class="header-icon">
              <i class="el-icon-chat-line-round"></i>
            </div>
            <div class="header-info">
              <div class="header-book-name">{{ currentComment.bookName }}</div>
              <div class="header-book-author">
                {{ currentComment.bookAuthor }}
              </div>
            </div>
            <el-avatar
              :src="currentComment.bookCover"
              :size="60"
              shape="square"
              class="header-cover"
            />
          </div>
        </div>
        <el-divider />
        <div class="detail-content">
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-user"></i> 用户：</span
            >
            <span class="detail-value">{{ currentComment.userName }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-star-on"></i> 评分：</span
            >
            <el-rate v-model="currentComment.rating" disabled />
          </div>
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-time"></i> 时间：</span
            >
            <span class="detail-value">{{ currentComment.createTime }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-chat-line-round"></i> 内容：</span
            >
            <div
              class="detail-comment-content"
              v-html="currentComment.content"
            ></div>
          </div>
          <div v-if="currentComment.replyContent" class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-chat-dot-round"></i> 商家回复：</span
            >
            <div
              class="detail-reply-content"
              v-html="currentComment.replyContent"
            ></div>
          </div>
        </div>
      </div>
      <div slot="footer">
        <el-button @click="detailDialogVisible = false" size="medium"
          >关 闭</el-button
        >
      </div>
    </el-dialog>

    <el-dialog
      title="回复评论"
      :visible.sync="replyDialogVisible"
      width="800px"
      @close="handleDialogClose"
      class="reply-dialog"
    >
      <el-form ref="replyForm" :model="replyForm" label-width="100px">
        <el-form-item label="回复内容">
          <div ref="replyEditor" class="editor-container"></div>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="replyDialogVisible = false" size="medium"
          >取 消</el-button
        >
        <el-button type="primary" @click="submitReply" size="medium">
          <i class="el-icon-s-promotion"></i> 发 送
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import E from "wangeditor";
import { getImageUrl } from "@/utils/img";

export default {
  name: "MerchantComment",
  data() {
    return {
      loading: false,
      refreshInterval: null,
      lastUpdateTime: null,
      replyEditor: null,
      searchForm: {
        bookName: "",
        userName: "",
        rating: "",
      },
      commentList: [],
      pagination: {
        page: 1,
        size: 10,
        total: 0,
      },
      detailDialogVisible: false,
      currentComment: null,
      replyDialogVisible: false,
      replyForm: {
        content: "",
      },
    };
  },
  mounted() {
    this.loadComments();
    window.addEventListener("comment-updated", this.handleCommentUpdated);
  },
  beforeDestroy() {
    window.removeEventListener("comment-updated", this.handleCommentUpdated);

    if (this.replyEditor) {
      this.replyEditor.destroy();
      this.replyEditor = null;
    }
  },
  watch: {
    "searchForm.bookName"() {
      this.pagination.page = 1;
      this.loadComments();
    },
    "searchForm.status"() {
      this.pagination.page = 1;
      this.loadComments();
    },
  },
  methods: {
    getStatusType(status) {
      const typeMap = {
        1: "success",
        0: "warning",
        2: "danger",
      };
      return typeMap[status] || "info";
    },
    getStatusText(status) {
      const textMap = {
        1: "已通过",
        0: "待审核",
        2: "已拒绝",
      };
      return textMap[status] || "未知";
    },
    handleCommentUpdated() {
      this.loadComments();
    },
    loadComments() {
      this.loading = true;
      const merchantInfo = JSON.parse(
        localStorage.getItem("merchantInfo") || "{}"
      );
      const merchantId = merchantInfo.id;

      const params = {
        page: this.pagination.page,
        pageSize: this.pagination.size,
        merchantId: merchantId,
      };

      if (this.searchForm.bookName) {
        params.bookName = this.searchForm.bookName;
      }
      if (this.searchForm.userName) {
        params.userName = this.searchForm.userName;
      }
      if (this.searchForm.rating) {
        params.rating = this.searchForm.rating;
      }
      if (this.searchForm.status) {
        if (this.searchForm.status === "pending") {
          params.status = 0;
        } else if (this.searchForm.status === "approved") {
          params.status = 1;
        } else if (this.searchForm.status === "rejected") {
          params.status = 2;
        }
      }

      this.$http
        .get("/comment/merchant/page", { params })
        .then((res) => {
          if (res.code === 200) {
            this.commentList = res.data.records || res.data.list || [];
            this.pagination.total = res.data.total || this.commentList.length;
          } else {
            this.$message.error(res.message || "加载评论失败");
          }
        })
        .catch(() => {
          this.$message.error("加载评论失败，请稍后重试");
        })
        .finally(() => {
          this.loading = false;
        });
    },
    searchComments() {
      this.pagination.page = 1;
      this.loadComments();
    },
    resetSearch() {
      this.searchForm = {
        bookName: "",
        userName: "",
        rating: "",
      };
      this.searchComments();
    },
    getRowIndex(index) {
      return (this.pagination.page - 1) * this.pagination.size + index + 1;
    },
    handleSizeChange(size) {
      this.pagination.size = size;
      this.loadComments();
    },
    handleCurrentChange(page) {
      this.pagination.page = page;
      this.loadComments();
    },
    handleApprove(row) {
      this.$confirm("确定要通过这条评论吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "success",
      })
        .then(() => {
          this.$http
            .put(`/comment/status/${row.id}`, { status: 1 })
            .then((res) => {
              if (res.code === 200) {
                row.status = 1;
                this.$message.success("评论已通过审核");
                window.dispatchEvent(new Event("comment-updated"));
              } else {
                this.$message.error(res.msg || "操作失败");
              }
            })
            .catch(() => {
              this.$message.error("操作失败，请稍后重试");
            });
        })
        .catch(() => {});
    },
    handleReject(row) {
      this.$confirm("确定要拒绝这条评论吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$http
            .put(`/comment/status/${row.id}`, { status: 2 })
            .then((res) => {
              if (res.code === 200) {
                row.status = 2;
                this.$message.success("评论已拒绝");
                window.dispatchEvent(new Event("comment-updated"));
              } else {
                this.$message.error(res.msg || "操作失败");
              }
            })
            .catch(() => {
              this.$message.error("操作失败，请稍后重试");
            });
        })
        .catch(() => {});
    },
    handleCommand(command, row) {
      if (command === "approve") {
        this.handleApprove(row);
      } else if (command === "reject") {
        this.handleReject(row);
      }
    },
    viewDetail(row) {
      this.currentComment = { ...row };
      this.detailDialogVisible = true;
    },
    handleReply(row) {
      this.currentComment = { ...row };
      this.replyForm.content = "";
      this.replyDialogVisible = true;
      this.$nextTick(() => {
        this.initReplyEditor();
      });
    },
    initReplyEditor() {
      if (!this.replyEditor) {
        this.replyEditor = new E(this.$refs.replyEditor);
        this.replyEditor.config.placeholder = "请输入回复内容...";
        this.replyEditor.config.height = 200;
        this.replyEditor.create();
      }
    },
    handleDialogClose() {
      if (this.replyEditor) {
        this.replyEditor.destroy();
        this.replyEditor = null;
      }
    },
    submitReply() {
      const content = this.replyEditor ? this.replyEditor.txt.html() : "";
      if (!content || content === "<p><br></p>") {
        this.$message.warning("请输入回复内容");
        return;
      }

      const merchantInfo = JSON.parse(
        localStorage.getItem("merchantInfo") || "{}"
      );

      this.$http
        .put(`/comment/reply/${this.currentComment.id}`, {
          replyContent: content,
          replyRole: "merchant",
          replyUserId: merchantInfo.id,
        })
        .then((res) => {
          if (res.code === 200) {
            const comment = this.commentList.find(
              (c) => c.id === this.currentComment.id
            );
            if (comment) {
              comment.replyContent = content;
              comment.replyTime = new Date();
              comment.replyRole = "merchant";
              comment.replyUserId = merchantInfo.id;
            }
            this.$message.success("回复成功");
            this.replyDialogVisible = false;
            window.dispatchEvent(new Event("comment-updated"));
          } else {
            this.$message.error(res.msg || "回复失败");
          }
        })
        .catch((error) => {
          this.$message.error("回复失败，请稍后重试");
        });
    },
  },
};
</script>

<style scoped>
.comment-management {
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

.header-stats {
  display: flex;
  gap: 30px;
}

.stat-item {
  text-align: center;
}

.stat-value {
  display: block;
  font-size: 28px;
  font-weight: bold;
}

.stat-label {
  display: block;
  font-size: 13px;
  opacity: 0.9;
}

.search-card {
  margin-bottom: 20px;
  border: none;
  border-radius: 12px;
}

.search-form {
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

.book-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.book-cover {
  flex-shrink: 0;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.book-cover:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
}

.image-error,
.image-placeholder {
  width: 60px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #c0c4cc;
  font-size: 20px;
  border-radius: 4px;
}

.book-detail {
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

.book-author {
  font-size: 12px;
  color: #909399;
}

.user-name {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 13px;
  color: #606266;
}

.user-name i {
  color: #409eff;
}

.comment-content {
  font-size: 13px;
  color: #606266;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.action-buttons {
  display: flex;
  gap: 8px;
  align-items: center;
}

.pagination-wrapper {
  margin-top: 20px;
  text-align: right;
}

.detail-dialog .comment-detail {
  padding: 10px;
}

.detail-header {
  margin-bottom: 15px;
}

.comment-header-display {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
  color: white;
}

.header-icon {
  width: 50px;
  height: 50px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
}

.header-info {
  flex: 1;
}

.header-book-name {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 5px;
  color: white;
}

.header-book-author {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.85);
}

.header-cover {
  flex-shrink: 0;
  border-radius: 6px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.detail-content {
  padding: 0 10px;
}

.detail-row {
  margin-bottom: 15px;
  display: flex;
  align-items: flex-start;
}

.detail-label {
  font-size: 13px;
  color: #909399;
  min-width: 80px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.detail-label i {
  color: #409eff;
}

.detail-value {
  font-size: 13px;
  color: #606266;
}

.detail-comment-content,
.detail-reply-content {
  flex: 1;
  font-size: 13px;
  color: #606266;
  line-height: 1.6;
  background: #f5f7fa;
  padding: 10px;
  border-radius: 6px;
}

.detail-reply-content {
  background: #ecf5ff;
  border-left: 3px solid #409eff;
}

.reply-dialog .editor-container {
  min-height: 200px;
  border: 1px solid #dcdfe6;
  border-radius: 6px;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .search-form {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
