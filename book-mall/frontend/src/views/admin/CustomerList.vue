<template>
  <div
    class="customer-container"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-user"></i>
            用户信息管理
          </h2>
          <p class="header-subtitle">管理系统用户信息</p>
        </div>
        <div class="header-right">
          <el-button
            type="primary"
            size="medium"
            @click="handleAdd"
            class="add-btn"
          >
            <i class="el-icon-plus"></i> 添加用户
          </el-button>
        </div>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="queryForm" class="query-form">
        <el-form-item label="用户名" class="search-item">
          <el-input
            v-model="queryForm.username"
            placeholder="请输入用户名"
            clearable
            prefix-icon="el-icon-search"
          ></el-input>
        </el-form-item>
        <el-form-item label="真实姓名" class="search-item">
          <el-input
            v-model="queryForm.realName"
            placeholder="请输入真实姓名"
            clearable
            prefix-icon="el-icon-user"
          ></el-input>
        </el-form-item>
        <el-form-item label="手机号" class="search-item">
          <el-input
            v-model="queryForm.phone"
            placeholder="请输入手机号"
            clearable
            prefix-icon="el-icon-phone"
          ></el-input>
        </el-form-item>
        <el-form-item label="状态" class="search-item">
          <el-select
            v-model="queryForm.status"
            placeholder="请选择状态"
            clearable
            style="width: 120px"
          >
            <el-option label="启用" :value="1"></el-option>
            <el-option label="禁用" :value="0"></el-option>
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
      <el-table :data="userList" border stripe v-loading="loading" fit>
        <el-table-column
          type="index"
          label="序号"
          width="70"
          align="center"
          :index="getRowIndex"
        ></el-table-column>
        <el-table-column label="头像" width="80" align="center">
          <template slot-scope="scope">
            <el-avatar
              v-if="scope.row.avatar"
              :size="40"
              :src="getImageUrl(scope.row.avatar)"
            ></el-avatar>
            <el-avatar v-else :size="40">
              {{
                scope.row.username
                  ? scope.row.username.charAt(0).toUpperCase()
                  : "U"
              }}
            </el-avatar>
          </template>
        </el-table-column>
        <el-table-column
          prop="username"
          label="用户名"
          min-width="120"
          align="center"
        ></el-table-column>
        <el-table-column
          prop="realName"
          label="真实姓名"
          min-width="120"
          align="center"
        ></el-table-column>
        <el-table-column
          prop="phone"
          label="手机号"
          min-width="130"
          align="center"
        ></el-table-column>
        <el-table-column
          prop="email"
          label="邮箱"
          min-width="200"
          align="center"
        ></el-table-column>
        <el-table-column prop="gender" label="性别" width="80" align="center">
          <template slot-scope="scope">
            <span v-if="scope.row.gender === '男'" style="color: #409eff"
              >男</span
            >
            <span v-else-if="scope.row.gender === '女'" style="color: #f56c6c"
              >女</span
            >
            <span v-else>保密</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="age"
          label="年龄"
          width="80"
          align="center"
        ></el-table-column>
        <el-table-column prop="status" label="状态" width="90" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === 1" type="success">启用</el-tag>
            <el-tag v-else type="info">禁用</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="280" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="primary"
              @click="handleEdit(scope.row)"
            >
              编辑
            </el-button>
            <el-button
              size="mini"
              type="warning"
              @click="handleResetPassword(scope.row)"
            >
              重置密码
            </el-button>
            <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row.id)"
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

    <el-dialog
      :title="userForm.id ? '编辑用户' : '添加用户'"
      :visible.sync="dialogVisible"
      width="600px"
    >
      <el-form
        :model="userForm"
        :rules="rules"
        ref="userForm"
        label-width="100px"
      >
        <el-form-item label="头像">
          <div class="avatar-upload">
            <div class="avatar-preview" @click="triggerAvatarUpload">
              <img
                v-if="userForm.avatar"
                :src="getImageUrl(userForm.avatar)"
                alt="头像"
              />
              <div v-else class="avatar-placeholder">
                <i class="el-icon-user-solid"></i>
              </div>
            </div>
            <input
              type="file"
              ref="avatarInput"
              accept="image/*"
              style="display: none"
              @change="handleAvatarChange"
            />
            <div class="avatar-tip">
              <el-button size="small" @click="triggerAvatarUpload">
                {{ userForm.avatar ? "更换头像" : "上传头像" }}
              </el-button>
              <p>支持 JPG、PNG 格式</p>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="用户名" prop="username">
          <el-input
            v-model="userForm.username"
            placeholder="请输入用户名"
          ></el-input>
        </el-form-item>
        <el-form-item label="初始密码" prop="password" v-if="!userForm.id">
          <el-input
            v-model="userForm.password"
            type="password"
            placeholder="请输入初始密码（6-20位）"
            show-password
          ></el-input>
        </el-form-item>
        <el-form-item label="真实姓名" prop="realName">
          <el-input
            v-model="userForm.realName"
            placeholder="请输入真实姓名"
          ></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input
            v-model="userForm.phone"
            placeholder="请输入手机号"
          ></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input
            v-model="userForm.email"
            placeholder="请输入邮箱"
          ></el-input>
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="userForm.gender">
            <el-radio label="男">男</el-radio>
            <el-radio label="女">女</el-radio>
            <el-radio label="保密">保密</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="年龄" prop="age">
          <el-input-number
            v-model="userForm.age"
            :min="1"
            :max="150"
            placeholder="请输入年龄"
          ></el-input-number>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="userForm.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </div>
    </el-dialog>

    <el-dialog
      title="重置密码"
      :visible.sync="resetPasswordDialogVisible"
      width="400px"
    >
      <el-form
        :model="resetPasswordForm"
        :rules="resetPasswordRules"
        ref="resetPasswordFormRef"
      >
        <el-form-item label="用户名">
          <el-input
            id="customer-reset-username"
            :value="resetPasswordForm.username"
            disabled
          ></el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            id="customer-reset-new-password"
            v-model="resetPasswordForm.newPassword"
            type="password"
            placeholder="请输入新密码（6-20位）"
            show-password
          ></el-input>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            id="customer-reset-confirm-password"
            v-model="resetPasswordForm.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            show-password
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="resetPasswordDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitResetPassword"
          >确定重置</el-button
        >
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getUserList, addUser, updateUser, deleteUser } from "@/api/user";

