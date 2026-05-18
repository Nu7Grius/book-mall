<template>
  <div
    class="book-container"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-reading"></i>
            全平台图书监督
          </h2>
          <p class="header-subtitle">管理所有商家的图书审核</p>
        </div>
        <div class="header-right" v-if="pendingCount > 0">
          <el-badge :value="pendingCount" type="danger" class="pending-badge">
            <el-tag type="danger" size="medium">
              <i class="el-icon-warning"></i> 待审核
            </el-tag>
          </el-badge>
        </div>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="queryForm" class="query-form">
        <el-form-item label="书名" class="search-item">
          <el-input
            v-model="queryForm.bookName"
            placeholder="请输入书名"
            clearable
            prefix-icon="el-icon-search"
          ></el-input>
        </el-form-item>
        <el-form-item label="作者" class="search-item">
          <el-input
            v-model="queryForm.author"
            placeholder="请输入作者"
            clearable
            prefix-icon="el-icon-user"
          ></el-input>
        </el-form-item>
        <el-form-item label="商家" class="search-item">
          <el-select
            v-model="queryForm.merchantId"
            placeholder="请选择商家"
            clearable
            filterable
            style="width: 160px"
          >
            <el-option
              v-for="merchant in merchantList"
              :key="merchant.id"
              :label="merchant.shopName || merchant.username"
              :value="merchant.id"
            >
              <span>{{ merchant.shopName || merchant.username }}</span>
              <span style="color: #999; font-size: 12px; margin-left: 8px"
                >@{{ merchant.username }}</span
              >
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="审核状态" class="search-item">
          <el-select
            v-model="queryForm.auditStatus"
            placeholder="请选择审核状态"
            clearable
            style="width: 140px"
          >
            <el-option label="待审核" :value="0"></el-option>
            <el-option label="审核通过" :value="1"></el-option>
            <el-option label="审核拒绝" :value="2"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="状态" class="search-item">
          <el-select
            v-model="queryForm.status"
            placeholder="请选择状态"
            clearable
            style="width: 120px"
          >
            <el-option label="上架" :value="1"></el-option>
            <el-option label="下架" :value="0"></el-option>
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
      <!-- 批量操作工具栏 -->
      <div class="batch-actions" v-if="selectedBooks.length > 0">
        <el-alert
          :title="'已选择 ' + selectedBooks.length + ' 项'"
          type="info"
          :closable="false"
          show-icon
        >
        </el-alert>
        <div class="batch-buttons">
          <el-button type="primary" size="small" @click="showBatchAuditDialog">
            <i class="el-icon-check"></i> 批量审核
          </el-button>
          <el-button type="warning" size="small" @click="handleBatchOffline">
            <i class="el-icon-bottom"></i> 批量下架
          </el-button>
          <el-button type="danger" size="small" @click="handleBatchDelete">
            <i class="el-icon-delete"></i> 批量删除
          </el-button>
          <el-button size="small" @click="clearSelection">
            <i class="el-icon-close"></i> 取消选择
          </el-button>
        </div>
      </div>

      <el-table
        :data="bookList"
        border
        stripe
        v-loading="loading"
        @selection-change="handleSelectionChange"
      >
        <el-table-column
          type="selection"
          width="55"
          align="center"
        ></el-table-column>
        <el-table-column
          type="index"
          label="序号"
          width="70"
          align="center"
          :index="getRowIndex"
        ></el-table-column>
        <el-table-column label="封面" width="80" align="center">
          <template slot-scope="scope">
            <div style="text-align: center">
              <img
                v-if="scope.row.coverImage"
                :src="getImageUrl(scope.row.coverImage)"
                style="width: 50px; height: 65px; object-fit: cover"
              />
              <span v-else style="color: #999; font-size: 12px">无图</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column
          prop="bookName"
          label="书名"
          min-width="150"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column
          prop="author"
          label="作者"
          width="120"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column
          prop="publisher"
          label="出版社"
          width="140"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column prop="merchantName" label="商家" width="120">
          <template slot-scope="scope">
            <el-tooltip
              v-if="scope.row.shopName"
              :content="scope.row.shopName"
              placement="top"
            >
              <span>{{ scope.row.shopName }}</span>
            </el-tooltip>
            <span v-else-if="scope.row.merchantName">{{
              scope.row.merchantName
            }}</span>
            <span v-else style="color: #999">平台</span>
          </template>
        </el-table-column>
        <el-table-column prop="price" label="价格" width="80" align="right">
          <template slot-scope="scope">
            <span style="color: #f56c6c; font-weight: 500"
              >¥{{ scope.row.price }}</span
            >
          </template>
        </el-table-column>
        <el-table-column
          prop="stock"
          label="库存"
          width="70"
          align="center"
        ></el-table-column>
        <el-table-column
          prop="sales"
          label="销量"
          width="70"
          align="center"
        ></el-table-column>
        <el-table-column
          prop="auditStatus"
          label="审核"
          width="90"
          align="center"
        >
          <template slot-scope="scope">
            <el-tag
              v-if="scope.row.auditStatus === 0"
              type="warning"
              size="small"
              >待审</el-tag
            >
            <el-tag
              v-else-if="scope.row.auditStatus === 1"
              type="success"
              size="small"
              >通过</el-tag
            >
            <el-tag
              v-else-if="scope.row.auditStatus === 2"
              type="danger"
              size="small"
              >拒绝</el-tag
            >
            <el-tag v-else size="small" type="info">未设</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="70" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === 1" type="success" size="small"
              >上架</el-tag
            >
            <el-tag v-else type="info" size="small">下架</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="240" fixed="right" align="center">
          <template slot-scope="scope">
            <el-button
              v-if="scope.row.auditStatus === 0"
              type="primary"
              size="mini"
              @click="handleAudit(scope.row)"
            >
              审核
            </el-button>
            <el-button
              v-if="scope.row.status === 1"
              type="warning"
              size="mini"
              @click="handleForceOffline(scope.row)"
            >
              下架
            </el-button>
            <el-button
              v-if="scope.row.status === 0 && scope.row.auditStatus === 1"
              type="success"
              size="mini"
              @click="handleReOnline(scope.row)"
            >
              重新上架
            </el-button>
            <el-button
              type="danger"
              size="mini"
              @click="handleDelete(scope.row)"
            >
              删除
            </el-button>
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

    <!-- 审核弹窗 -->
    <el-dialog
      title="图书审核"
      :visible.sync="auditDialogVisible"
      width="600px"
    >
      <el-form :model="auditForm" label-width="100px">
        <el-form-item label="图书名称">
          <span>{{ auditForm.bookName }}</span>
        </el-form-item>
        <el-form-item label="审核状态">
          <el-radio-group v-model="auditForm.auditStatus">
            <el-radio :label="1">审核通过</el-radio>
            <el-radio :label="2">审核拒绝</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核备注">
          <el-input
            type="textarea"
            v-model="auditForm.auditRemark"
            placeholder="请输入审核备注（拒绝时必填）"
            :rows="4"
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="auditDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitAudit">确认审核</el-button>
      </div>
    </el-dialog>

    <!-- 批量审核对话框 -->
    <el-dialog
      title="批量审核图书"
      :visible.sync="batchAuditDialogVisible"
      width="600px"
    >
      <el-form :model="batchAuditForm" label-width="100px">
        <el-form-item label="已选择">
          <span style="color: #409eff; font-weight: bold"
            >{{ selectedBooks.length }} 本图书</span
          >
        </el-form-item>
        <el-form-item label="审核状态">
          <el-radio-group v-model="batchAuditForm.auditStatus">
            <el-radio :label="1">审核通过</el-radio>
            <el-radio :label="2">审核拒绝</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核备注">
          <el-input
            type="textarea"
            v-model="batchAuditForm.auditRemark"
            placeholder="请输入审核备注（拒绝时必填）"
            :rows="4"
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="batchAuditDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleBatchAudit">确认审核</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getBookPage, deleteBook } from "@/api/book";
import request from "@/api/request";

