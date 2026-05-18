<template>
  <div
    class="admin-container"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-s-tools"></i>
            管理员信息管理
          </h2>
          <p class="header-subtitle">管理系统管理员账号</p>
        </div>
        <div class="header-right">
          <el-button
            v-if="isSuperAdmin"
            type="primary"
            size="medium"
            @click="handleAdd"
            class="add-btn"
          >
            <i class="el-icon-plus"></i> 添加管理员
          </el-button>
          <el-tag v-else type="info" class="info-tag">
            普通管理员无法添加或删除其他管理员
          </el-tag>
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
      <el-table :data="adminList" border stripe v-loading="loading" fit>
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
                scope.row.realName
                  ? scope.row.realName.charAt(0).toUpperCase()
                  : "A"
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
              v-if="isSuperAdmin && scope.row.role !== 'super_admin'"
              size="mini"
              type="danger"
              @click="handleDelete(scope.row.id)"
            >
              <i class="el-icon-delete"></i> 删除
            </el-button>
            <el-tag
              v-if="!isSuperAdmin || scope.row.role === 'super_admin'"
              type="info"
              size="small"
            >
              不可操作
            </el-tag>
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
      title="➕ 添加管理员"
      :visible.sync="dialogVisible"
      width="650px"
      class="admin-edit-dialog"
    >
      <div class="dialog-content">
        <el-form
          :model="adminForm"
          :rules="rules"
          ref="adminFormRef"
          label-width="100px"
        >
          <el-form-item label="用户名" prop="username">
            <el-input v-model="adminForm.username" placeholder="请输入用户名">
              <template slot="prepend"><i class="el-icon-user"></i></template>
            </el-input>
          </el-form-item>
          <el-form-item label="初始密码" prop="password">
            <el-input
              v-model="adminForm.password"
              type="password"
              placeholder="请输入初始密码（6-20位）"
              show-password
            >
              <template slot="prepend"><i class="el-icon-lock"></i></template>
            </el-input>
          </el-form-item>
          <el-form-item label="真实姓名" prop="realName">
            <el-input v-model="adminForm.realName" placeholder="请输入真实姓名">
              <template slot="prepend"
                ><i class="el-icon-postcard"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="管理员类型" prop="role">
            <el-radio-group v-model="adminForm.role">
              <el-radio label="admin">
                <i class="el-icon-user" style="color: #e6a23c"></i> 普通管理员
              </el-radio>
              <el-radio label="super_admin">
                <i class="el-icon-star-on" style="color: #f56c6c"></i>
                超级管理员
              </el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="手机号" prop="phone">
            <el-input v-model="adminForm.phone" placeholder="请输入手机号">
              <template slot="prepend"
                ><i class="el-icon-mobile-phone"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="adminForm.email" placeholder="请输入邮箱">
              <template slot="prepend"
                ><i class="el-icon-message"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="adminForm.status">
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
      title="👔 编辑管理员信息"
      :visible.sync="editDialogVisible"
      width="650px"
      class="admin-edit-dialog"
    >
      <div class="dialog-content">
        <div class="merchant-info-header">
          <div class="merchant-avatar">
            <img
              v-if="editForm.avatar"
              :src="getImageUrl(editForm.avatar)"
              alt="头像"
            />
            <i v-else class="el-icon-user-solid"></i>
          </div>
          <div class="merchant-basic-info">
            <div class="merchant-name">{{ editForm.username }}</div>
            <div class="merchant-meta">
              <el-tag
                size="mini"
                :type="editForm.role === 'super_admin' ? 'danger' : 'warning'"
              >
                {{
                  editForm.role === "super_admin" ? "超级管理员" : "普通管理员"
                }}
              </el-tag>
              <el-tag
                size="mini"
                :type="editForm.status === 1 ? 'success' : 'info'"
              >
                {{ editForm.status === 1 ? "启用" : "禁用" }}
              </el-tag>
            </div>
          </div>
        </div>

        <el-divider><i class="el-icon-edit"></i> 基本信息</el-divider>

        <el-form
          :model="editForm"
          :rules="editRules"
          ref="editFormRef"
          label-width="100px"
        >
          <el-form-item label="管理员头像">
            <div class="avatar-upload">
              <div class="avatar-preview" @click="triggerAvatarUpload">
                <img
                  v-if="editForm.avatar"
                  :src="getImageUrl(editForm.avatar)"
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
                  {{ editForm.avatar ? "更换头像" : "上传头像" }}
                </el-button>
                <p>支持 JPG、PNG 格式</p>
              </div>
            </div>
          </el-form-item>
          <el-form-item label="用户名" prop="username">
            <el-input
              v-model="editForm.username"
              placeholder="请输入用户名"
              :disabled="!isSuperAdmin"
            >
              <template slot="prepend"><i class="el-icon-user"></i></template>
            </el-input>
          </el-form-item>
          <el-form-item label="真实姓名" prop="realName">
            <el-input v-model="editForm.realName" placeholder="请输入真实姓名">
              <template slot="prepend"
                ><i class="el-icon-postcard"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="管理员类型" prop="role" v-if="isSuperAdmin">
            <el-radio-group v-model="editForm.role">
              <el-radio label="admin">
                <i class="el-icon-user" style="color: #e6a23c"></i> 普通管理员
              </el-radio>
              <el-radio label="super_admin">
                <i class="el-icon-star-on" style="color: #f56c6c"></i>
                超级管理员
              </el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="手机号" prop="phone">
            <el-input v-model="editForm.phone" placeholder="请输入手机号">
              <template slot="prepend"
                ><i class="el-icon-mobile-phone"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="editForm.email" placeholder="请输入邮箱">
              <template slot="prepend"
                ><i class="el-icon-message"></i
              ></template>
            </el-input>
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="editForm.status">
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
        <el-button @click="editDialogVisible = false" size="medium">
          <i class="el-icon-close"></i> 取 消
        </el-button>
        <el-button type="primary" @click="submitEditForm" size="medium">
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
              id="admin-reset-username"
              :value="resetPasswordForm.username"
              disabled
            >
              <template slot="prepend"><i class="el-icon-user"></i></template>
            </el-input>
          </el-form-item>
          <el-form-item label="新密码" prop="newPassword">
            <el-input
              id="admin-reset-new-password"
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
              id="admin-reset-confirm-password"
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

