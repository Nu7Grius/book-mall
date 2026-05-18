<template>
  <view class="register-container">
    <view class="register-header">
      <text class="title">用户注册</text>
      <text class="subtitle">创建您的 OpenBook 账号</text>
    </view>

    <view class="register-form">
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
            placeholder="请输入密码（6-20位）"
            placeholder-class="placeholder"
          />
          <button class="password-toggle" @click="showPassword = !showPassword">
            {{ showPassword ? "隐藏" : "显示" }}
          </button>
        </view>
      </view>

      <view class="form-item">
        <view class="label">确认密码</view>
        <view class="input-wrapper">
          <input
            class="input"
            v-model="confirmPassword"
            :password="!showConfirmPassword"
            placeholder="请再次输入密码"
            placeholder-class="placeholder"
          />
          <button
            class="password-toggle"
            @click="showConfirmPassword = !showConfirmPassword"
          >
            {{ showConfirmPassword ? "隐藏" : "显示" }}
          </button>
        </view>
      </view>

      <view class="form-item">
        <view class="label">真实姓名</view>
        <input
          class="input"
          v-model="formData.realName"
          placeholder="请输入真实姓名"
          placeholder-class="placeholder"
        />
      </view>

      <view class="form-item">
        <view class="label">手机号</view>
        <input
          class="input"
          v-model="formData.phone"
          type="number"
          maxlength="11"
          placeholder="请输入手机号"
          placeholder-class="placeholder"
        />
      </view>

      <view class="form-item">
        <view class="label">邮箱</view>
        <input
          class="input"
          v-model="formData.email"
          type="text"
          placeholder="请输入邮箱（选填）"
          placeholder-class="placeholder"
        />
      </view>

      <button class="btn-register" @click="handleRegister" :loading="loading">
        {{ loading ? "注册中..." : "注册" }}
      </button>

      <view class="login-link">
        <text>已有账号？</text>
        <text class="link" @click="goToLogin">立即登录</text>
      </view>
    </view>
  </view>
</template>

<script>
import { userRegister } from "../../api/user.js";

export default {
  data() {
    return {
      formData: {
        username: "",
        password: "",
        realName: "",
        phone: "",
        email: "",
      },
      confirmPassword: "",
      showPassword: false,
      showConfirmPassword: false,
      loading: false,
    };
  },
  methods: {
    async handleRegister() {
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
      if (this.formData.password.length < 6) {
        uni.showToast({
          title: "密码至少6位",
          icon: "none",
        });
        return;
      }
      if (this.formData.password !== this.confirmPassword) {
        uni.showToast({
          title: "两次密码不一致",
          icon: "none",
        });
        return;
      }
      if (!this.formData.realName) {
        uni.showToast({
          title: "请输入真实姓名",
          icon: "none",
        });
        return;
      }
      if (!this.formData.phone) {
        uni.showToast({
          title: "请输入手机号",
          icon: "none",
        });
        return;
      }
      if (!/^1[3-9]\d{9}$/.test(this.formData.phone)) {
        uni.showToast({
          title: "手机号格式不正确",
          icon: "none",
        });
        return;
      }

      this.loading = true;
      try {
        const res = await userRegister(this.formData);
        if (res.code === 200) {
          uni.showToast({
            title: "注册成功",
            icon: "success",
          });
          setTimeout(() => {
            uni.navigateBack();
          }, 1500);
        }
      } catch (error) {
        console.error("注册失败:", error);
      } finally {
        this.loading = false;
      }
    },
    goToLogin() {
      uni.navigateBack();
    },
  },
};
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.register-header {
  background: linear-gradient(135deg, #15803d 0%, #166534 100%);
  color: #fff;
  padding: 60rpx 40rpx 100rpx;
}

.title {
  display: block;
  font-size: 48rpx;
  font-weight: bold;
  margin-bottom: 16rpx;
}

.subtitle {
  display: block;
  font-size: 28rpx;
  opacity: 0.9;
}

.register-form {
  background-color: #fff;
  border-radius: 24rpx 24rpx 0 0;
  margin-top: -40rpx;
  padding: 60rpx 40rpx;
}

.form-item {
  margin-bottom: 30rpx;
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

.btn-register {
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

.btn-register:active {
  opacity: 0.9;
}

.login-link {
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
