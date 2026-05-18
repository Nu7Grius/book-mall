<template>
  <div class="my-profile">
    <el-card>
      <div slot="header" class="clearfix">
        <span class="card-title">账户设置</span>
        <el-button
          style="float: right; padding: 8px 15px"
          size="small"
          @click="goBack"
        >
          <i class="el-icon-arrow-left"></i> 返回
        </el-button>
      </div>

      <el-tabs v-model="activeTab" type="border-card">
        <!-- 基本信息 -->
        <el-tab-pane label="基本信息" name="profile">
          <el-form
            ref="profileForm"
            :model="profileForm"
            :rules="profileRules"
            label-width="100px"
            class="profile-form"
          >
            <el-form-item label="头像">
              <div class="avatar-upload">
                <div class="avatar-preview" @click="triggerUpload">
                  <img
                    v-if="profileForm.avatarUrl"
                    :src="getImageUrl(profileForm.avatarUrl)"
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
                  <el-button size="small" @click="triggerUpload">
                    更换头像
                  </el-button>
                  <p>支持 JPG、PNG 格式，建议尺寸 200x200</p>
                </div>
              </div>
            </el-form-item>

            <el-form-item label="用户名" prop="username">
              <el-input
                v-model="profileForm.username"
                placeholder="请输入用户名（3-20个字符）"
                maxlength="20"
                @blur="checkUsername"
                style="width: 300px"
              >
                <template slot="append">
                  <span
                    v-if="usernameCheckLoading"
                    style="width: 50px; text-align: center"
                  >
                    <i class="el-icon-loading"></i>
                  </span>
                  <span
                    v-else-if="
                      profileForm.username && profileForm.username.length >= 3
                    "
                    style="width: 50px; text-align: center"
                    :style="{
                      color: usernameAvailable ? '#67c23a' : '#f56c6c',
                    }"
                  >
                    <i
                      :class="
                        usernameAvailable
                          ? 'el-icon-circle-check'
                          : 'el-icon-circle-close'
                      "
                    ></i>
                  </span>
                </template>
              </el-input>
            </el-form-item>

            <el-form-item label="真实姓名" prop="realName">
              <el-input
                v-model="profileForm.realName"
                placeholder="请输入真实姓名"
                maxlength="20"
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

            <el-form-item label="性别">
              <el-radio-group v-model="profileForm.gender">
                <el-radio label="男">
                  <span class="gender-icon male">♂</span> 男
                </el-radio>
                <el-radio label="女">
                  <span class="gender-icon female">♀</span> 女
                </el-radio>
                <el-radio label="保密">
                  <span class="gender-icon secret">⚥</span> 保密
                </el-radio>
              </el-radio-group>
            </el-form-item>

            <el-form-item label="年龄" prop="age">
              <el-input-number
                v-model="profileForm.age"
                :min="1"
                :max="150"
                placeholder="请输入年龄"
              ></el-input-number>
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                @click="saveProfile"
                :loading="savingProfile"
              >
                保存修改
              </el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <!-- 修改密码 -->
        <el-tab-pane label="修改密码" name="password">
          <el-form
            ref="passwordForm"
            :model="passwordForm"
            :rules="passwordRules"
            label-width="100px"
            class="password-form"
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
              ></el-input>
              <div class="password-strength">
                <span>密码强度：</span>
                <el-progress
                  :percentage="passwordStrength"
                  :color="passwordStrengthColor"
                  :show-text="false"
                  style="width: 200px; display: inline-block"
                ></el-progress>
                <span :style="{ color: passwordStrengthColor }">
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
                @click="changePassword"
                :loading="changingPassword"
              >
                修改密码
              </el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
import { getImageUrl } from "@/utils/img";

