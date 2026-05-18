<template>
  <div
    class="comment-container"
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
          <p class="header-subtitle">监督平台所有评论内容</p>
        </div>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="queryForm" class="query-form">
        <el-form-item label="图书名称" class="search-item">
          <el-input
            v-model="queryForm.bookName"
            placeholder="请输入图书名称"
            clearable
            prefix-icon="el-icon-search"
          ></el-input>
        </el-form-item>
        <el-form-item label="用户名称" class="search-item">
          <el-input
            v-model="queryForm.userName"
            placeholder="请输入用户名称"
            clearable
            prefix-icon="el-icon-user"
          ></el-input>
        </el-form-item>
        <el-form-item label="评分" class="search-item">
          <el-select
            v-model="queryForm.rating"
            placeholder="请选择评分"
            clearable
            style="width: 120px"
          >
            <el-option label="5星" :value="5"></el-option>
            <el-option label="4星" :value="4"></el-option>
            <el-option label="3星" :value="3"></el-option>
            <el-option label="2星" :value="2"></el-option>
            <el-option label="1星" :value="1"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item class="search-actions">
          <el-button type="primary" @click="handleQuery" icon="el-icon-search">
            查询
          </el-button>
          <el-button @click="handleReset" icon="el-icon-refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="commentList" border stripe v-loading="loading">
        <el-table-column
          type="index"
          label="序号"
          width="70"
          align="center"
          :index="getRowIndex"
        ></el-table-column>
        <el-table-column prop="bookName" label="图书名称" width="180">
          <template slot-scope="scope">
            <span class="book-name">{{
              scope.row.bookName || "未知图书"
            }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="userName" label="用户名称" width="120">
          <template slot-scope="scope">
            <span>{{
              scope.row.isAnonymous === 1
                ? "匿名用户"
                : scope.row.userName || "未知用户"
            }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="rating" label="评分" width="150">
          <template slot-scope="scope">
            <el-rate v-model="scope.row.rating" disabled size="small" />
          </template>
        </el-table-column>
        <el-table-column prop="content" label="评价内容" min-width="200">
          <template slot-scope="scope">
            <div class="comment-content" v-html="scope.row.content || ''"></div>
          </template>
        </el-table-column>
        <el-table-column prop="replyContent" label="回复内容" min-width="200">
          <template slot-scope="scope">
            <div v-if="scope.row.replyContent">
              <div class="reply-info">
                <el-tag type="success" size="mini">商家回复</el-tag>
              </div>
              <div
                class="reply-content"
                v-html="scope.row.replyContent || ''"
              ></div>
            </div>
            <span v-else class="no-reply">暂无回复</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="createTime"
          label="评价时间"
          width="160"
        ></el-table-column>
        <el-table-column label="操作" width="180" fixed="right" align="center">
          <template slot-scope="scope">
            <el-button size="mini" type="primary" @click="handleView(scope.row)"
              >查看</el-button
            >
            <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row.id)"
              >删除</el-button
            >
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
      title="💬 评论详情"
      :visible.sync="detailVisible"
      width="600px"
      class="detail-dialog"
    >
      <div v-if="currentComment" class="comment-detail">
        <div class="detail-header">
          <div class="book-info">
            <div class="book-name">{{ currentComment.bookName }}</div>
            <div class="book-author">
              {{ currentComment.bookAuthor || "未知作者" }}
            </div>
          </div>
        </div>

        <el-divider />

        <div class="detail-content">
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-user"></i> 用户：</span
            >
            <span class="detail-value">
              {{
                currentComment.isAnonymous === 1
                  ? "👤 匿名用户"
                  : currentComment.userName || "未知用户"
              }}
            </span>
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
        <el-button @click="detailVisible = false" size="medium"
          >关 闭</el-button
        >
      </div>
    </el-dialog>
  </div>
</template>

<script>
import request from "@/api/request";
import { Message } from "element-ui";

export default {
  name: "CommentList",
  data() {
    return {
      commentList: [],
      loading: false,
      refreshInterval: null,
      lastUpdateTime: null,
      queryForm: {
        bookName: "",
        userName: "",
        rating: null,
      },
      pagination: {
        page: 1,
        pageSize: 10,
        total: 0,
      },
      detailVisible: false,
      currentComment: null,
    };
  },
  mounted() {
    this.loadComments();
  },
  watch: {
    "queryForm.bookName"() {
      this.pagination.page = 1;
      this.loadComments();
    },
    "queryForm.userName"() {
      this.pagination.page = 1;
      this.loadComments();
    },
    "queryForm.rating"() {
      this.pagination.page = 1;
      this.loadComments();
    },
  },
  methods: {
    getRowIndex(index) {
      return (this.pagination.page - 1) * this.pagination.pageSize + index + 1;
    },
    async loadComments() {
      this.loading = true;
      try {
        const params = {
          page: this.pagination.page,
          pageSize: this.pagination.pageSize,
        };
        if (this.queryForm.bookName) {
          params.bookName = this.queryForm.bookName;
        }
        if (this.queryForm.userName) {
          params.userName = this.queryForm.userName;
        }
        if (this.queryForm.rating !== null && this.queryForm.rating !== "") {
          params.rating = this.queryForm.rating;
        }

        const res = await request.get("/comment/page", { params });
        if (res.code === 200) {
          this.commentList = res.data.records || [];
          this.pagination.total = res.data.total || 0;
        } else {
          Message.error(res.msg || "加载评论失败");
        }
      } catch (error) {
        Message.error("加载评论失败，请检查后端服务是否启动");
      } finally {
        this.loading = false;
      }
    },
    handleQuery() {
      this.pagination.page = 1;
      this.loadComments();
    },
    handleReset() {
      this.queryForm = {
        bookName: "",
        userName: "",
        rating: null,
      };
      this.pagination.page = 1;
      this.loadComments();
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val;
      this.loadComments();
    },
    handleCurrentChange(val) {
      this.pagination.page = val;
      this.loadComments();
    },
    handleDelete(id) {
      this.$confirm("确定要删除这条评价吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(async () => {
          try {
            const res = await request.delete(`/comment/${id}`);
            if (res.code === 200) {
              Message.success("删除成功");
              this.loadComments();
            } else {
              Message.error(res.msg || "删除失败");
            }
          } catch (error) {
            Message.error("删除失败");
          }
        })
        .catch(() => Promise.resolve());
    },
    handleView(row) {
      this.currentComment = row;
      this.detailVisible = true;
    },
  },
};
</script>

<style scoped>
.comment-container {
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

.book-name {
  color: #409eff;
}

.comment-content {
  max-height: 60px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.original-comment {
  padding: 12px;
  background: #f5f7fa;
  border-radius: 4px;
  color: #666;
  line-height: 1.6;
}

.reply-content {
  color: #67c23a;
  line-height: 1.6;
}

.no-reply {
  color: #999;
  font-style: italic;
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

.comment-detail {
  padding: 10px;
}

.detail-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
}

.book-info {
  flex: 1;
}

.book-info .book-name {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 5px;
}

.book-info .book-author {
  font-size: 13px;
  color: #909399;
}

.detail-content {
  padding: 0 10px;
}

.detail-row {
  margin-bottom: 20px;
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
  flex: 1;
}

.detail-comment-content,
.detail-reply-content {
  flex: 1;
  font-size: 13px;
  line-height: 1.8;
  padding: 12px;
  border-radius: 6px;
}

.detail-comment-content {
  background: #f5f7fa;
  color: #606266;
}

.detail-reply-content {
  background: #f0f9eb;
  color: #67c23a;
  border-left: 3px solid #67c23a;
}

.detail-comment-content ::v-deep p,
.detail-reply-content ::v-deep p {
  margin: 5px 0;
}
</style>
