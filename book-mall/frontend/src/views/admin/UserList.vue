<template>
  <div
    class="user-container"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-user"></i>
            用户信息
          </h2>
          <p class="header-subtitle">管理系统所有普通用户账号</p>
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
            prefix-icon="el-icon-user"
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
            prefix-icon="el-icon-mobile-phone"
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
      <el-table :data="userList" border stripe v-loading="loading">
        <el-table-column
          type="index"
          label="序号"
          width="70"
          align="center"
          :index="getRowIndex"
        ></el-table-column>
        <el-table-column label="头像" width="80" align="center">
          <template slot-scope="scope">
            <el-avatar :size="40" :src="getImageUrl(scope.row.avatar)">
              <i class="el-icon-user-solid" style="font-size: 20px"></i>
            </el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="username" label="用户名" min-width="120">
          <template slot-scope="scope">
            {{ scope.row.username || "-" }}
          </template>
        </el-table-column>
        <el-table-column prop="realName" label="真实姓名" min-width="120">
          <template slot-scope="scope">
            {{ scope.row.realName || "-" }}
          </template>
        </el-table-column>
        <el-table-column prop="phone" label="手机号" min-width="130">
        </el-table-column>
        <el-table-column prop="email" label="邮箱" min-width="200">
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === 1" type="success">启用</el-tag>
            <el-tag v-else type="info">禁用</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="注册时间" width="180">
          <template slot-scope="scope">
            {{ formatTime(scope.row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="280" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="primary"
              @click="handleEdit(scope.row)"
            >
              <i class="el-icon-edit"></i> 编辑
            </el-button>
            <el-button
              size="mini"
              type="warning"
              @click="handleResetPassword(scope.row)"
            >
              <i class="el-icon-key"></i> 重置密码
            </el-button>
            <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row.id)"
            >
              <i class="el-icon-delete"></i> 删除
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
      :title="userForm.id ? '👤 编辑用户信息' : '➕ 添加用户'"
      :visible.sync="dialogVisible"
      width="600px"
      class="merchant-edit-dialog"
    >
      <div class="dialog-content">
        <div class="merchant-info-header" v-if="userForm.id">
          <div class="merchant-avatar">
            <img
              v-if="userForm.avatar"
              :src="getImageUrl(userForm.avatar)"
              alt="头像"
            />
            <i v-else class="el-icon-user-solid"></i>
          </div>
          <div class="merchant-basic-info">
            <div class="merchant-name">{{ userForm.username }}</div>
            <div class="merchant-meta">
              <el-tag size="mini" type="success">普通用户</el-tag>
              <el-tag
                size="mini"
                :type="userForm.status === 1 ? 'success' : 'info'"
              >
                {{ userForm.status === 1 ? "启用" : "禁用" }}
              </el-tag>
            </div>
          </div>
        </div>

        <el-divider v-if="userForm.id">
          <i class="el-icon-edit"></i> 基本信息
        </el-divider>

        <el-form
          :model="userForm"
          :rules="rules"
          ref="userFormRef"
          label-width="100px"
        >
          <el-form-item label="用户头像" v-if="userForm.id">
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
              :disabled="!!userForm.id"
            >
              <template slot="prepend"><i class="el-icon-user"></i></template>
            </el-input>
          </el-form-item>
          <el-form-item label="初始密码" prop="password" v-if="!userForm.id">
            <el-input
              v-model="userForm.password"
              type="password"
              placeholder="请输入初始密码（6-20位）"
              show-password
            >
              <template slot="prepend"><i class="el-icon-lock"></i></template>
            </el-input>
          </el-form-item>
          <el-form-item label="真实姓名" prop="realName">
            <el-input v-model="userForm.realName" placeholder="请输入真实姓名">
              <template slot="prepend"
                ><i class="el-icon-postcard"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="手机号" prop="phone">
            <el-input v-model="userForm.phone" placeholder="请输入手机号">
              <template slot="prepend"
                ><i class="el-icon-mobile-phone"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="userForm.email" placeholder="请输入邮箱">
              <template slot="prepend"
                ><i class="el-icon-message"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="性别" prop="gender">
            <el-radio-group v-model="userForm.gender">
              <el-radio label="男">
                <i class="el-icon-male" style="color: #409eff"></i> 男
              </el-radio>
              <el-radio label="女">
                <i class="el-icon-female" style="color: #f56c6c"></i> 女
              </el-radio>
              <el-radio label="保密">
                <i class="el-icon-question" style="color: #909399"></i> 保密
              </el-radio>
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
              <el-radio :label="1">
                <i class="el-icon-circle-check" style="color: #67c23a"></i> 启用
              </el-radio>
              <el-radio :label="0">
                <i class="el-icon-circle-close" style="color: #909399"></i> 禁用
              </el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
      </div>
      <div slot="footer">
        <el-button @click="dialogVisible = false" size="medium">
          <i class="el-icon-close"></i> 取 消
        </el-button>
        <el-button type="primary" @click="submitForm" size="medium">
          <i class="el-icon-check"></i> 确 定
        </el-button>
      </div>
    </el-dialog>

    <el-dialog
      title="🔑 重置密码"
      :visible.sync="resetPasswordDialogVisible"
      width="450px"
      class="reset-password-dialog"
    >
      <div class="dialog-content">
        <el-form
          :model="resetPasswordForm"
          :rules="resetPasswordRules"
          ref="resetPasswordFormRef"
          label-width="100px"
        >
          <el-form-item label="用户名">
            <el-input
              id="reset-username"
              :value="resetPasswordForm.username"
              disabled
            >
              <template slot="prepend"><i class="el-icon-user"></i></template>
            </el-input>
          </el-form-item>
          <el-form-item label="新密码" prop="newPassword">
            <el-input
              id="reset-new-password"
              v-model="resetPasswordForm.newPassword"
              type="password"
              placeholder="请输入新密码（6-20位）"
              show-password
            >
              <template slot="prepend"><i class="el-icon-lock"></i></template>
            </el-input>
          </el-form-item>
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input
              id="reset-confirm-password"
              v-model="resetPasswordForm.confirmPassword"
              type="password"
              placeholder="请再次输入新密码"
              show-password
            >
              <template slot="prepend"><i class="el-icon-lock"></i></template>
            </el-input>
          </el-form-item>
        </el-form>
      </div>
      <div slot="footer">
        <el-button @click="resetPasswordDialogVisible = false" size="medium">
          <i class="el-icon-close"></i> 取 消
        </el-button>
        <el-button type="primary" @click="submitResetPassword" size="medium">
          <i class="el-icon-check"></i> 确定重置
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getUserList, addUser, updateUser, deleteUser } from "@/api/user";
import { getImageUrl } from "@/utils/img";

export default {
  name: "UserList",
  data() {
    return {
      userList: [],
      loading: false,
      queryForm: {
        username: "",
        realName: "",
        phone: "",
        role: "",
        status: null,
        shopType: "",
        shopName: "",
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
        role: "user",
        status: 1,
        shopName: "",
        shopType: "",
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
        gender: [{ required: true, message: "请选择性别", trigger: "change" }],
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
  computed: {
    currentUserRole() {
      const userInfo = localStorage.getItem("userInfo");
      if (userInfo) {
        try {
          return JSON.parse(userInfo).role;
        } catch (e) {}
      }
      return null;
    },
    isSuperAdmin() {
      return this.currentUserRole === "super_admin";
    },
    roleOptions() {
      if (this.isSuperAdmin) {
        return [
          { label: "管理员", value: "admin" },
          { label: "商家", value: "merchant" },
          { label: "普通用户", value: "user" },
        ];
      } else {
        return [
          { label: "商家", value: "merchant" },
          { label: "普通用户", value: "user" },
        ];
      }
    },
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
    formatTime(time) {
      if (!time) return "-";
      const date = new Date(time);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hours = String(date.getHours()).padStart(2, "0");
      const minutes = String(date.getMinutes()).padStart(2, "0");
      const seconds = String(date.getSeconds()).padStart(2, "0");
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
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
          if (res.code === 200) {
            this.userForm.avatar = res.data;
            this.$message.success("头像上传成功");
          } else {
            this.$message.error(res.message || "头像上传失败");
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
      };
      if (this.queryForm.username) {
        params.username = this.queryForm.username;
      }
      if (this.queryForm.realName) {
        params.realName = this.queryForm.realName;
      }
      if (this.queryForm.phone) {
        params.phone = this.queryForm.phone;
      }
      if (this.queryForm.status !== null && this.queryForm.status !== "") {
        params.status = this.queryForm.status;
      }

      getUserList(params)
        .then((res) => {
          if (res.code === 200) {
            this.userList = res.data.records || [];
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
      this.pagination.page = 1;
      this.loadUserList();
    },
    handleSizeChange(size) {
      this.pagination.pageSize = size;
      this.pagination.page = 1;
      this.loadUserList();
    },
    handleCurrentChange(page) {
      this.pagination.page = page;
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
        realName: row.realName || "",
        phone: row.phone || "",
        email: row.email || "",
        gender: row.gender || "保密",
        age: row.age || null,
        role: row.role,
        status: row.status,
        avatar: row.avatar || "",
      };
      this.dialogVisible = true;
    },
    async handleDelete(id) {
      try {
        await this.$confirm("确定要删除这个用户吗？", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        });
        const res = await deleteUser(id);
        if (res.code === 200) {
          this.$message.success("删除成功");
          this.loadUserList();
        }
      } catch (e) {
        // 用户点击取消，不做任何处理
      }
    },
    submitForm() {
      this.$refs.userFormRef.validate((valid) => {
        if (valid) {
          if (this.userForm.id) {
            updateUser(this.userForm)
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
            addUser(this.userForm)
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
  },
};
</script>

<style scoped>
.user-container {
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

.header-right {
  display: flex;
  align-items: center;
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

.action-card {
  border: none;
  border-radius: 12px;
}

.table-card {
  border: none;
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header span {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
}

.card-header i {
  color: #1e3c72;
}

/* 商家编辑弹窗样式 */
.merchant-edit-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.merchant-edit-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
  font-size: 18px;
}

.merchant-edit-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.merchant-edit-dialog ::v-deep .el-dialog__body {
  padding: 0;
}

.dialog-content {
  padding: 20px 25px;
}

.merchant-info-header {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px 25px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ed 100%);
  border-bottom: 1px solid #ebeef5;
}

.merchant-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  overflow: hidden;
  background: linear-gradient(135deg, #e6a23c 0%, #f56c6c 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(230, 162, 60, 0.3);
}

.merchant-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.merchant-avatar i {
  font-size: 28px;
  color: white;
}

.merchant-basic-info {
  flex: 1;
}

.merchant-basic-info .merchant-name {
  font-size: 20px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
}

.merchant-meta {
  display: flex;
  gap: 8px;
}

.merchant-edit-dialog ::v-deep .el-dialog__footer {
  padding: 15px 20px;
  border-top: 1px solid #ebeef5;
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
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  cursor: pointer;
  transition: transform 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar-preview:hover {
  transform: scale(1.05);
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

.form-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.form-tip.warning {
  color: #e6a23c;
}

/* 重置密码弹窗样式 */
.reset-password-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.reset-password-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
  font-size: 18px;
}

.reset-password-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.reset-password-dialog ::v-deep .el-dialog__body {
  padding: 0;
}

.reset-password-dialog .dialog-content {
  padding: 20px 25px;
}

.reset-password-dialog ::v-deep .el-dialog__footer {
  padding: 15px 20px;
  border-top: 1px solid #ebeef5;
}
</style>
