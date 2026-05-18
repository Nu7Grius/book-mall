<template>
  <div
    class="category-container"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-menu"></i>
            分类管理
          </h2>
          <p class="header-subtitle">管理系统图书分类</p>
        </div>
        <div class="header-right">
          <el-button
            type="primary"
            size="medium"
            @click="handleAdd"
            class="add-btn"
          >
            <i class="el-icon-plus"></i> 添加分类
          </el-button>
        </div>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="queryForm" class="query-form">
        <el-form-item label="分类名称" class="search-item">
          <el-input
            v-model="queryForm.categoryName"
            placeholder="请输入分类名称"
            clearable
            prefix-icon="el-icon-search"
          ></el-input>
        </el-form-item>
        <el-form-item label="层级" class="search-item">
          <el-select
            v-model="queryForm.categoryLevel"
            placeholder="请选择层级"
            clearable
            style="width: 120px"
          >
            <el-option label="一级" :value="1"></el-option>
            <el-option label="二级" :value="2"></el-option>
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
      <el-table :data="categoryList" border stripe v-loading="loading" fit>
        <el-table-column
          type="index"
          label="序号"
          width="70"
          align="center"
          :index="getRowIndex"
        ></el-table-column>
        <el-table-column
          prop="categoryName"
          label="分类名称"
          min-width="200"
        ></el-table-column>
        <el-table-column prop="categoryLevel" label="层级" min-width="100">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.categoryLevel === 1" type="success"
              >一级</el-tag
            >
            <el-tag v-else type="warning">二级</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="parentId" label="父级分类" min-width="120">
          <template slot-scope="scope">
            <span v-if="scope.row.parentId === 0">顶级分类</span>
            <el-tag v-else type="info">{{
              scope.row.parentName || "未知"
            }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column
          prop="sortOrder"
          label="排序"
          min-width="100"
        ></el-table-column>
        <el-table-column label="操作" min-width="200" align="center">
          <template slot-scope="scope">
            <el-button size="mini" type="primary" @click="handleEdit(scope.row)"
              >编辑</el-button
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
        layout="total, sizes, prev, pager, next, jumper"
        :total="pagination.total"
        style="margin-top: 20px; text-align: right"
      >
      </el-pagination>
    </el-card>

    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="500px"
      class="category-dialog"
    >
      <el-form
        :model="categoryForm"
        :rules="rules"
        ref="categoryForm"
        label-width="100px"
      >
        <el-form-item label="分类名称" prop="categoryName">
          <el-input
            v-model="categoryForm.categoryName"
            placeholder="请输入分类名称"
          ></el-input>
        </el-form-item>
        <el-form-item label="父级分类" prop="parentId">
          <el-select
            v-model="categoryForm.parentId"
            placeholder="请选择父级分类"
            clearable
            style="width: 100%"
          >
            <el-option label="无（顶级分类）" :value="0"></el-option>
            <el-option
              v-for="item in parentCategories"
              :key="item.id"
              :label="item.categoryName"
              :value="item.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="层级" prop="categoryLevel">
          <el-input-number
            v-model="categoryForm.categoryLevel"
            :min="1"
            :max="3"
            style="width: 100%"
          ></el-input-number>
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number
            v-model="categoryForm.sortOrder"
            :min="0"
            style="width: 100%"
          ></el-input-number>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import request from "@/api/request";

export default {
  name: "CategoryList",
  data() {
    return {
      categoryList: [],
      parentCategories: [],
      loading: false,
      queryForm: {
        categoryName: "",
        categoryLevel: null,
      },
      pagination: {
        page: 1,
        pageSize: 10,
        total: 0,
      },
      dialogVisible: false,
      dialogTitle: "添加分类",
      categoryForm: {
        id: null,
        categoryName: "",
        parentId: 0,
        categoryLevel: 1,
        sortOrder: 0,
      },
      rules: {
        categoryName: [
          { required: true, message: "请输入分类名称", trigger: "blur" },
          {
            min: 2,
            max: 20,
            message: "分类名称长度在 2 到 20 个字符",
            trigger: "blur",
          },
        ],
        categoryLevel: [
          { required: true, message: "请选择层级", trigger: "change" },
        ],
      },
    };
  },
  mounted() {
    this.loadCategoryList();
    this.loadParentCategories();
  },
  watch: {
    "queryForm.categoryName"() {
      this.pagination.page = 1;
      this.loadCategoryList();
    },
    "queryForm.categoryLevel"() {
      this.pagination.page = 1;
      this.loadCategoryList();
    },
  },
  methods: {
    getRowIndex(index) {
      return (this.pagination.page - 1) * this.pagination.pageSize + index + 1;
    },
    async loadCategoryList() {
      this.loading = true;
      try {
        const params = {
          page: this.pagination.page,
          pageSize: this.pagination.pageSize,
        };
        if (this.queryForm.categoryName) {
          params.categoryName = this.queryForm.categoryName;
        }
        if (
          this.queryForm.categoryLevel !== null &&
          this.queryForm.categoryLevel !== ""
        ) {
          params.categoryLevel = this.queryForm.categoryLevel;
        }

        const res = await request.get("/category/page", { params });
        if (res.code === 200) {
          this.categoryList = res.data.records || [];
          this.pagination.total = res.data.total || 0;
        }
      } catch (error) {
      } finally {
        this.loading = false;
      }
    },
    loadParentCategories() {
      request.get("/category/list").then((res) => {
        if (res.code === 200) {
          this.parentCategories = res.data.filter(
            (item) => item.categoryLevel === 1
          );
        }
      });
    },
    handleQuery() {
      this.pagination.page = 1;
      this.loadCategoryList();
    },
    handleReset() {
      this.queryForm = {
        categoryName: "",
        categoryLevel: null,
      };
      this.pagination.page = 1;
      this.loadCategoryList();
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val;
      this.pagination.page = 1;
      this.loadCategoryList();
    },
    handleCurrentChange(val) {
      this.pagination.page = val;
      this.loadCategoryList();
    },
    handleAdd() {
      this.dialogTitle = "添加分类";
      this.categoryForm = {
        id: null,
        categoryName: "",
        parentId: 0,
        categoryLevel: 1,
        sortOrder: 0,
      };
      this.dialogVisible = true;
    },
    handleEdit(row) {
      this.dialogTitle = "编辑分类";
      this.categoryForm = { ...row };
      if (!this.categoryForm.parentId) {
        this.categoryForm.parentId = 0;
      }
      this.dialogVisible = true;
    },
    async handleDelete(id) {
      try {
        await this.$confirm("确定要删除这个分类吗？", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        });
        const res = await request.delete(`/category/${id}`);
        if (res.code === 200) {
          this.$message.success("删除成功");
          this.loadCategoryList();
        }
      } catch (e) {
        // 用户点击取消，不做任何处理
      }
    },
    submitForm() {
      this.$refs.categoryForm.validate((valid) => {
        if (valid) {
          const action = this.categoryForm.id ? axios.put : axios.post;
          const url = this.categoryForm.id ? "/category" : "/category";
          action(url, this.categoryForm).then((res) => {
            if (res.code === 200) {
              this.$message.success("操作成功");
              this.dialogVisible = false;
              this.loadCategoryList();
              this.loadParentCategories();
            }
          });
        }
      });
    },
  },
};
</script>

<style scoped>
.category-container {
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

.add-btn {
  background: white;
  border: none;
  color: #1e3c72;
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

.query-form {
  margin-bottom: 18px;
}

.category-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.category-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
}

.category-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.category-dialog ::v-deep .el-dialog__body {
  padding: 25px;
}
</style>
