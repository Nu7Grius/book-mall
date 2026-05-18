<template>
  <div class="login-container">
    <el-card class="login-card">
      <h2 class="login-title">📚 图书商城管理系统</h2>
      <el-form
        ref="loginForm"
        :model="loginForm"
        :rules="rules"
        class="login-form"
      >
        <el-form-item prop="role">
          <el-select
            v-model="loginForm.role"
            placeholder="请选择登录角色"
            style="width: 100%"
          >
            <el-option label="👤 用户" value="user"></el-option>
            <el-option label="👔 商家" value="merchant"></el-option>
            <el-option label="🔧 管理员" value="admin"></el-option>
          </el-select>
        </el-form-item>

        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            prefix-icon="el-icon-user"
            placeholder="请输入用户名"
            clearable
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            prefix-icon="el-icon-lock"
            :type="showPassword ? 'text' : 'password'"
            placeholder="请输入密码"
            clearable
            @keyup.enter.native="handleLogin"
          >
            <i
              slot="suffix"
              class="el-input__icon el-icon-view"
              style="cursor: pointer"
              @click="showPassword = !showPassword"
            ></i>
          </el-input>
        </el-form-item>

        <el-form-item>
          <el-button
            type="primary"
            :loading="loading"
            class="login-button"
            @click="handleLogin"
          >
            {{ loading ? "登录中..." : "登 录" }}
          </el-button>
        </el-form-item>

        <div class="login-footer">
          <span v-if="loginForm.role === 'user'">还没有账号？</span>
          <router-link v-if="loginForm.role === 'user'" to="/register"
            >立即注册</router-link
          >
          <span v-if="loginForm.role === 'merchant'">还没有店铺？</span>
          <router-link
            v-if="loginForm.role === 'merchant'"
            to="/merchant-register"
            >立即入驻</router-link
          >
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      loginForm: {
        username: "",
        password: "",
        role: "user",
      },
      rules: {
        role: [
          { required: true, message: "请选择登录角色", trigger: "change" },
        ],
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" },
        ],
        password: [{ required: true, message: "请输入密码", trigger: "blur" }],
      },
      loading: false,
      showPassword: false,
    };
  },
  mounted() {
    // 清理所有可能的旧session信息
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    localStorage.removeItem("userId");
    localStorage.removeItem("userInfo");
    localStorage.removeItem("merchantInfo");
    localStorage.removeItem("merchantId");

    const redirect = this.$route.query.redirect;
    if (redirect === "merchant") {
      this.loginForm.role = "merchant";
    } else if (redirect === "user") {
      this.loginForm.role = "user";
    }
  },
  methods: {
    handleLogin() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          this.loading = true;
          if (this.loginForm.role === "admin") {
            this.$http
              .post("/user/login", {
                username: this.loginForm.username,
                password: this.loginForm.password,
                role: this.loginForm.role,
              })
              .then((res) => {
                if (res.code === 200) {
                  localStorage.setItem("token", res.data.id.toString());
                  localStorage.setItem("user", JSON.stringify(res.data));
                  localStorage.setItem("userId", res.data.id);
                  localStorage.setItem(
                    "userInfo",
                    JSON.stringify({
                      username: res.data.username,
                      role: res.data.role,
                      id: res.data.id,
                    })
                  );
                  this.$message.success("管理员登录成功");
                  this.$router.push("/layout/home");
                } else {
                  this.$message.error(res.msg || "用户名或密码错误");
                }
              })
              .catch((error) => {
                this.$message.error("登录失败：" + error.message);
              })
              .finally(() => {
                this.loading = false;
              });
          } else {
            this.$http
              .post("/user/login", {
                username: this.loginForm.username,
                password: this.loginForm.password,
                role: this.loginForm.role,
              })
              .then((res) => {
                if (res.code === 200) {
                  localStorage.setItem("token", res.data.id.toString());
                  localStorage.setItem("user", JSON.stringify(res.data));
                  localStorage.setItem("userId", res.data.id);
                  localStorage.setItem(
                    "userInfo",
                    JSON.stringify({
                      username: res.data.username,
                      role: res.data.role,
                      id: res.data.id,
                    })
                  );
                  this.$message.success("登录成功");

                  if (this.loginForm.role === "merchant") {
                    const existingMerchantInfo =
                      localStorage.getItem("merchantInfo");

                    let merchantInfo = {
                      id: res.data.id,
                      shopName: res.data.shopName || "",
                      logo: res.data.logo || "",
                      description: res.data.description || "",
                      realName: res.data.realName || "",
                      phone: res.data.phone || "",
                      address: res.data.address || "",
                      bankName: res.data.bankName || "",
                      bankAccount: res.data.bankAccount || "",
                      bankAccountName: res.data.bankAccountName || "",
                      status: res.data.status || 1,
                      createTime:
                        res.data.createTime || new Date().toLocaleDateString(),
                    };

                    if (existingMerchantInfo) {
                      try {
                        const existing = JSON.parse(existingMerchantInfo);

                        Object.keys(existing).forEach((key) => {
                          if (
                            existing[key] !== null &&
                            existing[key] !== undefined &&
                            existing[key] !== "" &&
                            !merchantInfo[key]
                          ) {
                            merchantInfo[key] = existing[key];
                          }
                        });
                      } catch (e) {
                        // ignore parse error
                      }
                    }

                    if (
                      !merchantInfo.shopName ||
                      merchantInfo.shopName === ""
                    ) {
                      merchantInfo.shopName = "我的书店";
                    }

                    localStorage.setItem(
                      "merchantId",
                      merchantInfo.id.toString()
                    );
                    localStorage.setItem(
                      "merchantInfo",
                      JSON.stringify(merchantInfo)
                    );
                    this.$router.push("/merchant/home");
                  } else {
                    this.$router.push("/home");
                  }
                }
              })
              .finally(() => {
                this.loading = false;
              });
          }
        }
      });
    },
  },
};
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 400px;
}

.login-title {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
}

.login-button {
  width: 100%;
}

.login-footer {
  text-align: center;
  margin-top: 10px;
  color: #666;
}

.login-footer a {
  color: #409eff;
  text-decoration: none;
  margin-left: 5px;
}

.login-footer a:hover {
  text-decoration: underline;
}
</style>
