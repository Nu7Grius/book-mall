<template>
  <view class="edit-profile-container">
    <view class="form-section">
      <view class="avatar-section" @click="changeAvatar">
        <text class="label">头像</text>
        <view class="avatar-wrapper">
          <image
            class="avatar"
            :src="form.avatar || '/static/icons/user.png'"
            mode="aspectFill"
          ></image>
          <text class="arrow">></text>
        </view>
      </view>
    </view>

    <view class="form-section">
      <view class="form-item">
        <text class="label">用户名</text>
        <input
          class="input"
          v-model="form.username"
          placeholder="请输入用户名"
          disabled
        />
      </view>
      <view class="form-item">
        <text class="label">真实姓名</text>
        <input
          class="input"
          v-model="form.realName"
          placeholder="请输入真实姓名"
        />
      </view>
      <view class="form-item">
        <text class="label">手机号</text>
        <input
          class="input"
          v-model="form.phone"
          type="number"
          maxlength="11"
          placeholder="请输入手机号"
        />
      </view>
      <view class="form-item">
        <text class="label">邮箱</text>
        <input
          class="input"
          v-model="form.email"
          type="text"
          placeholder="请输入邮箱"
        />
      </view>
      <view class="form-item">
        <text class="label">性别</text>
        <picker
          mode="selector"
          :range="genderOptions"
          range-key="label"
          :value="form.gender"
          @change="onGenderChange"
        >
          <view class="picker-value">
            {{ genderOptions[form.gender].label }}
            <text class="picker-arrow">▼</text>
          </view>
        </picker>
      </view>
      <view class="form-item">
        <text class="label">年龄</text>
        <input
          class="input"
          v-model="form.age"
          type="number"
          maxlength="3"
          placeholder="请输入年龄"
        />
      </view>
    </view>

    <view class="btn-wrapper">
      <button class="btn-save" @click="saveProfile">保存</button>
    </view>
  </view>
</template>

<script>
import {
  getUserInfo,
  getUserInfoById,
  updateUserInfo,
  uploadAvatar,
} from "../../api/user.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      form: {
        id: null,
        username: "",
        realName: "",
        phone: "",
        email: "",
        avatar: "",
        gender: 0,
        age: "",
      },
      genderOptions: [
        { label: "保密", value: 0 },
        { label: "男", value: 1 },
        { label: "女", value: 2 },
      ],
    };
  },
  onLoad() {
    const userInfo = uni.getStorageSync("userInfo");
    if (userInfo && userInfo.id) {
      this.loadUserInfo(userInfo.id);
    }
  },
  methods: {
    async loadUserInfo(userId) {
      try {
        const res = await getUserInfoById(userId);
        if (res.code === 200) {
          let genderIndex = 0;
          if (res.data.gender === "男") genderIndex = 1;
          else if (res.data.gender === "女") genderIndex = 2;

          this.form = {
            id: res.data.id,
            username: res.data.username,
            realName: res.data.realName || "",
            phone: res.data.phone || "",
            email: res.data.email || "",
            avatar: res.data.avatar ? getImageUrl(res.data.avatar) : "",
            gender: genderIndex,
            age: res.data.age || "",
          };
        }
      } catch (error) {
        console.error("加载用户信息失败:", error);
      }
    },
    changeAvatar() {
      uni.chooseImage({
        count: 1,
        sizeType: ["compressed"],
        sourceType: ["album", "camera"],
        success: (res) => {
          const tempFilePath = res.tempFilePaths[0];
          this.uploadAvatar(tempFilePath);
        },
      });
    },
    async uploadAvatar(filePath) {
      uni.showLoading({ title: "上传中..." });
      try {
        const res = await uploadAvatar(filePath);
        if (res.code === 200) {
          this.form.avatar = getImageUrl(res.data);
          uni.showToast({
            title: "头像上传成功",
            icon: "success",
          });
        }
      } catch (error) {
        console.error("上传头像失败:", error);
      } finally {
        uni.hideLoading();
      }
    },
    onGenderChange(e) {
      this.form.gender = parseInt(e.detail.value);
    },
    async saveProfile() {
      let genderText = "未知";
      if (this.form.gender === 1) genderText = "男";
      else if (this.form.gender === 2) genderText = "女";

      uni.showLoading({ title: "保存中..." });
      try {
        const res = await updateUserInfo({
          id: this.form.id,
          realName: this.form.realName,
          phone: this.form.phone,
          email: this.form.email,
          gender: genderText,
          age: this.form.age ? parseInt(this.form.age) : null,
        });

        if (res.code === 200) {
          uni.showToast({
            title: "保存成功",
            icon: "success",
          });
          setTimeout(() => {
            uni.navigateBack();
          }, 1500);
        }
      } catch (error) {
        console.error("保存失败:", error);
      } finally {
        uni.hideLoading();
      }
    },
  },
};
</script>

<style scoped>
.edit-profile-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 40rpx;
}

.form-section {
  background-color: #fff;
  margin-bottom: 20rpx;
}

.avatar-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1px solid #f5f5f5;
}

.avatar-section .label {
  font-size: 28rpx;
  color: #333;
}

.avatar-wrapper {
  display: flex;
  align-items: center;
}

.avatar {
  width: 100rpx;
  height: 100rpx;
  border-radius: 50%;
  background-color: #eee;
  margin-right: 16rpx;
}

.arrow {
  color: #999;
  font-size: 28rpx;
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
  width: 150rpx;
}

.input {
  flex: 1;
  font-size: 28rpx;
  color: #333;
  text-align: right;
}

.picker-value {
  flex: 1;
  font-size: 28rpx;
  color: #333;
  text-align: right;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding: 8rpx 0;
}

.picker-arrow {
  margin-left: 8rpx;
  color: #999;
  font-size: 28rpx;
  font-weight: bold;
}

picker {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.btn-wrapper {
  padding: 40rpx 30rpx;
}

.btn-save {
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