export default {
  name: "CustomerList",
  data() {
    return {
      userList: [],
      loading: false,
      queryForm: {
        username: "",
        realName: "",
        phone: "",
        status: null,
      },
      pagination: {
        page: 1,
        pageSize: 10,
        total: 0,
      },
      dialogVisible: false,
      dialogTitle: "添加用户",
      userForm: {
        id: null,
        username: "",
        password: "",
        realName: "",
        phone: "",
        email: "",
        gender: "保密",
        age: null,
        role: "user",
        status: 1,
      },
      rules: {
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" },
          {
            min: 3,
            max: 20,
            message: "用户名长度在 3 到 20 个字符",
            trigger: "blur",
          },
        ],
        password: [
          { required: true, message: "请输入初始密码", trigger: "blur" },
          {
            min: 6,
            max: 20,
            message: "密码长度在 6 到 20 个字符",
            trigger: "blur",
          },
        ],
        phone: [
          {
            pattern: /^1[3-9]\d{9}$/,
            message: "请输入正确的手机号",
            trigger: "blur",
          },
        ],
        email: [
          {
            pattern: /^[\w.-]+@[\w.-]+\.\w+$/,
            message: "请输入正确的邮箱",
            trigger: "blur",
          },
        ],
      },
      resetPasswordDialogVisible: false,
      resetPasswordForm: {
        id: null,
        username: "",
        newPassword: "",
        confirmPassword: "",
      },
      resetPasswordRules: {
        newPassword: [
          { required: true, message: "请输入新密码", trigger: "blur" },
          {
            min: 6,
            max: 20,
            message: "密码长度必须在 6 到 20 位之间",
            trigger: "blur",
          },
        ],
        confirmPassword: [
          { required: true, message: "请再次输入新密码", trigger: "blur" },
          {
            validator: (rule, value, callback) => {
              if (value !== this.resetPasswordForm.newPassword) {
                callback(new Error("两次输入的密码不一致"));
              } else {
                callback();
              }
            },
            trigger: "blur",
          },
        ],
      },
    };
  },
  mounted() {
    this.loadUserList();
  },
  watch: {
    "queryForm.username"() {
      this.pagination.page = 1;
      this.loadUserList();
    },
    "queryForm.realName"() {
      this.pagination.page = 1;
      this.loadUserList();
    },
    "queryForm.phone"() {
      this.pagination.page = 1;
      this.loadUserList();
    },
    "queryForm.status"() {
      this.pagination.page = 1;
      this.loadUserList();
    },
  },
  methods: {
    getRowIndex(index) {
      return (this.pagination.page - 1) * this.pagination.pageSize + index + 1;
    },

    triggerAvatarUpload() {
      this.$refs.avatarInput.click();
    },
    handleAvatarChange(event) {
      const file = event.target.files[0];
      if (!file) return;

      if (!file.type.startsWith("image/")) {
        this.$message.error("请选择图片文件");
        return;
      }

      const formData = new FormData();
      formData.append("file", file);

      this.$http
        .post("/upload", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        })
        .then((res) => {
          if (res.code === 200 || res.code === 0) {
            this.userForm.avatar = res.url || res.data;
            this.$message.success("头像上传成功");
          } else {
            this.$message.error("头像上传失败");
          }
        })
        .catch(() => {
          this.$message.error("头像上传失败");
        });
    },
    loadUserList() {
      this.loading = true;
      const params = {
        page: this.pagination.page,
        pageSize: this.pagination.pageSize,
        role: "user",
        username: this.queryForm.username,
        realName: this.queryForm.realName,
        phone: this.queryForm.phone,
        status: this.queryForm.status,
      };

      getUserList(params)
        .then((res) => {
          if (res.code === 200) {
            this.userList = res.data.records || res.data;
            this.pagination.total = res.data.total || 0;
          }
        })
        .finally(() => {
          this.loading = false;
        });
    },
    handleQuery() {
      this.pagination.page = 1;
      this.loadUserList();
    },
    handleReset() {
      this.queryForm = {
        username: "",
        realName: "",
        phone: "",
        status: null,
      };
      this.handleQuery();
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val;
      this.loadUserList();
    },
    handleCurrentChange(val) {
      this.pagination.page = val;
      this.loadUserList();
    },
    handleAdd() {
      this.dialogTitle = "添加用户";
      this.userForm = {
        id: null,
        username: "",
        password: "",
        realName: "",
        phone: "",
        email: "",
        gender: "保密",
        age: null,
        role: "user",
        status: 1,
      };
      this.dialogVisible = true;
    },
    handleEdit(row) {
      this.dialogTitle = "编辑用户";
      this.userForm = {
        id: row.id,
        username: row.username,
        password: "",
        realName: row.realName,
        phone: row.phone,
        email: row.email,
        gender: row.gender || "保密",
        age: row.age,
        role: "user",
        status: row.status,
      };
      this.dialogVisible = true;
    },
    submitForm() {
      this.$refs.userForm.validate((valid) => {
        if (valid) {
          const currentRole = localStorage.getItem("userInfo")
            ? JSON.parse(localStorage.getItem("userInfo")).role
            : null;

          if (this.userForm.id) {
            updateUser(this.userForm, currentRole)
              .then((res) => {
                if (res.code === 200) {
                  this.$message.success("更新成功");
                  this.dialogVisible = false;
                  this.loadUserList();
                } else {
                  this.$message.error(res.message || "更新失败");
                }
              })
              .catch((err) => {
                this.$message.error(err.message || "更新失败");
              });
          } else {
            addUser(this.userForm, currentRole)
              .then((res) => {
                if (res.code === 200) {
                  this.$message.success("添加成功");
                  this.dialogVisible = false;
                  this.loadUserList();
                } else {
                  this.$message.error(res.message || "添加失败");
                }
              })
              .catch((err) => {
                this.$message.error(err.message || "添加失败");
              });
          }
        }
      });
    },
    handleResetPassword(row) {
      this.resetPasswordForm = {
        id: row.id,
        username: row.username,
        newPassword: "",
        confirmPassword: "",
      };
      this.resetPasswordDialogVisible = true;
    },
    submitResetPassword() {
      this.$refs.resetPasswordFormRef.validate((valid) => {
        if (valid) {
          this.$http
            .put("/user/password", {
              userId: this.resetPasswordForm.id,
              newPassword: this.resetPasswordForm.newPassword,
            })
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("密码重置成功");
                this.resetPasswordDialogVisible = false;
              } else {
                this.$message.error(res.message || "密码重置失败");
              }
            })
            .catch((err) => {
              this.$message.error(err.message || "密码重置失败");
            });
        }
      });
    },
    handleDelete(id) {
      this.$confirm("确定要删除该用户吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          const currentRole = localStorage.getItem("userInfo")
            ? JSON.parse(localStorage.getItem("userInfo")).role
            : null;

          deleteUser(id, currentRole)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("删除成功");
                this.loadUserList();
              } else {
                this.$message.error(res.message || "删除失败");
              }
            })
            .catch((err) => {
              this.$message.error(err.message || "删除失败");
            });
        })
        .catch(() => Promise.resolve());
    },
  },
};
</script>

<style scoped>
.customer-container {
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

.avatar-upload {
  display: flex;
  align-items: center;
  gap: 15px;
}

.avatar-preview {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  overflow: hidden;
  cursor: pointer;
  border: 2px dashed #d9d9d9;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
}

.avatar-preview:hover {
  border-color: #1e3c72;
}

.avatar-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-placeholder {
  font-size: 32px;
  color: #c0c4cc;
}

.avatar-tip {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.avatar-tip p {
  margin: 0;
  font-size: 12px;
  color: #909399;
}
</style>
