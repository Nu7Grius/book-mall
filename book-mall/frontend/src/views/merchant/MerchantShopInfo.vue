<template>
  <div class="merchant-shop-info">
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-setting"></i>
            店铺设置
          </h2>
          <p class="header-subtitle">完善店铺信息，提升用户信任度</p>
        </div>
      </div>
    </el-card>

    <el-row :gutter="20">
      <el-col :xs="24" :lg="16">
        <el-card class="form-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-office-building"></i> 店铺基本信息</span>
          </div>

          <el-form
            ref="shopForm"
            :model="shopForm"
            :rules="rules"
            label-width="120px"
            class="shop-form"
          >
            <el-form-item label="店铺名称" prop="shopName">
              <el-input
                v-model="shopForm.shopName"
                placeholder="请输入店铺名称"
                prefix-icon="el-icon-s-shop"
              ></el-input>
            </el-form-item>

            <el-form-item label="店铺Logo" prop="logo">
              <el-upload
                class="logo-uploader"
                action="#"
                :show-file-list="false"
                :before-upload="beforeLogoUpload"
              >
                <img
                  v-if="shopForm.logo"
                  :src="getImageUrl(shopForm.logo)"
                  class="logo"
                />
                <i v-else class="el-icon-plus logo-uploader-icon">
                  <div class="upload-text">上传Logo</div>
                </i>
              </el-upload>
              <div class="upload-tip">
                <i class="el-icon-info"></i> 建议尺寸：200x200，支持 JPG、PNG
                格式
              </div>
            </el-form-item>

            <el-form-item label="店铺简介" prop="description">
              <el-input
                v-model="shopForm.description"
                type="textarea"
                :rows="4"
                placeholder="请输入店铺简介"
                maxlength="200"
                show-word-limit
              ></el-input>
            </el-form-item>

            <el-divider content-position="left">
              <i class="el-icon-phone-outline"></i> 联系方式
            </el-divider>

            <el-form-item label="联系人" prop="realName">
              <el-input
                v-model="shopForm.realName"
                placeholder="请输入联系人姓名"
                prefix-icon="el-icon-user"
              ></el-input>
            </el-form-item>

            <el-form-item label="联系电话" prop="phone">
              <el-input
                v-model="shopForm.phone"
                placeholder="请输入联系电话"
                prefix-icon="el-icon-phone"
              ></el-input>
            </el-form-item>

            <el-form-item label="店铺地址" prop="address">
              <el-input
                v-model="shopForm.address"
                type="textarea"
                :rows="2"
                placeholder="请输入详细地址"
                prefix-icon="el-icon-location"
              ></el-input>
            </el-form-item>

            <el-divider content-position="left">
              <i class="el-icon-bank-card"></i> 银行账户
            </el-divider>

            <el-form-item label="开户银行" prop="bankName">
              <el-select
                v-model="shopForm.bankName"
                placeholder="请选择开户银行"
                prefix-icon="el-icon-postcard"
                style="width: 100%"
              >
                <el-option
                  label="中国工商银行"
                  value="中国工商银行"
                ></el-option>
                <el-option
                  label="中国农业银行"
                  value="中国农业银行"
                ></el-option>
                <el-option label="中国银行" value="中国银行"></el-option>
                <el-option
                  label="中国建设银行"
                  value="中国建设银行"
                ></el-option>
                <el-option label="招商银行" value="招商银行"></el-option>
                <el-option label="交通银行" value="交通银行"></el-option>
                <el-option
                  label="中国邮政储蓄银行"
                  value="中国邮政储蓄银行"
                ></el-option>
                <el-option label="华夏银行" value="华夏银行"></el-option>
                <el-option label="民生银行" value="民生银行"></el-option>
                <el-option label="平安银行" value="平安银行"></el-option>
              </el-select>
            </el-form-item>

            <el-form-item label="银行账号" prop="bankAccount">
              <el-input
                v-model="shopForm.bankAccount"
                placeholder="请输入银行账号"
                prefix-icon="el-icon-money"
                maxlength="19"
                show-word-limit
              ></el-input>
            </el-form-item>

            <el-form-item label="开户姓名" prop="bankAccountName">
              <el-input
                v-model="shopForm.bankAccountName"
                placeholder="请输入开户姓名"
                prefix-icon="el-icon-user-solid"
                maxlength="20"
                show-word-limit
              ></el-input>
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                size="medium"
                @click="handleSave"
                :loading="loading"
                class="save-btn"
              >
                <i class="el-icon-check"></i> 保存修改
              </el-button>
              <el-button size="medium" @click="handleReset" class="reset-btn">
                <i class="el-icon-refresh"></i> 重置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>

      <el-col :xs="24" :lg="8">
        <el-card class="status-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-data-line"></i> 店铺运营状态</span>
          </div>

          <div class="status-info">
            <div class="status-item">
              <div class="status-label">
                <i class="el-icon-shop"></i> 店铺状态
              </div>
              <div class="status-value">
                <el-switch
                  v-model="shopForm.status"
                  active-text="营业中"
                  inactive-text="休息中"
                  @change="handleStatusChange"
                ></el-switch>
              </div>
            </div>

            <div class="status-item">
              <div class="status-label">
                <i class="el-icon-calendar"></i> 入驻时间
              </div>
              <div class="status-value">{{ shopForm.createTime }}</div>
            </div>

            <div class="status-item">
              <div class="status-label">
                <i class="el-icon-star-on"></i> 店铺评分
              </div>
              <div class="status-value">
                <el-rate v-model="shopForm.rating" disabled show-score>
                </el-rate>
              </div>
            </div>

            <div class="status-item highlight">
              <div class="status-label">
                <i class="el-icon-sell"></i> 累计销售额
              </div>
              <div class="status-value">¥{{ shopForm.totalSales }}</div>
            </div>

            <div class="status-item highlight">
              <div class="status-label">
                <i class="el-icon-document"></i> 累计订单数
              </div>
              <div class="status-value">{{ shopForm.totalOrders }} 笔</div>
            </div>
          </div>
        </el-card>

        <el-card class="security-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-lock"></i> 账号安全</span>
          </div>

          <div class="security-info">
            <div class="security-item">
              <div class="security-label">
                <i class="el-icon-key"></i> 登录密码
              </div>
              <div class="security-action">
                <el-button
                  size="small"
                  @click="showPasswordDialog"
                  icon="el-icon-edit"
                >
                  修改密码
                </el-button>
              </div>
            </div>

            <div class="security-item">
              <div class="security-label">
                <i class="el-icon-mobile-phone"></i> 联系方式
              </div>
              <div class="security-action">
                <span class="bound-phone">{{ shopForm.phone }}</span>
                <el-button size="small" type="text" @click="showPhoneDialog">
                  修改
                </el-button>
              </div>
            </div>
          </div>
        </el-card>

        <el-card class="tips-card">
          <div slot="header" class="card-header">
            <span><i class="el-icon-info"></i> 温馨提示</span>
          </div>
          <div class="tips">
            <div class="tip-item">
              <i class="el-icon-circle-check"></i>
              <span>请确保店铺信息真实有效</span>
            </div>
            <div class="tip-item">
              <i class="el-icon-circle-check"></i>
              <span>银行账户信息用于结算货款</span>
            </div>
            <div class="tip-item">
              <i class="el-icon-circle-check"></i>
              <span>联系电话用于平台与您联系</span>
            </div>
            <div class="tip-item">
              <i class="el-icon-circle-check"></i>
              <span>店铺营业状态将展示给用户</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-dialog
      title="修改密码"
      :visible.sync="passwordDialogVisible"
      width="500px"
      class="password-dialog"
    >
      <el-form
        ref="passwordForm"
        :model="passwordForm"
        :rules="passwordRules"
        label-width="100px"
      >
        <el-form-item label="原密码" prop="oldPassword">
          <el-input
            v-model="passwordForm.oldPassword"
            type="password"
            placeholder="请输入原密码"
            prefix-icon="el-icon-lock"
          ></el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="passwordForm.newPassword"
            type="password"
            placeholder="请输入新密码"
            prefix-icon="el-icon-lock"
          ></el-input>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="passwordForm.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            prefix-icon="el-icon-lock"
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="passwordDialogVisible = false" size="medium"
          >取 消</el-button
        >
        <el-button type="primary" @click="handleChangePassword" size="medium">
          <i class="el-icon-check"></i> 确 定
        </el-button>
      </div>
    </el-dialog>

    <el-dialog
      title="修改联系方式"
      :visible.sync="phoneDialogVisible"
      width="450px"
      class="phone-dialog"
    >
      <el-form
        :model="phoneForm"
        :rules="phoneRules"
        ref="phoneFormRef"
        label-width="100px"
      >
        <el-form-item label="手机号" prop="newPhone">
          <el-input
            v-model="phoneForm.newPhone"
            placeholder="请输入手机号"
            maxlength="11"
            prefix-icon="el-icon-mobile-phone"
          ></el-input>
        </el-form-item>
        <el-form-item label="验证码" prop="code">
          <el-input
            v-model="phoneForm.code"
            placeholder="请输入验证码"
            style="width: 180px"
            maxlength="6"
            prefix-icon="el-icon-message"
          ></el-input>
          <el-button
            @click="sendVerifyCode"
            :disabled="codeSending || codeCountdown > 0"
            class="verify-btn"
          >
            {{ codeCountdown > 0 ? codeCountdown + "s" : "发送验证码" }}
          </el-button>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="phoneDialogVisible = false" size="medium"
          >取 消</el-button
        >
        <el-button
          type="primary"
          @click="handleChangePhone"
          :loading="phoneLoading"
          size="medium"
        >
          <i class="el-icon-check"></i> 确 定
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "MerchantShopInfo",
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error("两次输入密码不一致"));
      } else {
        callback();
      }
    };

    return {
      shopForm: {
        shopName: "",
        logo: "",
        description: "",
        realName: "",
        phone: "",
        address: "",
        bankName: "",
        bankAccount: "",
        bankAccountName: "",
        status: true,
        createTime: "",
        rating: 4.5,
        totalSales: "68,520.00",
        totalOrders: 1865,
      },
      loading: false,
      rules: {
        shopName: [
          { required: true, message: "请输入店铺名称", trigger: "blur" },
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
        address: [
          { required: true, message: "请输入店铺地址", trigger: "blur" },
        ],
        bankName: [
          { required: true, message: "请选择开户银行", trigger: "change" },
        ],
        bankAccount: [
          { required: true, message: "请输入银行账号", trigger: "blur" },
          {
            pattern: /^\d{16,19}$/,
            message: "银行账号必须为16-19位数字",
            trigger: "blur",
          },
        ],
        bankAccountName: [
          { required: true, message: "请输入开户姓名", trigger: "blur" },
          {
            min: 2,
            max: 20,
            message: "姓名长度在2-20个字符",
            trigger: "blur",
          },
        ],
      },
      passwordDialogVisible: false,
      passwordForm: {
        oldPassword: "",
        newPassword: "",
        confirmPassword: "",
      },
      passwordRules: {
        oldPassword: [
          { required: true, message: "请输入原密码", trigger: "blur" },
        ],
        newPassword: [
          { required: true, message: "请输入新密码", trigger: "blur" },
          { min: 6, message: "密码长度至少6个字符", trigger: "blur" },
        ],
        confirmPassword: [
          { required: true, message: "请再次输入密码", trigger: "blur" },
          { validator: validateConfirmPassword, trigger: "blur" },
        ],
      },
      phoneDialogVisible: false,
      phoneForm: {
        newPhone: "",
        code: "",
      },
      phoneRules: {
        newPhone: [
          { required: true, message: "请输入手机号", trigger: "blur" },
          {
            pattern: /^1[3-9]\d{9}$/,
            message: "请输入正确的手机号码",
            trigger: "blur",
          },
        ],
        code: [
          { required: true, message: "请输入验证码", trigger: "blur" },
          { len: 6, message: "验证码为6位数字", trigger: "blur" },
        ],
      },
      codeSending: false,
      codeCountdown: 0,
      phoneLoading: false,
    };
  },
  mounted() {
    this.loadShopInfo();
  },
  methods: {
    loadShopInfo() {
      const merchantInfo = localStorage.getItem("merchantInfo");
      if (merchantInfo) {
        const info = JSON.parse(merchantInfo);
        this.shopForm = {
          ...this.shopForm,
          shopName: info.shopName || "我的书店",
          realName: info.realName || "",
          phone: info.phone || "",
          address: info.address || "",
          logo: info.logo || "",
          description: info.description || "",
          bankName: info.bankName || "",
          bankAccount: info.bankAccount || "",
          bankAccountName: info.bankAccountName || "",
          status: info.status === 1 || info.status === true,
          createTime: info.createTime || new Date().toLocaleDateString(),
        };

        this.loadMerchantStatistics();
      } else {
        this.shopForm.createTime = new Date().toLocaleDateString();
      }
    },
    loadMerchantStatistics() {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) {
        return;
      }

      this.$http
        .get("/merchant/statistics", {
          params: { merchantId: parseInt(merchantId) },
        })
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.shopForm.rating = res.data.rating || 0;
            this.shopForm.totalSales = res.data.totalSales
              ? parseFloat(res.data.totalSales).toFixed(2)
              : "0.00";
            this.shopForm.totalOrders = res.data.totalOrders || 0;
          }
        })
        .catch(() => {});
    },
    beforeLogoUpload(file) {
      const isJPG = file.type === "image/jpeg" || file.type === "image/png";
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (!isJPG) {
        this.$message.error("上传Logo只能是 JPG/PNG 格式!");
        return false;
      }
      if (!isLt2M) {
        this.$message.error("上传Logo大小不能超过 2MB!");
        return false;
      }

      const formData = new FormData();
      formData.append("file", file);

      this.$http
        .post("/upload/image", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        })
        .then((res) => {
          if (res.code === 200) {
            this.shopForm.logo = res.data;
            this.$message.success("Logo上传成功");
          } else {
            this.$message.error(res.message || "Logo上传失败");
          }
        })
        .catch(() => {
          this.$message.error("Logo上传失败，请重试");
        });

      return false;
    },
    handleSave() {
      this.$refs.shopForm.validate((valid) => {
        if (valid) {
          this.loading = true;

          // 从localStorage获取商家ID
          const merchantId = localStorage.getItem("merchantId");
          if (!merchantId) {
            this.$message.error("无法获取商家信息，请重新登录");
            this.loading = false;
            return;
          }

          // 添加商家ID到请求数据，排除createTime（由后端自动生成）
          const submitData = {
            id: parseInt(merchantId),
            shopName: this.shopForm.shopName,
            logo: this.shopForm.logo,
            description: this.shopForm.description,
            realName: this.shopForm.realName,
            phone: this.shopForm.phone,
            address: this.shopForm.address,
            bankName: this.shopForm.bankName,
            bankAccount: this.shopForm.bankAccount,
            bankAccountName: this.shopForm.bankAccountName,
            status: this.shopForm.status ? 1 : 0,
          };

          this.$http
            .post("/merchant/shop/update", submitData)
            .then((res) => {
              if (res.code === 200) {
                // 更新本地存储的商家信息
                const merchantInfo = localStorage.getItem("merchantInfo");
                if (merchantInfo) {
                  const info = JSON.parse(merchantInfo);
                  Object.assign(info, this.shopForm);
                  localStorage.setItem("merchantInfo", JSON.stringify(info));
                }
                // 👇 触发自定义事件通知布局组件更新
                window.dispatchEvent(new Event("merchant-info-updated"));
                this.$message.success("保存成功");
              } else {
                this.$message.error(res.message || "保存失败");
              }
            })
            .catch(() => {
              this.$message.error("保存失败，请稍后重试");
            })
            .finally(() => {
              this.loading = false;
            });
        }
      });
    },
    handleReset() {
      this.$refs.shopForm.resetFields();
      this.loadShopInfo();
    },
    handleStatusChange(value) {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) {
        this.$message.error("无法获取商家信息，请重新登录");
        return;
      }

      this.$http
        .post("/merchant/shop/update", {
          id: parseInt(merchantId),
          status: value ? 1 : 0,
        })
        .then((res) => {
          if (res.code === 200) {
            const merchantInfo = localStorage.getItem("merchantInfo");
            if (merchantInfo) {
              const info = JSON.parse(merchantInfo);
              info.status = value;
              localStorage.setItem("merchantInfo", JSON.stringify(info));
            }
            window.dispatchEvent(new Event("merchant-info-updated"));
            this.$message.success(
              value ? "店铺已设置为营业中" : "店铺已设置为休息中"
            );
          } else {
            this.$message.error(res.message || "状态更新失败");
          }
        })
        .catch(() => {
          this.$message.error("状态更新失败，请稍后重试");
        });
    },
    showPasswordDialog() {
      this.passwordForm = {
        oldPassword: "",
        newPassword: "",
        confirmPassword: "",
      };
      this.passwordDialogVisible = true;
    },
    handleChangePassword() {
      this.$refs.passwordForm.validate((valid) => {
        if (valid) {
          const merchantId = localStorage.getItem("merchantId");
          this.$http
            .put("/user/password", {
              userId: parseInt(merchantId),
              oldPassword: this.passwordForm.oldPassword,
              newPassword: this.passwordForm.newPassword,
            })
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("密码修改成功");
                this.passwordDialogVisible = false;
              } else {
                this.$message.error(res.message || "密码修改失败");
              }
            })
            .catch(() => {
              this.$message.error("密码修改失败，请稍后重试");
            });
        }
      });
    },
    showPhoneDialog() {
      this.phoneForm = {
        newPhone: "",
        code: "",
      };
      this.phoneDialogVisible = true;
    },
    sendVerifyCode() {
      if (
        !this.phoneForm.newPhone ||
        !/^1[3-9]\d{9}$/.test(this.phoneForm.newPhone)
      ) {
        this.$message.error("请输入正确的手机号码");
        return;
      }

      this.codeSending = true;
      this.$http
        .post("/user/send-verify-code", {
          phone: this.phoneForm.newPhone,
          type: "change_phone",
        })
        .then((res) => {
          if (res.code === 200) {
            this.$message.success("验证码已发送");
            this.codeCountdown = 30;
            const timer = setInterval(() => {
              this.codeCountdown--;
              if (this.codeCountdown <= 0) {
                clearInterval(timer);
              }
            }, 1000);
          } else {
            this.$message.error(res.message || "验证码发送失败");
          }
        })
        .catch(() => {
          this.$message.error("验证码发送失败，请稍后重试");
        })
        .finally(() => {
          this.codeSending = false;
        });
    },
    handleChangePhone() {
      this.$refs.phoneFormRef.validate((valid) => {
        if (valid) {
          this.phoneLoading = true;
          const merchantId = localStorage.getItem("merchantId");
          this.$http
            .put("/user/update-phone", {
              userId: parseInt(merchantId),
              newPhone: this.phoneForm.newPhone,
              verifyCode: this.phoneForm.code,
            })
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("联系方式修改成功");
                this.shopForm.phone = this.phoneForm.newPhone;
                const merchantInfo = localStorage.getItem("merchantInfo");
                if (merchantInfo) {
                  const info = JSON.parse(merchantInfo);
                  info.phone = this.phoneForm.newPhone;
                  localStorage.setItem("merchantInfo", JSON.stringify(info));
                }
                window.dispatchEvent(new Event("merchant-info-updated"));
                this.phoneDialogVisible = false;
              } else {
                this.$message.error(res.message || "联系方式修改失败");
              }
            })
            .catch(() => {
              this.$message.error("联系方式修改失败，请稍后重试");
            })
            .finally(() => {
              this.phoneLoading = false;
            });
        }
      });
    },
  },
};
</script>

