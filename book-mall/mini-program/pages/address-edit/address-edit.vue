<template>
  <view class="address-edit-container">
    <view class="form">
      <view class="form-item">
        <view class="label">收货人</view>
        <input
          class="input"
          v-model="formData.receiverName"
          placeholder="请输入收货人姓名"
          placeholder-class="placeholder"
        />
      </view>

      <view class="form-item">
        <view class="label">手机号</view>
        <input
          class="input"
          v-model="formData.receiverPhone"
          type="number"
          maxlength="11"
          placeholder="请输入手机号"
          placeholder-class="placeholder"
        />
      </view>

      <view class="form-item">
        <view class="label">所在地区</view>
        <picker mode="region" :value="region" @change="onRegionChange">
          <view class="picker-value">
            <text v-if="region.length > 0">{{ region.join(" ") }}</text>
            <text class="placeholder" v-else>请选择省市区</text>
            <text class="arrow">▼</text>
          </view>
        </picker>
      </view>

      <view class="form-item">
        <view class="label">详细地址</view>
        <textarea
          class="textarea"
          v-model="formData.detailAddress"
          placeholder="请输入详细地址"
          placeholder-class="placeholder"
          maxlength="200"
        />
      </view>

      <view class="form-item">
        <view class="label">设为默认地址</view>
        <switch
          :checked="formData.isDefault"
          @change="onDefaultChange"
          color="#15803d"
        />
      </view>
    </view>

    <button class="btn-save" @click="saveAddress" :loading="loading">
      {{ loading ? "保存中..." : "保存" }}
    </button>
  </view>
</template>

<script>
import {
  getAddressDetail,
  addAddress,
  updateAddress,
} from "../../api/address.js";

export default {
  data() {
    return {
      addressId: null,
      formData: {
        receiverName: "",
        receiverPhone: "",
        province: "",
        city: "",
        district: "",
        detailAddress: "",
        isDefault: false,
      },
      region: [],
      loading: false,
    };
  },
  onLoad(options) {
    if (options.id) {
      this.addressId = options.id;
      uni.setNavigationBarTitle({
        title: "编辑地址",
      });
      this.loadAddressDetail();
    } else {
      uni.setNavigationBarTitle({
        title: "新增地址",
      });
    }
  },
  methods: {
    async loadAddressDetail() {
      try {
        const res = await getAddressDetail(this.addressId);
        if (res.code === 200) {
          this.formData = res.data;
          this.region = [
            this.formData.province,
            this.formData.city,
            this.formData.district,
          ];
        }
      } catch (error) {
        console.error("加载地址详情失败:", error);
      }
    },
    onRegionChange(e) {
      const values = e.detail.value;
      this.region = values;
      this.formData.province = values[0];
      this.formData.city = values[1];
      this.formData.district = values[2];
    },
    onDefaultChange(e) {
      this.formData.isDefault = e.detail.value;
    },
    async saveAddress() {
      if (!this.formData.receiverName) {
        uni.showToast({
          title: "请输入收货人姓名",
          icon: "none",
        });
        return;
      }
      if (!this.formData.receiverPhone) {
        uni.showToast({
          title: "请输入手机号",
          icon: "none",
        });
        return;
      }
      if (!/^1[3-9]\d{9}$/.test(this.formData.receiverPhone)) {
        uni.showToast({
          title: "手机号格式不正确",
          icon: "none",
        });
        return;
      }
      if (!this.formData.province) {
        uni.showToast({
          title: "请选择所在地区",
          icon: "none",
        });
        return;
      }
      if (!this.formData.detailAddress) {
        uni.showToast({
          title: "请输入详细地址",
          icon: "none",
        });
        return;
      }

      this.loading = true;
      try {
        let res;
        if (this.addressId) {
          this.formData.id = this.addressId;
          res = await updateAddress(this.formData);
        } else {
          res = await addAddress(this.formData);
        }

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
        console.error("保存地址失败:", error);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.address-edit-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20rpx;
}

.form {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 0 30rpx;
}

.form-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx 0;
  border-bottom: 1px solid #f5f5f5;
}

.form-item:last-child {
  border-bottom: none;
}

.label {
  font-size: 28rpx;
  color: #333;
  flex-shrink: 0;
}

.input {
  flex: 1;
  text-align: right;
  font-size: 28rpx;
  margin-left: 20rpx;
}

.textarea {
  flex: 1;
  text-align: left;
  font-size: 28rpx;
  margin-left: 20rpx;
  height: 120rpx;
  padding: 16rpx;
  background-color: #f8f8f8;
  border-radius: 8rpx;
  border: 1px solid #e5e5e5;
  box-sizing: border-box;
}

.picker-value {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  font-size: 28rpx;
  color: #333;
  margin-left: 20rpx;
}

.arrow {
  font-size: 20rpx;
  color: #999;
  margin-left: 12rpx;
}

.placeholder {
  color: #999;
}

.btn-save {
  margin: 60rpx 30rpx;
  height: 88rpx;
  background: linear-gradient(135deg, #15803d 0%, #166534 100%);
  color: #fff;
  border-radius: 44rpx;
  font-size: 32rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
}
</style>