export default {
  name: "BookList",
  data() {
    return {
      bookList: [],
      loading: false,
      merchantList: [],
      pendingCount: 0,
      queryForm: {
        bookName: "",
        author: "",
        publisher: "",
        status: null,
        auditStatus: null,
        merchantId: null,
      },
      pagination: {
        page: 1,
        pageSize: 10,
        total: 0,
      },
      auditDialogVisible: false,
      auditForm: {
        id: null,
        bookName: "",
        auditStatus: 1,
        auditRemark: "",
      },
      selectedBooks: [],
      batchAuditDialogVisible: false,
      batchAuditForm: {
        auditStatus: 1,
        auditRemark: "",
      },
    };
  },
  mounted() {
    this.loadBookList();
    this.loadMerchants();
    this.loadPendingCount();
  },
  watch: {
    "queryForm.bookName"() {
      this.pagination.page = 1;
      this.loadBookList();
    },
    "queryForm.author"() {
      this.pagination.page = 1;
      this.loadBookList();
    },
    "queryForm.publisher"() {
      this.pagination.page = 1;
      this.loadBookList();
    },
    "queryForm.status"() {
      this.pagination.page = 1;
      this.loadBookList();
    },
    "queryForm.auditStatus"() {
      this.pagination.page = 1;
      this.loadBookList();
    },
    "queryForm.merchantId"() {
      this.pagination.page = 1;
      this.loadBookList();
    },
  },
  methods: {
    getRowIndex(index) {
      return (this.pagination.page - 1) * this.pagination.pageSize + index + 1;
    },
    loadBookList() {
      this.loading = true;
      const params = {
        page: this.pagination.page,
        pageSize: this.pagination.pageSize,
      };
      if (this.queryForm.bookName) {
        params.bookName = this.queryForm.bookName;
      }
      if (this.queryForm.author) {
        params.author = this.queryForm.author;
      }
      if (this.queryForm.publisher) {
        params.publisher = this.queryForm.publisher;
      }
      if (this.queryForm.status !== null && this.queryForm.status !== "") {
        params.status = this.queryForm.status;
      }
      if (
        this.queryForm.auditStatus !== null &&
        this.queryForm.auditStatus !== ""
      ) {
        params.auditStatus = this.queryForm.auditStatus;
      }
      if (
        this.queryForm.merchantId !== null &&
        this.queryForm.merchantId !== ""
      ) {
        params.merchantId = this.queryForm.merchantId;
      }

      getBookPage(params)
        .then((res) => {
          if (res.code === 200) {
            this.bookList = res.data.records || [];
            this.pagination.total = res.data.total || 0;
          }
        })
        .finally(() => {
          this.loading = false;
        });
    },
    loadMerchants() {
      request
        .get("/user/list", { params: { role: "merchant" } })
        .then((res) => {
          if (res.code === 200) {
            this.merchantList = res.data || [];
          }
        });
    },
    loadPendingCount() {
      request.get("/book/pending-count").then((res) => {
        if (res.code === 200) {
          this.pendingCount = res.data || 0;
        }
      });
    },
    handleQuery() {
      this.pagination.page = 1;
      this.loadBookList();
    },
    handleReset() {
      this.queryForm = {
        bookName: "",
        author: "",
        publisher: "",
        status: null,
        auditStatus: null,
        merchantId: null,
      };
      this.pagination.page = 1;
      this.loadBookList();
    },
    handleSizeChange(size) {
      this.pagination.pageSize = size;
      this.pagination.page = 1;
      this.loadBookList();
    },
    handleCurrentChange(page) {
      this.pagination.page = page;
      this.loadBookList();
    },
    handleAudit(row) {
      this.auditForm = {
        id: row.id,
        bookName: row.bookName,
        auditStatus: 1,
        auditRemark: "",
      };
      this.auditDialogVisible = true;
    },
    submitAudit() {
      if (this.auditForm.auditStatus === 2 && !this.auditForm.auditRemark) {
        this.$message.warning("请填写拒绝原因");
        return;
      }

      request
        .put("/book/audit", this.auditForm)
        .then((res) => {
          if (res.code === 200) {
            this.$message.success("审核成功");
            this.auditDialogVisible = false;
            this.loadBookList();
            this.loadPendingCount();
          } else {
            this.$message.error(res.message || "审核失败");
          }
        })
        .catch(() => {
          this.$message.error("审核失败");
        });
    },
    handleForceOffline(row) {
      this.$confirm("确定要强制下架该图书吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          request
            .put(`/book/force-offline/${row.id}`)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("强制下架成功");
                this.loadBookList();
              } else {
                this.$message.error(res.message || "强制下架失败");
              }
            })
            .catch(() => {
              this.$message.error("强制下架失败");
            });
        })
        .catch(() => {
          // 用户点击取消，不做任何操作
        });
    },
    handleReOnline(row) {
      this.$confirm(`确定要重新上架"${row.bookName}"吗？`, "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "success",
      })
        .then(() => {
          request
            .put(`/book/re-online/${row.id}`)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("重新上架成功");
                this.loadBookList();
              } else {
                this.$message.error(res.message || "重新上架失败");
              }
            })
            .catch(() => {
              this.$message.error("重新上架失败");
            });
        })
        .catch(() => {});
    },
    handleDelete(row) {
      this.$confirm("确定要删除该图书吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          deleteBook(row.id)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("删除成功");
                this.loadBookList();
              } else {
                this.$message.error(res.message || "删除失败");
              }
            })
            .catch(() => {
              this.$message.error("删除失败");
            });
        })
        .catch(() => {
          // 用户点击取消，不做任何操作
        });
    },
    handleSelectionChange(selection) {
      this.selectedBooks = selection;
    },
    clearSelection() {
      this.selectedBooks = [];
    },
    showBatchAuditDialog() {
      if (this.selectedBooks.length === 0) {
        this.$message.warning("请先选择要审核的图书");
        return;
      }
      this.batchAuditForm = {
        auditStatus: 1,
        auditRemark: "",
      };
      this.batchAuditDialogVisible = true;
    },
    handleBatchAudit() {
      if (this.selectedBooks.length === 0) {
        this.$message.warning("请先选择要审核的图书");
        return;
      }
      const ids = this.selectedBooks.map((book) => book.id);
      request
        .put("/book/batch-audit", {
          ids: ids,
          auditStatus: this.batchAuditForm.auditStatus,
          auditRemark: this.batchAuditForm.auditRemark,
        })
        .then((res) => {
          if (res.code === 200) {
            this.$message.success(res.data || "批量审核成功");
            this.batchAuditDialogVisible = false;
            this.selectedBooks = [];
            this.loadBookList();
            this.loadPendingCount();
          } else {
            this.$message.error(res.message || "批量审核失败");
          }
        })
        .catch(() => {
          this.$message.error("批量审核失败");
        });
    },
    handleBatchOffline() {
      if (this.selectedBooks.length === 0) {
        this.$message.warning("请先选择要下架的图书");
        return;
      }
      this.$confirm(
        `确定要下架选中的 ${this.selectedBooks.length} 本图书吗？`,
        "提示",
        {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        }
      )
        .then(() => {
          const ids = this.selectedBooks.map((book) => book.id);
          request
            .put("/book/batch-offline", { ids: ids })
            .then((res) => {
              if (res.code === 200) {
                this.$message.success(res.data || "批量下架成功");
                this.selectedBooks = [];
                this.loadBookList();
              } else {
                this.$message.error(res.message || "批量下架失败");
              }
            })
            .catch(() => {
              this.$message.error("批量下架失败");
            });
        })
        .catch(() => {});
    },
    handleBatchDelete() {
      if (this.selectedBooks.length === 0) {
        this.$message.warning("请先选择要删除的图书");
        return;
      }
      this.$confirm(
        `确定要删除选中的 ${this.selectedBooks.length} 本图书吗？此操作不可恢复！`,
        "警告",
        {
          confirmButtonText: "确定删除",
          cancelButtonText: "取消",
          type: "error",
        }
      )
        .then(() => {
          const ids = this.selectedBooks.map((book) => book.id);
          request
            .delete("/book/batch-delete", { data: { ids: ids } })
            .then((res) => {
              if (res.code === 200) {
                this.$message.success(res.data || "批量删除成功");
                this.selectedBooks = [];
                this.loadBookList();
              } else {
                this.$message.error(res.message || "批量删除失败");
              }
            })
            .catch(() => {
              this.$message.error("批量删除失败");
            });
        })
        .catch(() => {});
    },
    getImageUrl(path) {
      if (!path) return "";
      if (path.startsWith("http")) return path;
      if (path.startsWith("data:")) return path;
      return "http://localhost:8080" + path;
    },
  },
};
</script>

<style scoped>
.book-container {
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

.pending-badge {
  margin-left: 15px;
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

.batch-actions {
  margin-bottom: 20px;
  padding: 15px;
  background: #f0f9eb;
  border-radius: 8px;
  border: 1px solid #e1f3d8;
}

.batch-buttons {
  margin-top: 10px;
  display: flex;
  gap: 10px;
}
</style>