export default {
  name: "MyProfile",
  data() {
    const validateUsernameAvailable = (rule, value, callback) => {
      if (!value) {
        callback(new Error("请输入用户名"));
        return;
      }
      if (value.length < 3 || value.length > 20) {
        callback(new Error("用户名为3-20个字符"));
        return;
      }
      if (!this.usernameAvailable) {
        callback(new Error("该用户名已被使用"));
      } else {
        callback();
      }
    };

    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error("两次输入的密码不一致"));
      } else {
        callback();
      }
    };

    return {
      activeTab: "profile",
      profileForm: {
        username: "",
        realName: "",
        phone: "",
        email: "",
        avatarUrl: "",
        gender: "保密",
        age: null,
      },
      profileRules: {
        username: [{ validator: validateUsernameAvailable, trigger: "blur" }],
        realName: [
          { required: true, message: "请输入真实姓名", trigger: "blur" },
          {
            min: 2,
            max: 20,
            message: "姓名长度为2-20个字符",
            trigger: "blur",
          },
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
        age: [{ type: "number", message: "年龄必须为数字", trigger: "blur" }],
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
          { min: 6, max: 20, message: "密码长度为6-20位", trigger: "blur" },
        ],
        confirmPassword: [
          { required: true, message: "请再次输入新密码", trigger: "blur" },
          { validator: validateConfirmPassword, trigger: "blur" },
        ],
      },
      savingProfile: false,
      changingPassword: false,
      usernameAvailable: true,
      usernameCheckLoading: false,
    };
  },
  computed: {
    passwordStrength() {
      const pwd = this.passwordForm.newPassword;
      if (!pwd) return 0;

      let strength = 0;
      if (pwd.length >= 6) strength += 25;
      if (pwd.length >= 10) strength += 25;
      if (/[a-z]/.test(pwd) && /[A-Z]/.test(pwd)) strength += 25;
      if (/\d/.test(pwd)) strength += 12.5;
      if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pwd)) strength += 12.5;

      return Math.min(100, strength);
    },
    passwordStrengthColor() {
      if (this.passwordStrength < 30) return "#f56c6c";
      if (this.passwordStrength < 60) return "#e6a23c";
      return "#67c23a";
    },
    passwordStrengthText() {
      if (this.passwordStrength < 30) return "弱";
      if (this.passwordStrength < 60) return "中";
      return "强";
    },
  },
  mounted() {
    this.loadUserInfo();
  },
  methods: {
    goBack() {
      this.$router.go(-1);
    },
    loadUserInfo() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login");
        return;
      }

      this.$http.get(`/user/${userId}`).then((res) => {
        if (res.code === 200) {
          this.profileForm = {
            id: res.data.id,
            username: res.data.username,
            realName: res.data.realName || "",
            phone: res.data.phone || "",
            email: res.data.email || "",
            avatarUrl: res.data.avatar,
            gender: res.data.gender || "保密",
            age: res.data.age || null,
          };
        }
      });
    },
    triggerUpload() {
      this.$refs.avatarInput.click();
    },
    handleAvatarChange(event) {
      const file = event.target.files[0];
      if (!file) return;

      if (!file.type.startsWith("image/")) {
        this.$message.error("请选择图片文件");
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        this.$message.error("图片大小不能超过5MB");
        return;
      }

      const formData = new FormData();
      formData.append("file", file);

      this.$http
        .post("/user/upload-avatar", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        })
        .then((res) => {
          if (res.code === 200) {
            this.profileForm.avatarUrl = res.data;
            this.$message.success("头像上传成功");

            // 更新 localStorage 中的用户信息
            const user = JSON.parse(localStorage.getItem("user") || "{}");
            user.avatar = res.data;
            localStorage.setItem("user", JSON.stringify(user));

            // 触发头像更新事件，让顶部导航栏刷新头像
            window.dispatchEvent(new Event("avatar-updated"));
          }
        })
        .catch(() => {
          this.$message.error("头像上传失败");
        });

      event.target.value = "";
    },
    checkUsername() {
      const username = this.profileForm.username;
      if (!username || username.length < 3 || username.length > 20) {
        return;
      }

      const originalUser = JSON.parse(localStorage.getItem("user") || "{}");
      if (username === originalUser.username) {
        this.usernameAvailable = true;
        return;
      }

      this.usernameCheckLoading = true;
      this.$http
        .get("/user/check-username", {
          params: {
            username: username,
            excludeId: this.profileForm.id,
          },
        })
        .then((res) => {
          if (res.code === 200) {
            this.usernameAvailable = res.data;
            if (!res.data) {
              this.$message.warning("该用户名已被使用");
            }
          }
        })
        .finally(() => {
          this.usernameCheckLoading = false;
        });
    },
    saveProfile() {
      this.$refs.profileForm.validate((valid) => {
        if (!valid) return;

        if (!this.usernameAvailable) {
          this.$message.warning("用户名不可用，请更换后重试");
          return;
        }

        this.savingProfile = true;
        this.$http
          .put("/user/profile", {
            id: this.profileForm.id,
            username: this.profileForm.username,
            realName: this.profileForm.realName,
            phone: this.profileForm.phone,
            email: this.profileForm.email,
            avatar: this.profileForm.avatarUrl,
            gender: this.profileForm.gender,
            age: this.profileForm.age,
          })
          .then((res) => {
            if (res.code === 200) {
              this.$message.success("保存成功");
              const user = JSON.parse(localStorage.getItem("user") || "{}");
              user.username = this.profileForm.username;
              user.realName = this.profileForm.realName;
              localStorage.setItem("user", JSON.stringify(user));
            } else {
              this.$message.error(res.message || "保存失败");
            }
          })
          .finally(() => {
            this.savingProfile = false;
          });
      });
    },
    changePassword() {
      this.$refs.passwordForm.validate((valid) => {
        if (!valid) return;

        this.changingPassword = true;
        this.$http
          .put("/user/password", {
            userId: this.profileForm.id,
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
              setTimeout(() => {
                localStorage.removeItem("user");
                localStorage.removeItem("userId");
                localStorage.removeItem("token");
                this.$router.push("/login");
              }, 1500);
            } else {
              this.$message.error(res.message || "密码修改失败");
            }
          })
          .finally(() => {
            this.changingPassword = false;
          });
      });
    },
  },
};
</script>

<style scoped>
.my-profile {
  padding: 30px;
  max-width: 800px;
  margin: 0 auto;
}

.my-profile .el-card {
  border-radius: 16px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.card-title {
  font-size: 18px;
  font-weight: bold;
}

.profile-form,
.password-form {
  max-width: 500px;
}

.avatar-upload {
  display: flex;
  align-items: center;
  gap: 20px;
}

.avatar-preview {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  cursor: pointer;
  border: 3px solid #e4e4e4;
  transition: all 0.3s;
}

.avatar-preview:hover {
  border-color: #409eff;
  transform: scale(1.05);
}

.avatar-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
  color: #c0c4cc;
  font-size: 48px;
}

.avatar-tip {
  color: #909399;
  font-size: 12px;
}

.avatar-tip p {
  margin-top: 8px;
}

.gender-icon {
  font-size: 18px;
  font-weight: bold;
  margin-right: 4px;
}

.gender-icon.male {
  color: #409eff;
}

.gender-icon.female {
  color: #f56c6c;
}

.gender-icon.secret {
  color: #909399;
}

.form-tip {
  display: block;
  color: #909399;
  font-size: 12px;
  margin-top: 5px;
}

.password-strength {
  margin-top: 8px;
  font-size: 12px;
  color: #606266;
}

.el-tabs {
  border-radius: 8px;
  overflow: hidden;
}
</style>
