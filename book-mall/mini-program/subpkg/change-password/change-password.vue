<template>
  <view class="change-password-container">
    <view class="form-section">
      <view class="form-item">
        <text class="label">原密码</text>
        <input
          class="input"
          v-model="form.oldPassword"
          type="password"
          placeholder="请输入原密码"
          password
        />
      </view>
      <view class="form-item">
        <text class="label">新密码</text>
        <input
          class="input"
          v-model="form.newPassword"
          type="password"
          placeholder="请输入新密码"
          password
        />
      </view>
      <view class="form-item">
        <text class="label">确认密码</text>
        <input
          class="input"
          v-model="form.confirmPassword"
          type="password"
          placeholder="请再次输入新密码"
          password
        />
      </view>
    </view>

    <view class="tips">
      <text class="tip-text">密码要求：</text>
      <text class="tip-text">1. 密码长度至少6位</text>
      <text class="tip-text">2. 新密码不能与原密码相同</text>
    </view>

    <view class="btn-wrapper">
      <button class="btn-submit" @click="submitPassword">确认修改</button>
    </view>
  </view>
</template>

<script>
import { updatePassword } from "../../api/user.js";

export default {
  data() {
    return {
      form: {
        oldPassword: "",
        newPassword: "",
        confirmPassword: "",
      },
    };
  },
  methods: {
    async submitPassword() {
      if (!this.form.oldPassword) {
        uni.showToast({ title: "请输入原密码", icon: "none" });
        return;
      }

      if (!this.form.newPassword) {
        uni.showToast({ title: "请输入新密码", icon: "none" });
        return;
      }

      if (this.form.newPassword.length < 6) {
        uni.showToast({ title: "新密码长度至少6位", icon: "none" });
        return;
      }

      if (this.form.newPassword !== this.form.confirmPassword) {
        uni.showToast({ title: "两次输入的密码不一致", icon: "none" });
        return;
      }

      if (this.form.oldPassword === this.form.newPassword) {
        uni.showToast({ title: "新密码不能与原密码相同", icon: "none" });
        return;
      }

      const userInfo = uni.getStorageSync("userInfo");
      if (!userInfo || !userInfo.id) {
        uni.showToast({ title: "用户未登录", icon: "none" });
        return;
      }

      uni.showLoading({ title: "提交中..." });
      try {
        const res = await updatePassword({
          userId: userInfo.id,
          oldPassword: this.form.oldPassword,
          newPassword: this.form.newPassword,
        });

        if (res.code === 200) {
          uni.showToast({
            title: "密码修改成功",
            icon: "success",
          });
          setTimeout(() => {
            uni.navigateBack();
          }, 1500);
        }
      } catch (error) {
        console.error("修改密码失败:", error);
      } finally {
        uni.hideLoading();
      }
    },
  },
};
</script>

<style scoped>
.change-password-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 40rpx;
}

.form-section {
  background-color: #fff;
}

.form-item {
  display: flex;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1px solid #f5f5f5;
}

.form-item:last-child {
  border-bottom: none;
}

.form-item .label {
  font-size: 28rpx;
  color: #333;
  width: 180rpx;
}

.input {
  flex: 1;
  font-size: 28rpx;
  color: #333;
}

.tips {
  padding: 30rpx;
}

.tip-text {
  display: block;
  font-size: 24rpx;
  color: #999;
  line-height: 1.8;
}

.btn-wrapper {
  padding: 40rpx 30rpx;
}

.btn-submit {
  width: 100%;
  height: 88rpx;
  background-color: #15803d;
  color: #fff;
  border-radius: 44rpx;
  font-size: 30rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
}
</style>
