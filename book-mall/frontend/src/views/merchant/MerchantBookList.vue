<template>
  <div class="book-list" v-loading="loading" element-loading-text="加载中...">
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-collection"></i>
            图书管理
          </h2>
          <p class="header-subtitle">管理您的图书库存和上下架</p>
        </div>
        <el-button
          type="primary"
          size="medium"
          @click="$router.push('/merchant/book-add')"
          class="add-btn"
        >
          <i class="el-icon-plus"></i> 添加图书
        </el-button>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="书名" class="search-item">
          <el-input
            v-model="searchForm.name"
            placeholder="请输入书名"
            clearable
            prefix-icon="el-icon-search"
          ></el-input>
        </el-form-item>
        <el-form-item label="一级分类" class="search-item">
          <el-select
            v-model="searchForm.firstCategoryId"
            placeholder="请选择一级分类"
            clearable
            @change="handleFirstCategoryChange"
          >
            <el-option
              v-for="cat in firstCategoryList"
              :key="cat.id"
              :label="cat.categoryName"
              :value="cat.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="二级分类" class="search-item">
          <el-select
            v-model="searchForm.secondCategoryId"
            placeholder="请选择二级分类"
            clearable
            :disabled="!searchForm.firstCategoryId"
          >
            <el-option
              v-for="cat in filteredSecondCategoryList"
              :key="cat.id"
              :label="cat.categoryName"
              :value="cat.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item class="search-actions">
          <el-button type="primary" @click="searchBooks" icon="el-icon-search">
            搜索
          </el-button>
          <el-button @click="resetSearch" icon="el-icon-refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="filteredBookList" border stripe>
        <el-table-column
          type="index"
          label="序号"
          width="70"
          align="center"
          :index="getRowIndex"
        />
        <el-table-column label="封面" width="100" align="center">
          <template slot-scope="scope">
            <div class="cover-image-wrapper">
              <el-image
                :src="getImageUrl(scope.row.coverImage)"
                fit="cover"
                style="width: 60px; height: 80px; border-radius: 4px"
                :preview-src-list="[getImageUrl(scope.row.coverImage)]"
              >
                <div slot="error" class="image-error">
                  <i class="el-icon-picture-outline"></i>
                </div>
                <div slot="placeholder" class="image-placeholder">
                  <i class="el-icon-loading"></i>
                </div>
              </el-image>
            </div>
          </template>
        </el-table-column>
        <el-table-column
          prop="bookName"
          label="书名"
          min-width="200"
          show-overflow-tooltip
        >
        </el-table-column>
        <el-table-column
          prop="author"
          label="作者"
          width="100"
          show-overflow-tooltip
          align="center"
        />
        <el-table-column
          prop="categoryName"
          label="分类"
          width="100"
          align="center"
        >
          <template slot-scope="scope">
            <el-tag size="small" type="info">{{
              scope.row.categoryName
            }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="price" label="价格" width="100" align="center">
          <template slot-scope="scope">
            <span class="price-text">¥{{ scope.row.price }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="90" align="center">
          <template slot-scope="scope">
            <el-tag
              :type="
                scope.row.stock > 10
                  ? 'success'
                  : scope.row.stock > 0
                  ? 'warning'
                  : 'danger'
              "
              size="small"
            >
              {{ scope.row.stock }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="sales" label="销量" width="90" align="center">
          <template slot-scope="scope">
            <span class="sales-text">{{ scope.row.sales || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="createTime"
          label="上架时间"
          width="110"
          align="center"
        />
        <el-table-column label="状态" width="90" align="center">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.status === 1 ? 'success' : 'info'"
              size="small"
            >
              {{ scope.row.status === 1 ? "上架" : "下架" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right" align="center">
          <template slot-scope="scope">
            <div class="action-buttons">
              <el-button
                size="mini"
                type="primary"
                @click="editBook(scope.row)"
                icon="el-icon-edit"
              >
                编辑
              </el-button>
              <el-dropdown
                @command="(command) => handleCommand(command, scope.row)"
                trigger="click"
              >
                <el-button size="mini" type="info">
                  更多 <i class="el-icon-arrow-down el-icon--right"></i>
                </el-button>
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item
                    :command="scope.row.status === 1 ? 'offline' : 'online'"
                  >
                    <i
                      :class="
                        scope.row.status === 1
                          ? 'el-icon-bottom'
                          : 'el-icon-top'
                      "
                    ></i>
                    {{ scope.row.status === 1 ? "下架" : "上架" }}
                  </el-dropdown-item>
                  <el-dropdown-item command="delete" style="color: #f56c6c">
                    <i class="el-icon-delete"></i> 删除
                  </el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
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
  </div>
</template>

<script>
export default {
  name: "MerchantBookList",
  data() {
    return {
      loading: false,
      categoryList: [],
      firstCategoryList: [],
      secondCategoryList: [],
      filteredSecondCategoryList: [],
      searchForm: {
        name: "",
        firstCategoryId: "",
        secondCategoryId: "",
      },
      bookList: [],
      filteredBookList: [],
      pagination: {
        page: 1,
        size: 10,
        total: 0,
      },
    };
  },
  mounted() {
    this.loadCategoryList();
    this.loadBooks();

    window.addEventListener("book-updated", this.handleBookUpdated);
  },
  beforeDestroy() {
    window.removeEventListener("book-updated", this.handleBookUpdated);
  },
  watch: {
    "searchForm.name"() {
      this.pagination.page = 1;
      this.loadBooks();
    },
    "searchForm.firstCategoryId"() {
      this.pagination.page = 1;
      this.loadBooks();
    },
    "searchForm.secondCategoryId"() {
      this.pagination.page = 1;
      this.loadBooks();
    },
  },
  methods: {
    handleBookUpdated() {
      this.loadBooks();
    },
    loadCategoryList() {
      this.$http
        .get("/category/list")
        .then((res) => {
          if (res.code === 200) {
            this.categoryList = res.data || [];
            this.firstCategoryList = this.categoryList.filter(
              (cat) => cat.categoryLevel === 1
            );
            this.secondCategoryList = this.categoryList.filter(
              (cat) => cat.categoryLevel === 2
            );
            this.filteredSecondCategoryList = [...this.secondCategoryList];
          }
        })
        .catch(() => {});
    },
    handleFirstCategoryChange(categoryId) {
      this.searchForm.secondCategoryId = "";
      if (categoryId) {
        this.filteredSecondCategoryList = this.secondCategoryList.filter(
          (cat) => cat.parentId === categoryId
        );
      } else {
        this.filteredSecondCategoryList = [...this.secondCategoryList];
      }
    },
    loadBooks() {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) {
        this.$message.error("无法获取商家信息，请重新登录");
        return;
      }

      this.loading = true;

      const params = {
        page: this.pagination.page,
        pageSize: this.pagination.size,
        merchantId: parseInt(merchantId),
      };

      if (this.searchForm.name) {
        params.bookName = this.searchForm.name;
      }

      if (this.searchForm.secondCategoryId) {
        params.categoryId = this.searchForm.secondCategoryId;
      } else if (this.searchForm.firstCategoryId) {
        const childIds = this.secondCategoryList
          .filter((cat) => cat.parentId === this.searchForm.firstCategoryId)
          .map((cat) => cat.id);
        if (childIds.length > 0) {
          params.categoryIds = childIds;
        }
      }

      this.$http
        .get("/book/page", { params })
        .then((res) => {
          if (res.code === 200) {
            this.bookList = res.data.records || res.data.list || [];
            this.filteredBookList = [...this.bookList];
            this.pagination.total = res.data.total || this.bookList.length;
          } else {
            this.$message.error(res.message || "加载图书失败");
          }
        })
        .catch(() => {
          this.$message.error("加载图书失败，请稍后重试");
        })
        .finally(() => {
          this.loading = false;
        });
    },
    getRowIndex(index) {
      return (this.pagination.page - 1) * this.pagination.size + index + 1;
    },
    searchBooks() {
      this.pagination.page = 1;
      this.loadBooks();
    },
    resetSearch() {
      this.searchForm = {
        name: "",
        firstCategoryId: "",
        secondCategoryId: "",
      };
      this.filteredSecondCategoryList = [...this.secondCategoryList];
      this.searchBooks();
    },
    handleSizeChange(size) {
      this.pagination.size = size;
      this.loadBooks();
    },
    handleCurrentChange(page) {
      this.pagination.page = page;
      this.loadBooks();
    },
    editBook(row) {
      this.$router.push(`/merchant/book-edit/${row.id}`);
    },
    toggleStatus(row) {
      const action = row.status === 1 ? "下架" : "上架";
      this.$confirm(`确定要${action}《${row.name}》吗？`, "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          row.status = row.status === 1 ? 0 : 1;
          this.$message.success(`${action}成功`);
        })
        .catch(() => {
          // 用户点击取消，不做任何操作
        });
    },
    handleCommand(command, row) {
      if (command === "online" || command === "offline") {
        this.toggleStatus(row);
      } else if (command === "delete") {
        this.deleteBook(row);
      }
    },
    deleteBook(row) {
      this.$confirm(`确定要删除《${row.name}》吗？`, "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          const index = this.bookList.findIndex((item) => item.id === row.id);
          if (index > -1) {
            this.bookList.splice(index, 1);
            this.$message.success("删除成功");
          }
        })
        .catch(() => {});
    },
  },
};
</script>

<style scoped>
.book-list {
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

.add-btn {
  background: white;
  border: none;
  color: #409eff;
  font-weight: 500;
  transition: all 0.3s;
}

.add-btn:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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

.cover-image-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 5px;
}

.cover-image-wrapper ::v-deep .el-image {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.cover-image-wrapper ::v-deep .el-image:hover {
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

.book-name-cell {
  line-height: 1.4;
  padding: 5px 0;
}

.price-text {
  color: #f56c6c;
  font-weight: 600;
  font-size: 14px;
}

.sales-text {
  color: #67c23a;
  font-weight: 500;
}

.action-buttons {
  display: flex;
  gap: 8px;
  justify-content: center;
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>

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