<style scoped>
.merchant-shop-info {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  min-height: calc(100vh - 60px);
}

.header-card {
  margin-bottom: 20px;
  border: none;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.header-card ::v-deep .el-card__body {
  padding: 20px 25px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-title {
  margin: 0 0 5px 0;
  font-size: 24px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-subtitle {
  margin: 0;
  font-size: 14px;
  opacity: 0.9;
}

.form-card,
.status-card,
.security-card,
.tips-card {
  border: none;
  border-radius: 12px;
}

.form-card {
  margin-bottom: 20px;
}

.status-card,
.security-card,
.tips-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
}

.card-header i {
  color: #409eff;
}

.shop-form {
  padding: 10px 0;
}

.logo-uploader {
  border: 2px dashed #d9d9d9;
  border-radius: 8px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 120px;
  height: 120px;
  transition: all 0.3s;
}

.logo-uploader:hover {
  border-color: #409eff;
  background: #f5f7fa;
}

.logo-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
}

.logo {
  width: 120px;
  height: 120px;
  display: block;
  object-fit: cover;
}

.upload-text {
  font-size: 12px;
  margin-top: 5px;
}

.upload-tip {
  color: #909399;
  font-size: 12px;
  margin-top: 8px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.upload-tip i {
  color: #409eff;
}

.save-btn {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border: none;
  transition: all 0.3s;
}

.save-btn:hover {
  transform: scale(1.02);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.reset-btn {
  transition: all 0.3s;
}

.status-info {
  padding: 10px 0;
}

.status-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #f0f0f0;
  transition: all 0.3s;
}

.status-item:last-child {
  border-bottom: none;
}

.status-item:hover {
  background: #f5f7fa;
  padding-left: 10px;
}

.status-item.highlight {
  background: linear-gradient(135deg, #f0f9eb 0%, #e1f3d8 100%);
  border-radius: 8px;
  padding: 15px;
  margin: 5px 0;
}

.status-label {
  font-size: 14px;
  color: #606266;
  display: flex;
  align-items: center;
  gap: 8px;
}

.status-label i {
  color: #409eff;
  font-size: 16px;
}

.status-value {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}

.status-item.highlight .status-value {
  color: #67c23a;
  font-weight: 600;
  font-size: 16px;
}

.security-info {
  padding: 10px 0;
}

.security-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #f0f0f0;
}

.security-item:last-child {
  border-bottom: none;
}

.security-label {
  font-size: 14px;
  color: #333;
  display: flex;
  align-items: center;
  gap: 8px;
}

.security-label i {
  color: #409eff;
  font-size: 16px;
}

.security-action {
  display: flex;
  align-items: center;
  gap: 10px;
}

.bound-phone {
  font-size: 14px;
  color: #909399;
}

.tips {
  padding: 10px 0;
}

.tip-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 0;
  font-size: 14px;
  color: #606266;
  transition: all 0.3s;
}

.tip-item:hover {
  background: #f5f7fa;
  padding-left: 10px;
}

.tip-item i {
  color: #67c23a;
  font-size: 16px;
}

.password-dialog .el-input input,
.phone-dialog .el-input input {
  border-radius: 6px;
}

.verify-btn {
  margin-left: 10px;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
}
</style>
