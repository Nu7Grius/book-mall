<template>
  <div class="admin-profile">
    <el-row :gutter="20">
      <el-col :span="24">
        <el-card class="profile-header">
          <div class="header-content">
            <div class="avatar-section">
              <div class="avatar-wrapper" @click="triggerAvatarUpload">
                <el-avatar
                  :size="100"
                  :src="getImageUrl(profileForm.avatar)"
                  class="profile-avatar"
                >
                  <i class="el-icon-user-solid"></i>
                </el-avatar>
                <div class="avatar-overlay">
                  <i class="el-icon-camera"></i>
                  <span>更换头像</span>
                </div>
              </div>
              <input
                type="file"
                ref="avatarInput"
                accept="image/*"
                style="display: none"
                @change="handleAvatarChange"
              />
            </div>
            <div class="info-section">
              <h2 class="username">{{ profileForm.realName }}</h2>
              <div class="meta-info">
                <el-tag
                  :type="isSystemAdmin ? 'danger' : 'warning'"
                  size="medium"
                >
                  <i
                    :class="
                      isSystemAdmin ? 'el-icon-s-tools' : 'el-icon-s-custom'
                    "
                  ></i>
                  {{ isSystemAdmin ? "系统管理员" : "普通管理员" }}
                </el-tag>
                <span class="separator">|</span>
                <span class="create-time">
                  <i class="el-icon-date"></i>
                  注册时间：{{ profileForm.createTime || "未知" }}
                </span>
                <span class="separator">|</span>
                <span class="last-login">
                  <i class="el-icon-time"></i>
                  最后登录：{{ profileForm.lastLoginTime || "未知" }}
                </span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :xs="24" :sm="24" :md="16" :lg="16" :xl="16">
        <el-card>
          <div slot="header">
            <span class="card-title">
              <i class="el-icon-user"></i> 基本信息
            </span>
          </div>
          <el-form
            ref="profileFormRef"
            :model="profileForm"
            :rules="profileRules"
            label-width="120px"
            class="profile-form"
          >
            <el-form-item label="用户名" prop="username">
              <el-input
                v-model="profileForm.username"
                placeholder="请输入用户名"
                :disabled="!isSystemAdmin"
              >
                <template slot="append">
                  <el-tooltip
                    v-if="!isSystemAdmin"
                    content="只有系统管理员可以修改用户名"
                    placement="top"
                  >
                    <i class="el-icon-lock" style="color: #909399"></i>
                  </el-tooltip>
                </template>
              </el-input>
            </el-form-item>

            <el-form-item label="真实姓名" prop="realName">
              <el-input
                v-model="profileForm.realName"
                placeholder="请输入真实姓名"
              ></el-input>
            </el-form-item>

            <el-form-item label="手机号码" prop="phone">
              <el-input
                v-model="profileForm.phone"
                placeholder="请输入手机号码"
                maxlength="11"
              ></el-input>
            </el-form-item>

            <el-form-item label="邮箱" prop="email">
              <el-input
                v-model="profileForm.email"
                placeholder="请输入邮箱"
              ></el-input>
            </el-form-item>

            <el-form-item label="角色说明" prop="roleDesc">
              <el-input
                v-model="profileForm.roleDesc"
                placeholder="请输入角色说明（如：负责图书管理）"
                type="textarea"
                :rows="3"
              ></el-input>
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                icon="el-icon-check"
                @click="saveProfile"
                :loading="savingProfile"
              >
                保存修改
              </el-button>
              <el-button icon="el-icon-refresh" @click="resetForm">
                重置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <el-card style="margin-top: 20px">
          <div slot="header">
            <span class="card-title">
              <i class="el-icon-lock"></i> 修改密码
            </span>
          </div>
          <el-form
            ref="passwordFormRef"
            :model="passwordForm"
            :rules="passwordRules"
            label-width="120px"
          >
            <el-form-item label="当前密码" prop="oldPassword">
              <el-input
                v-model="passwordForm.oldPassword"
                type="password"
                placeholder="请输入当前密码"
                show-password
              ></el-input>
            </el-form-item>

            <el-form-item label="新密码" prop="newPassword">
              <el-input
                v-model="passwordForm.newPassword"
                type="password"
                placeholder="请输入新密码（6-20位）"
                show-password
                @input="calculatePasswordStrength"
              ></el-input>
              <div class="password-strength" v-if="passwordForm.newPassword">
                <span>密码强度：</span>
                <el-progress
                  :percentage="passwordStrength"
                  :color="passwordStrengthColor"
                  :show-text="false"
                  style="width: 200px; display: inline-block; margin-left: 10px"
                ></el-progress>
                <span
                  :style="{ color: passwordStrengthColor, marginLeft: '10px' }"
                >
                  {{ passwordStrengthText }}
                </span>
              </div>
            </el-form-item>

            <el-form-item label="确认密码" prop="confirmPassword">
              <el-input
                v-model="passwordForm.confirmPassword"
                type="password"
                placeholder="请再次输入新密码"
                show-password
              ></el-input>
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                icon="el-icon-key"
                @click="changePassword"
                :loading="changingPassword"
              >
                修改密码
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <el-card
          v-if="isSystemAdmin"
          style="margin-top: 20px"
          class="security-settings"
        >
          <div slot="header">
            <span class="card-title">
              <i class="el-icon-shield"></i> 安全设置
              <el-tag type="danger" size="small" style="margin-left: 10px">
                系统管理员专属
              </el-tag>
            </span>
          </div>
          <el-form label-width="150px">
            <el-form-item label="双因素认证">
              <el-switch v-model="securitySettings.twoFactorAuth"></el-switch>
              <span class="form-tip">启用后登录需要输入手机验证码</span>
            </el-form-item>

            <el-form-item label="登录通知">
              <el-switch
                v-model="securitySettings.loginNotification"
              ></el-switch>
              <span class="form-tip">异地登录时发送邮件通知</span>
            </el-form-item>

            <el-form-item label="操作日志">
              <el-switch v-model="securitySettings.operationLog"></el-switch>
              <span class="form-tip">记录所有敏感操作的详细日志</span>
            </el-form-item>

            <el-form-item label="IP白名单">
              <el-input
                type="textarea"
                v-model="securitySettings.ipWhitelist"
                placeholder="请输入允许登录的IP地址，每行一个，留空表示不限制"
                :rows="3"
              ></el-input>
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                icon="el-icon-check"
                @click="saveSecuritySettings"
                :loading="savingSecurity"
              >
                保存安全设置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>

      <el-col :xs="24" :sm="24" :md="8" :lg="8" :xl="8">
        <el-card class="permissions-card">
          <div slot="header">
            <span class="card-title">
              <i class="el-icon-menu"></i> 权限信息
            </span>
          </div>
          <div class="permissions-list">
            <div
              v-for="(permission, index) in permissions"
              :key="index"
              class="permission-item"
              :class="{ 'permission-disabled': !permission.enabled }"
            >
              <div class="permission-icon">
                <i :class="permission.icon"></i>
              </div>
              <div class="permission-content">
                <div class="permission-label">{{ permission.label }}</div>
                <div class="permission-value">
                  <el-tag
                    :type="permission.enabled ? 'success' : 'info'"
                    size="small"
                  >
                    {{ permission.value }}
                  </el-tag>
                </div>
                <div v-if="permission.note" class="permission-note">
                  {{ permission.note }}
                </div>
              </div>
            </div>
          </div>
        </el-card>

        <el-card class="stats-card" style="margin-top: 20px">
          <div slot="header">
            <span class="card-title">
              <i class="el-icon-data-line"></i> 工作统计
            </span>
          </div>
          <div class="stats-grid">
            <div class="stat-item">
              <div class="stat-value">{{ workStats.loginCount }}</div>
              <div class="stat-label">登录次数</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">{{ workStats.operationCount }}</div>
              <div class="stat-label">操作次数</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">{{ workStats.todayOperations }}</div>
              <div class="stat-label">今日操作</div>
            </div>
          </div>
        </el-card>

        <el-card class="logs-card" style="margin-top: 20px">
          <div slot="header">
            <span class="card-title">
              <i class="el-icon-document"></i> 最近操作
            </span>
            <el-button
              v-if="isSystemAdmin"
              type="text"
              style="float: right; padding: 0"
              @click="viewAllLogs"
            >
              查看全部
            </el-button>
          </div>
          <div class="logs-list">
            <div
              v-for="(log, index) in recentLogs"
              :key="index"
              class="log-item"
            >
              <div class="log-time">{{ log.time }}</div>
              <div class="log-content">{{ log.content }}</div>
            </div>
            <el-empty
              v-if="recentLogs.length === 0"
              description="暂无操作记录"
              :image-size="60"
            ></el-empty>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getImageUrl } from "@/utils/img";

