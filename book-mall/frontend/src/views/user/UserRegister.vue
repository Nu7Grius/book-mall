<template>
  <div class="user-register-container">
    <div class="register-box">
      <el-card class="register-card">
        <div slot="header" class="card-header">
          <h2>📚 OpenBook</h2>
          <p>用户注册</p>
        </div>
        <el-form
          :model="registerForm"
          :rules="rules"
          ref="registerForm"
          label-width="80px"
        >
          <el-form-item label="用户名" prop="username">
            <el-input
              v-model="registerForm.username"
              placeholder="请输入用户名（最多7个汉字或英文字母）"
              maxlength="7"
              show-word-limit
            ></el-input>
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input
              v-model="registerForm.password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="请输入密码"
            >
              <i
                slot="suffix"
                class="el-input__icon el-icon-view"
                style="cursor: pointer"
                @click="showPassword = !showPassword"
              ></i>
            </el-input>
          </el-form-item>
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input
              v-model="registerForm.confirmPassword"
              :type="showConfirmPassword ? 'text' : 'password'"
              placeholder="请再次输入密码"
            >
              <i
                slot="suffix"
                class="el-input__icon el-icon-view"
                style="cursor: pointer"
                @click="showConfirmPassword = !showConfirmPassword"
              ></i>
            </el-input>
          </el-form-item>
          <el-form-item label="真实姓名" prop="realName">
            <el-input
              v-model="registerForm.realName"
              placeholder="请输入真实姓名"
            ></el-input>
          </el-form-item>
          <el-form-item label="手机号" prop="phone">
            <el-input
              v-model="registerForm.phone"
              placeholder="请输入手机号"
              maxlength="11"
              show-word-limit
            ></el-input>
          </el-form-item>
          <el-form-item label="邮箱" prop="email">
            <el-input
              v-model="registerForm.email"
              placeholder="请输入邮箱"
            ></el-input>
          </el-form-item>
          <el-form-item>
            <el-button
              type="primary"
              style="width: 100%"
              :loading="loading"
              @click="handleRegister"
            >
              注册
            </el-button>
          </el-form-item>
          <div class="register-footer">
            <span>已有账号？</span>
            <router-link to="/login">立即登录</router-link>
          </div>
        </el-form>
      </el-card>
    </div>
  </div>
</template>

<script>
export default {
  name: "UserRegister",
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.registerForm.password) {
        callback(new Error("两次输入密码不一致"));
      } else {
        callback();
      }
    };

    const validateUsername = (rule, value, callback) => {
      if (!value) {
        callback(new Error("请输入用户名"));
        return;
      }

      const chineseRegex = /^[\u4e00-\u9fa5]{1,7}$/;
      const englishRegex = /^[a-zA-Z]{1,7}$/;

      if (chineseRegex.test(value) || englishRegex.test(value)) {
        callback();
      } else {
        callback(new Error("用户名必须为1-7个汉字或1-7个英文字母"));
      }
    };

    return {
      registerForm: {
        username: "",
        password: "",
        confirmPassword: "",
        realName: "",
        phone: "",
        email: "",
      },
      loading: false,
      showPassword: false,
      showConfirmPassword: false,
      rules: {
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" },
          { validator: validateUsername, trigger: "blur" },
        ],
        password: [
          { required: true, message: "请输入密码", trigger: "blur" },
          { min: 6, message: "密码长度至少 6 个字符", trigger: "blur" },
        ],
        confirmPassword: [
          { required: true, message: "请再次输入密码", trigger: "blur" },
          { validator: validateConfirmPassword, trigger: "blur" },
        ],
        realName: [
          { required: true, message: "请输入真实姓名", trigger: "blur" },
        ],
        phone: [
          { required: true, message: "请输入手机号", trigger: "blur" },
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
    };
  },
  methods: {
    handleRegister() {
      this.$refs.registerForm.validate((valid) => {
        if (valid) {
          this.loading = true;
          const { confirmPassword, ...submitData } = this.registerForm;
          this.$http
            .post("/user/register", submitData)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("注册成功，请登录");
                this.$router.push("/login?redirect=user");
              }
            })
            .finally(() => {
              this.loading = false;
            });
        }
      });
    },
  },
};
</script>

<style scoped>
.user-register-container {
  width: 100%;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px 0;
}

.register-box {
  width: 450px;
}

.card-header {
  text-align: center;
}

.card-header h2 {
  margin: 0 0 10px 0;
  color: #333;
}

.card-header p {
  margin: 0;
  color: #666;
}

.register-footer {
  text-align: center;
  margin-top: 10px;
  color: #666;
}

.register-footer a {
  color: #409eff;
  text-decoration: none;
}

.register-footer a:hover {
  text-decoration: underline;
}
</style>
