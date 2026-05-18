<template>
  <view class="login-container">
    <view class="login-header">
      <image class="logo" src="/static/logo.png" mode="aspectFit"></image>
      <text class="title">OpenBook</text>
      <text class="subtitle">欢迎登录</text>
    </view>

    <view class="login-form">
      <view class="form-item">
        <view class="label">用户名</view>
        <input
          class="input"
          v-model="formData.username"
          placeholder="请输入用户名"
          placeholder-class="placeholder"
        />
      </view>

      <view class="form-item">
        <view class="label">密码</view>
        <view class="input-wrapper">
          <input
            class="input"
            v-model="formData.password"
            :password="!showPassword"
            placeholder="请输入密码"
            placeholder-class="placeholder"
          />
          <button class="password-toggle" @click="showPassword = !showPassword">
            {{ showPassword ? "隐藏" : "显示" }}
          </button>
        </view>
      </view>

      <button class="btn-login" @click="handleLogin" :loading="loading">
        {{ loading ? "登录中..." : "登录" }}
      </button>

      <view class="register-link">
        <text>还没有账号？</text>
        <text class="link" @click="goToRegister">立即注册</text>
      </view>
    </view>
  </view>
</template>

<script>
import { userLogin } from "../../api/user.js";

export default {
  data() {
    return {
      formData: {
        username: "",
        password: "",
      },
      showPassword: false,
      loading: false,
    };
  },
  methods: {
    async handleLogin() {
      if (!this.formData.username) {
        uni.showToast({
          title: "请输入用户名",
          icon: "none",
        });
        return;
      }
      if (!this.formData.password) {
        uni.showToast({
          title: "请输入密码",
          icon: "none",
        });
        return;
      }

      this.loading = true;
      try {
        const loginData = {
          ...this.formData,
          role: "user",
        };
        const res = await userLogin(loginData);
        if (res.code === 200) {
          uni.setStorageSync("userInfo", res.data);
          uni.showToast({
            title: "登录成功",
            icon: "success",
          });
          setTimeout(() => {
            uni.switchTab({
              url: "/pages/home/home",
            });
          }, 1500);
        }
      } catch (error) {
        console.error("登录失败:", error);
      } finally {
        this.loading = false;
      }
    },
    goToRegister() {
      uni.navigateTo({
        url: "/pages/register/register",
      });
    },
  },
};
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #15803d 0%, #166534 100%);
  padding: 60rpx 40rpx;
}

.login-header {
  text-align: center;
  padding: 80rpx 0;
}

.logo {
  width: 160rpx;
  height: 160rpx;
  border-radius: 80rpx;
  background-color: #fff;
  margin-bottom: 30rpx;
}

.title {
  display: block;
  font-size: 48rpx;
  font-weight: bold;
  color: #fff;
  margin-bottom: 16rpx;
}

.subtitle {
  display: block;
  font-size: 28rpx;
  color: rgba(255, 255, 255, 0.9);
}

.login-form {
  background-color: #fff;
  border-radius: 24rpx;
  padding: 60rpx 40rpx;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.1);
}

.form-item {
  margin-bottom: 40rpx;
  position: relative;
}

.label {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 16rpx;
  font-weight: 500;
}

.input-wrapper {
  position: relative;
  width: 100%;
}

.input {
  width: 100%;
  height: 88rpx;
  background-color: #f5f5f5;
  border-radius: 44rpx;
  padding: 0 120rpx 0 40rpx;
  font-size: 28rpx;
  box-sizing: border-box;
}

.placeholder {
  color: #999;
}

.password-toggle {
  position: absolute;
  right: 30rpx;
  top: 50%;
  transform: translateY(-50%);
  color: #15803d;
  font-size: 26rpx;
  padding: 10rpx 20rpx;
  background: rgba(21, 128, 61, 0.1);
  border-radius: 20rpx;
  border: none;
}

.btn-login {
  width: 100%;
  height: 88rpx;
  background: linear-gradient(135deg, #15803d 0%, #166534 100%);
  color: #fff;
  border-radius: 44rpx;
  font-size: 32rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 40rpx;
  border: none;
}

.btn-login:active {
  opacity: 0.9;
}

.register-link {
  text-align: center;
  margin-top: 40rpx;
  font-size: 28rpx;
  color: #666;
}

.link {
  color: #15803d;
  margin-left: 8rpx;
}
</style>