export default {
  name: "AdminProfile",
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error("两次输入的密码不一致"));
      } else {
        callback();
      }
    };

    return {
      profileForm: {
        username: "",
        realName: "",
        phone: "",
        email: "",
        avatar: "",
        roleDesc: "",
        createTime: "",
        lastLoginTime: "",
      },
      profileFormBackup: {},
      profileRules: {
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" },
          {
            min: 3,
            max: 20,
            message: "用户名长度在 3 到 20 个字符",
            trigger: "blur",
          },
        ],
        realName: [
          { required: true, message: "请输入真实姓名", trigger: "blur" },
        ],
        phone: [
          { required: true, message: "请输入手机号码", trigger: "blur" },
          {
            pattern: /^1[3-9]\d{9}$/,
            message: "请输入正确的手机号码",
            trigger: "blur",
          },
        ],
        email: [
          { required: true, message: "请输入邮箱", trigger: "blur" },
          {
            type: "email",
            message: "请输入正确的邮箱格式",
            trigger: "blur",
          },
        ],
      },
      passwordForm: {
        oldPassword: "",
        newPassword: "",
        confirmPassword: "",
      },
      passwordRules: {
        oldPassword: [
          { required: true, message: "请输入当前密码", trigger: "blur" },
        ],
        newPassword: [
          { required: true, message: "请输入新密码", trigger: "blur" },
          {
            min: 6,
            max: 20,
            message: "密码长度在 6 到 20 个字符",
            trigger: "blur",
          },
        ],
        confirmPassword: [
          { required: true, message: "请再次输入新密码", trigger: "blur" },
          { validator: validateConfirmPassword, trigger: "blur" },
        ],
      },
      securitySettings: {
        twoFactorAuth: false,
        loginNotification: true,
        operationLog: true,
        ipWhitelist: "",
      },
      passwordStrength: 0,
      passwordStrengthColor: "#909399",
      passwordStrengthText: "",
      savingProfile: false,
      changingPassword: false,
      savingSecurity: false,
      workStats: {
        loginCount: 0,
        operationCount: 0,
        todayOperations: 0,
      },
      recentLogs: [],
      systemAdminPermissions: [
        {
          icon: "el-icon-bell",
          label: "公告管理",
          value: "增删改查",
          enabled: true,
          note: "可发布和管理所有公告",
        },
        {
          icon: "el-icon-user-solid",
          label: "用户管理",
          value: "增删改查",
          enabled: true,
          note: "可管理所有用户信息",
        },
        {
          icon: "el-icon-s-shop",
          label: "商家管理",
          value: "增删改查",
          enabled: true,
          note: "可管理所有商家信息",
        },
        {
          icon: "el-icon-s-tools",
          label: "管理员管理",
          value: "增删改查",
          enabled: true,
          note: "可管理系统所有管理员",
        },
        {
          icon: "el-icon-reading",
          label: "图书管理",
          value: "审核和删除",
          enabled: true,
          note: "可审核和删除图书，商家负责增改",
        },
        {
          icon: "el-icon-collection",
          label: "分类管理",
          value: "增删改查",
          enabled: true,
          note: "可管理所有图书分类",
        },
        {
          icon: "el-icon-document",
          label: "订单管理",
          value: "查看和处理",
          enabled: true,
          note: "可查看所有订单，但不能发货",
        },
        {
          icon: "el-icon-chat-line-round",
          label: "评论管理",
          value: "查看和删除",
          enabled: true,
          note: "可查看和删除所有评论，商家负责回复",
        },
      ],
      regularAdminPermissions: [
        {
          icon: "el-icon-bell",
          label: "公告管理",
          value: "增删改查",
          enabled: true,
          note: "可发布和管理所有公告",
        },
        {
          icon: "el-icon-user-solid",
          label: "用户管理",
          value: "增删改查",
          enabled: true,
          note: "可管理所有用户信息",
        },
        {
          icon: "el-icon-s-shop",
          label: "商家管理",
          value: "增删改查",
          enabled: true,
          note: "可管理所有商家信息",
        },
        {
          icon: "el-icon-reading",
          label: "图书管理",
          value: "审核和删除",
          enabled: true,
          note: "可审核和删除图书，商家负责增改",
        },
        {
          icon: "el-icon-collection",
          label: "分类管理",
          value: "增删改查",
          enabled: true,
          note: "可管理所有图书分类",
        },
        {
          icon: "el-icon-document",
          label: "订单管理",
          value: "查看和处理",
          enabled: true,
          note: "可查看所有订单，但不能发货",
        },
        {
          icon: "el-icon-chat-line-round",
          label: "评论管理",
          value: "查看和删除",
          enabled: true,
          note: "可查看和删除所有评论，商家负责回复",
        },
      ],
    };
  },
  computed: {
    isSystemAdmin() {
      const userInfo = localStorage.getItem("userInfo");
      if (userInfo) {
        const user = JSON.parse(userInfo);
        return user.role === "super_admin";
      }
      return false;
    },
    permissions() {
      return this.isSystemAdmin
        ? this.systemAdminPermissions
        : this.regularAdminPermissions;
    },
    currentRoleName() {
      return this.isSystemAdmin ? "系统管理员" : "普通管理员";
    },
  },
  mounted() {
    this.loadProfile();
    this.loadWorkStats();
    this.loadRecentLogs();
  },
  methods: {
    loadProfile() {
      const userInfo = localStorage.getItem("userInfo");
      if (!userInfo) {
        this.$message.warning("用户信息不存在，请重新登录");
        setTimeout(() => {
          this.$router.push("/login");
        }, 1500);
        return;
      }

      try {
        const user = JSON.parse(userInfo);
        this.profileForm = {
          username: user.username || "",
          realName: user.realName || "",
          phone: user.phone || "",
          email: user.email || "",
          avatar: user.avatar || "",
          roleDesc: user.roleDesc || "",
          createTime: user.createTime || this.formatDate(new Date()),
          lastLoginTime: user.lastLoginTime || this.formatDate(new Date()),
        };
        this.profileFormBackup = { ...this.profileForm };
      } catch (e) {
        this.$message.warning("用户信息解析失败，请重新登录");
        setTimeout(() => {
          this.$router.push("/login");
        }, 1500);
        return;
      }

      const userId = localStorage.getItem("userId");
      if (userId) {
        this.$http
          .get(`/user/${userId}`)
          .then((res) => {
            if (res && res.code === 200 && res.data) {
              this.profileForm = {
                username: res.data.username || "",
                realName: res.data.realName || "",
                phone: res.data.phone || "",
                email: res.data.email || "",
                avatar: res.data.avatar || "",
                roleDesc: res.data.roleDesc || "",
                createTime: res.data.createTime || this.formatDate(new Date()),
                lastLoginTime:
                  res.data.lastLoginTime || this.formatDate(new Date()),
              };
              this.profileFormBackup = { ...this.profileForm };
            }
          })
          .catch(() => {
            // 使用本地缓存
          });
      }
    },
    loadWorkStats() {
      this.workStats = {
        loginCount: Math.floor(Math.random() * 100) + 50,
        operationCount: Math.floor(Math.random() * 500) + 200,
        todayOperations: Math.floor(Math.random() * 20) + 5,
      };
    },
    loadRecentLogs() {
      this.recentLogs = [
        {
          time: this.formatDate(new Date()),
          content: "登录系统",
        },
        {
          time: this.formatDate(new Date(Date.now() - 3600000)),
          content: "修改了图书信息",
        },
        {
          time: this.formatDate(new Date(Date.now() - 86400000)),
          content: "审核了用户评论",
        },
      ];
    },
    formatDate(date) {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hour = String(date.getHours()).padStart(2, "0");
      const minute = String(date.getMinutes()).padStart(2, "0");
      return `${year}-${month}-${day} ${hour}:${minute}`;
    },
    getImageUrl(path) {
      if (!path) return "";
      if (path.startsWith("http")) return path;
      return "http://localhost:8080" + path;
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
            this.profileForm.avatar = res.data;
            this.$message.success("头像上传成功");
          } else {
            this.$message.error("头像上传失败");
          }
        })
        .catch(() => {
          this.$message.error("头像上传失败");
        });
    },
    saveProfile() {
      this.$refs.profileFormRef.validate((valid) => {
        if (!valid) return;

        this.savingProfile = true;
        const userId = localStorage.getItem("userId");

        this.$http
          .put(`/user/${userId}`, this.profileForm)
          .then((res) => {
            if (res.code === 200) {
              this.$message.success("个人信息保存成功");
              this.profileFormBackup = { ...this.profileForm };
              const userInfo = JSON.parse(
                localStorage.getItem("userInfo") || "{}"
              );
              Object.assign(userInfo, this.profileForm);
              localStorage.setItem("userInfo", JSON.stringify(userInfo));
            } else {
              this.$message.error(res.msg || "保存失败");
            }
          })
          .catch(() => {
            this.$message.error("保存失败，请重试");
          })
          .finally(() => {
            this.savingProfile = false;
          });
      });
    },
    resetForm() {
      this.$refs.profileFormRef.resetFields();
      this.profileForm = { ...this.profileFormBackup };
    },
    calculatePasswordStrength() {
      const password = this.passwordForm.newPassword;
      if (!password) {
        this.passwordStrength = 0;
        return;
      }

      let strength = 0;
      if (password.length >= 6) strength += 25;
      if (password.length >= 10) strength += 25;
      if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 25;
      if (/\d/.test(password)) strength += 12.5;
      if (/[^a-zA-Z0-9]/.test(password)) strength += 12.5;

      this.passwordStrength = strength;

      if (strength < 50) {
        this.passwordStrengthColor = "#F56C6C";
        this.passwordStrengthText = "弱";
      } else if (strength < 75) {
        this.passwordStrengthColor = "#E6A23C";
        this.passwordStrengthText = "中";
      } else {
        this.passwordStrengthColor = "#67C23A";
        this.passwordStrengthText = "强";
      }
    },
    changePassword() {
      this.$refs.passwordFormRef.validate((valid) => {
        if (!valid) return;

        this.changingPassword = true;
        const userId = localStorage.getItem("userId");

        this.$http
          .post("/user/changePassword", {
            userId: userId,
            oldPassword: this.passwordForm.oldPassword,
            newPassword: this.passwordForm.newPassword,
          })
          .then((res) => {
            if (res.code === 200) {
              this.$message.success("密码修改成功，请重新登录");
              this.passwordForm = {
                oldPassword: "",
                newPassword: "",
                confirmPassword: "",
              };
              this.$refs.passwordFormRef.resetFields();
              setTimeout(() => {
                localStorage.removeItem("token");
                localStorage.removeItem("userInfo");
                this.$router.push("/login");
              }, 1500);
            } else {
              this.$message.error(res.msg || "密码修改失败");
            }
          })
          .catch(() => {
            this.$message.error("密码修改失败，请重试");
          })
          .finally(() => {
            this.changingPassword = false;
          });
      });
    },
    saveSecuritySettings() {
      this.savingSecurity = true;
      const userId = localStorage.getItem("userId");

      this.$http
        .post("/user/securitySettings", {
          userId: userId,
          settings: this.securitySettings,
        })
        .then((res) => {
          if (res.code === 200) {
            this.$message.success("安全设置保存成功");
          } else {
            this.$message.error(res.msg || "保存失败");
          }
        })
        .catch(() => {
          this.$message.error("保存失败，请重试");
        })
        .finally(() => {
          this.savingSecurity = false;
        });
    },
    viewAllLogs() {
      this.$router.push("/layout/operation-logs");
    },
  },
};
</script>