export default {
  name: "AdminList",
  data() {
    return {
      adminList: [],
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
      editDialogVisible: false,
      adminForm: {
        id: null,
        username: "",
        password: "",
        realName: "",
        role: "admin",
        phone: "",
        email: "",
        status: 1,
      },
      editForm: {
        id: null,
        username: "",
        realName: "",
        role: "",
        phone: "",
        email: "",
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
        role: [
          { required: true, message: "请选择管理员类型", trigger: "change" },
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
      editRules: {
        realName: [
          { required: true, message: "请输入真实姓名", trigger: "blur" },
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
  },
  mounted() {
    this.loadAdminList();
  },
  watch: {
    "queryForm.username"() {
      this.pagination.page = 1;
      this.loadAdminList();
    },
    "queryForm.realName"() {
      this.pagination.page = 1;
      this.loadAdminList();
    },
    "queryForm.phone"() {
      this.pagination.page = 1;
      this.loadAdminList();
    },
    "queryForm.status"() {
      this.pagination.page = 1;
      this.loadAdminList();
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
            this.editForm.avatar = res.url || res.data;
            this.$message.success("头像上传成功");
          } else {
            this.$message.error("头像上传失败");
          }
        })
        .catch(() => {
          this.$message.error("头像上传失败");
        });
    },
    loadAdminList() {
      this.loading = true;

      if (!this.isSuperAdmin) {
        this.adminList = [];
        this.pagination.total = 0;
        this.loading = false;
        return;
      }

      const params = {
        page: this.pagination.page,
        pageSize: this.pagination.pageSize,
        role: "admin",
        username: this.queryForm.username,
        realName: this.queryForm.realName,
        phone: this.queryForm.phone,
        status: this.queryForm.status,
      };

      getUserList(params)
        .then((res) => {
          if (res.code === 200) {
            this.adminList = res.data.records || res.data;
            this.pagination.total = res.data.total || 0;
          }
        })
        .finally(() => {
          this.loading = false;
        });
    },
    handleQuery() {
      this.pagination.page = 1;
      this.loadAdminList();
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
      this.loadAdminList();
    },
    handleCurrentChange(val) {
      this.pagination.page = val;
      this.loadAdminList();
    },
    handleAdd() {
      this.adminForm = {
        id: null,
        username: "",
        password: "",
        realName: "",
        role: "admin",
        phone: "",
        email: "",
        status: 1,
      };
      this.dialogVisible = true;
    },
    handleEdit(row) {
      this.editForm = {
        id: row.id,
        username: row.username,
        avatar: row.avatar || "",
        realName: row.realName || "",
        role: row.role,
        phone: row.phone || "",
        email: row.email || "",
        gender: row.gender || "保密",
        age: row.age || null,
        status: row.status,
      };
      this.editDialogVisible = true;
    },
    submitForm() {
      this.$refs.adminFormRef.validate((valid) => {
        if (valid) {
          addUser(this.adminForm, this.currentUserRole)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("添加成功");
                this.dialogVisible = false;
                this.loadAdminList();
              } else {
                this.$message.error(res.message || "添加失败");
              }
            })
            .catch((err) => {
              this.$message.error(err.message || "添加失败");
            });
        }
      });
    },
    submitEditForm() {
      this.$refs.editFormRef.validate((valid) => {
        if (valid) {
          updateUser(this.editForm, this.currentUserRole)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("更新成功");
                this.editDialogVisible = false;
                this.loadAdminList();
              } else {
                this.$message.error(res.message || "更新失败");
              }
            })
            .catch((err) => {
              this.$message.error(err.message || "更新失败");
            });
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
      this.$confirm("确定要删除该管理员吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          deleteUser(id, this.currentUserRole)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("删除成功");
                this.loadAdminList();
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
.admin-container {
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

.info-tag {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
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
  margin-bottom: 18px;
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

/* 管理员编辑弹窗样式 */
.admin-edit-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.admin-edit-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
  font-size: 18px;
}

.admin-edit-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.admin-edit-dialog ::v-deep .el-dialog__body {
  padding: 0;
}

.admin-edit-dialog .dialog-content {
  padding: 20px 25px;
}

.admin-edit-dialog ::v-deep .el-dialog__footer {
  padding: 15px 20px;
  border-top: 1px solid #ebeef5;
}

/* 管理员信息头部样式（复用商家样式） */
.admin-edit-dialog .merchant-info-header {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px 25px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ed 100%);
  border-bottom: 1px solid #ebeef5;
}

.admin-edit-dialog .merchant-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  overflow: hidden;
  background: linear-gradient(135deg, #f56c6c 0%, #e6a23c 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(245, 108, 108, 0.3);
}

.admin-edit-dialog .merchant-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.admin-edit-dialog .merchant-avatar i {
  font-size: 28px;
  color: white;
}

.admin-edit-dialog .merchant-basic-info {
  flex: 1;
}

.admin-edit-dialog .merchant-name {
  font-size: 20px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
}

.admin-edit-dialog .merchant-meta {
  display: flex;
  gap: 8px;
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
