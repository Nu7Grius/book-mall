<template>
  <div class="merchant-register-container">
    <div class="register-box">
      <el-card class="register-card">
        <div slot="header" class="card-header">
          <h2>🏪 商户入驻</h2>
          <p>入驻 OpenBook，开启您的书店之旅</p>
        </div>
        <el-form
          :model="registerForm"
          :rules="rules"
          ref="registerForm"
          label-width="100px"
        >
          <el-form-item label="店铺名称" prop="shopName">
            <el-input
              v-model="registerForm.shopName"
              placeholder="请输入店铺名称"
            ></el-input>
          </el-form-item>
          <el-form-item label="用户名" prop="username">
            <el-input
              v-model="registerForm.username"
              placeholder="请输入用户名"
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
          <el-form-item label="联系人" prop="realName">
            <el-input
              v-model="registerForm.realName"
              placeholder="请输入联系人姓名"
            ></el-input>
          </el-form-item>
          <el-form-item label="联系电话" prop="phone">
            <el-input
              v-model="registerForm.phone"
              placeholder="请输入联系电话"
            ></el-input>
          </el-form-item>
          <el-form-item label="店铺地址" prop="address">
            <el-input
              v-model="registerForm.address"
              type="textarea"
              :rows="2"
              placeholder="请输入店铺地址"
            ></el-input>
          </el-form-item>
          <el-form-item>
            <el-button
              type="primary"
              style="width: 100%"
              :loading="loading"
              @click="handleRegister"
            >
              立即入驻
            </el-button>
          </el-form-item>
          <div class="register-footer">
            <span>已有店铺？</span>
            <router-link to="/login">立即登录</router-link>
          </div>
        </el-form>
      </el-card>
    </div>
  </div>
</template>

<script>
export default {
  name: "MerchantRegister",
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
        shopName: "",
        username: "",
        password: "",
        confirmPassword: "",
        realName: "",
        phone: "",
        address: "",
      },
      loading: false,
      showPassword: false,
      showConfirmPassword: false,
      rules: {
        shopName: [
          { required: true, message: "请输入店铺名称", trigger: "blur" },
          {
            min: 2,
            max: 50,
            message: "店铺名称长度在 2 到 50 个字符",
            trigger: "blur",
          },
        ],
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
          { required: true, message: "请输入联系人姓名", trigger: "blur" },
        ],
        phone: [
          { required: true, message: "请输入联系电话", trigger: "blur" },
          {
            pattern: /(^1[3-9]\d{9}$)|(^0\d{2,3}-?\d{7,8}(-\d{1,6})?$)/,
            message: "请输入正确的手机号码或座机号码",
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
            .post("/user/register/merchant", submitData)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("入驻成功，请登录");
                const merchantId = res.data?.id || Date.now();
                localStorage.setItem("merchantId", merchantId.toString());
                localStorage.setItem(
                  "merchantInfo",
                  JSON.stringify({
                    id: merchantId,
                    shopName: submitData.shopName,
                    realName: submitData.realName,
                    phone: submitData.phone,
                    address: submitData.address,
                    createTime: new Date().toLocaleDateString(),
                  })
                );
                this.$router.push("/login?redirect=merchant");
              } else {
                this.$message.error(res.message || "入驻失败，请重试");
              }
            })
            .catch(() => {
              this.$message.error("注册失败，请稍后重试");
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
.merchant-register-container {
  width: 100%;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px 0;
}

.register-box {
  width: 500px;
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
  font-size: 14px;
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