<style scoped>
.admin-profile {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  min-height: calc(100vh - 120px);
}

.profile-header {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
  border: none;
}

.profile-header ::v-deep .el-card__body {
  padding: 30px;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 30px;
}

.avatar-section {
  position: relative;
}

.avatar-wrapper {
  position: relative;
  cursor: pointer;
  border-radius: 50%;
  overflow: hidden;
}

.avatar-wrapper:hover .avatar-overlay {
  opacity: 1;
}

.avatar-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
  border-radius: 50%;
  color: white;
  font-size: 12px;
}

.avatar-overlay i {
  font-size: 24px;
  margin-bottom: 5px;
}

.profile-avatar {
  background: white;
  color: #1e3c72;
  font-size: 40px;
  border: 4px solid white;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.info-section {
  flex: 1;
}

.username {
  font-size: 28px;
  font-weight: bold;
  margin: 0 0 15px 0;
}

.meta-info {
  display: flex;
  align-items: center;
  gap: 15px;
  flex-wrap: wrap;
}

.meta-info .el-tag {
  border: none;
}

.separator {
  color: rgba(255, 255, 255, 0.5);
}

.create-time,
.last-login {
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.card-title {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}

.card-title i {
  margin-right: 8px;
  color: #1e3c72;
}

.profile-form {
  max-width: 600px;
}

.password-strength {
  margin-top: 10px;
  font-size: 14px;
  color: #606266;
}

.form-tip {
  margin-left: 10px;
  font-size: 12px;
  color: #909399;
}

.security-settings {
  border-top: 3px solid #1e3c72;
}

.security-settings ::v-deep .el-card__header {
  background-color: #f0f2f5;
}

.permissions-card ::v-deep .el-card__header {
  background-color: #f0f9eb;
}

.permissions-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.permission-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 12px;
  background-color: #fafafa;
  border-radius: 8px;
  transition: all 0.3s;
}

.permission-item:hover {
  background-color: #f0f2f5;
  transform: translateX(5px);
}

.permission-disabled {
  opacity: 0.5;
}

.permission-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  border-radius: 8px;
  color: white;
  font-size: 18px;
}

.permission-disabled .permission-icon {
  background: #c0c4cc;
}

.permission-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.permission-label {
  font-weight: 500;
  color: #303133;
}

.permission-value {
  display: flex;
  align-items: center;
  gap: 8px;
}

.permission-note {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
}

.stat-item {
  text-align: center;
  padding: 20px 10px;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  border-radius: 8px;
  color: white;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 12px;
  opacity: 0.9;
}

.logs-list {
  max-height: 300px;
  overflow-y: auto;
}

.log-item {
  padding: 10px;
  border-bottom: 1px solid #ebeef5;
  transition: background-color 0.3s;
}

.log-item:last-child {
  border-bottom: none;
}

.log-item:hover {
  background-color: #f5f7fa;
}

.log-time {
  font-size: 12px;
  color: #909399;
  margin-bottom: 5px;
}

.log-content {
  font-size: 14px;
  color: #606266;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    text-align: center;
  }

  .meta-info {
    justify-content: center;
  }

  .profile-form {
    max-width: 100%;
  }

  .stats-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}
</style>
