<template>
  <div class="my-address">
    <el-card>
      <div slot="header">
        <span>我的收货地址</span>
        <el-button
          type="primary"
          size="small"
          style="float: right"
          @click="showAddDialog"
        >
          添加新地址
        </el-button>
      </div>

      <div class="address-list" v-if="addresses.length > 0">
        <div
          v-for="addr in addresses"
          :key="addr.id"
          class="address-item"
          :class="{ 'is-default': addr.isDefault === 1 }"
        >
          <div class="address-content">
            <div class="address-header">
              <span class="receiver">{{ addr.receiverName }}</span>
              <span class="phone">{{ addr.receiverPhone }}</span>
              <el-tag v-if="addr.isDefault === 1" size="mini" type="success"
                >默认</el-tag
              >
            </div>
            <div class="address-detail">
              {{ addr.province }} {{ addr.city }} {{ addr.district }}
              {{ addr.detailAddress }}
            </div>
          </div>
          <div class="address-actions">
            <el-button size="mini" type="text" @click="editAddress(addr)"
              >编辑</el-button
            >
            <el-button
              v-if="addr.isDefault !== 1"
              size="mini"
              type="text"
              @click="setDefault(addr.id)"
              >设为默认</el-button
            >
            <el-button size="mini" type="text" @click="deleteAddress(addr.id)"
              >删除</el-button
            >
          </div>
        </div>
      </div>

      <div v-else class="no-address">
        <p>暂无收货地址</p>
        <el-button type="primary" @click="showAddDialog"
          >添加第一个地址</el-button
        >
      </div>
    </el-card>

    <el-dialog
      :title="editingAddress ? '编辑地址' : '添加地址'"
      :visible.sync="addressDialogVisible"
      width="500px"
    >
      <el-form
        :model="addressForm"
        :rules="addressRules"
        ref="addressFormRef"
        label-width="80px"
      >
        <el-form-item label="收货人" prop="receiverName">
          <el-input
            v-model="addressForm.receiverName"
            maxlength="20"
          ></el-input>
        </el-form-item>
        <el-form-item label="联系电话" prop="receiverPhone">
          <el-input
            v-model="addressForm.receiverPhone"
            maxlength="11"
          ></el-input>
        </el-form-item>
        <el-form-item label="所在地区" prop="region">
          <el-cascader
            v-model="addressForm.region"
            :options="regionOptions"
            :props="{ value: 'label', label: 'label', children: 'children' }"
            placeholder="请选择省/市/区"
            style="width: 100%"
            @change="handleRegionChange"
          ></el-cascader>
        </el-form-item>
        <el-form-item label="详细地址" prop="detailAddress">
          <el-input
            v-model="addressForm.detailAddress"
            type="textarea"
            :rows="2"
            maxlength="100"
            show-word-limit
          ></el-input>
        </el-form-item>
        <el-form-item label="设为默认">
          <el-switch v-model="addressForm.isDefault"></el-switch>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="addressDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveAddress">保存</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import regions from "@/utils/regions.js";

export default {
  name: "MyAddress",
  data() {
    return {
      addresses: [],
      addressDialogVisible: false,
      editingAddress: null,
      regionOptions: regions,
      addressForm: {
        receiverName: "",
        receiverPhone: "",
        province: "",
        city: "",
        district: "",
        region: [],
        detailAddress: "",
        isDefault: false,
      },
      addressRules: {
        receiverName: [
          { required: true, message: "请输入收货人姓名", trigger: "blur" },
          {
            min: 2,
            max: 20,
            message: "姓名长度为2-20个字符",
            trigger: "blur",
          },
        ],
        receiverPhone: [
          { required: true, message: "请输入联系电话", trigger: "blur" },
          {
            pattern: /^1[3-9]\d{9}$/,
            message: "请输入正确的手机号码",
            trigger: "blur",
          },
        ],
        region: [
          { required: true, message: "请选择所在地区", trigger: "change" },
        ],
        detailAddress: [
          { required: true, message: "请输入详细地址", trigger: "blur" },
          {
            min: 5,
            max: 100,
            message: "详细地址长度为5-100个字符",
            trigger: "blur",
          },
        ],
      },
    };
  },
  watch: {
    addressDialogVisible(val) {
      if (!val && this.$refs.addressFormRef) {
        this.$refs.addressFormRef.resetFields();
      }
    },
  },
  mounted() {
    this.loadAddresses();
  },
  methods: {
    loadAddresses() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => {});
        return;
      }
      this.$http.get(`/address/user/${userId}`).then((res) => {
        if (res.code === 200) {
          this.addresses = res.data || [];
        }
      });
    },
    showAddDialog() {
      this.editingAddress = null;
      this.addressForm = {
        receiverName: "",
        receiverPhone: "",
        province: "",
        city: "",
        district: "",
        region: [],
        detailAddress: "",
        isDefault: this.addresses.length === 0,
      };
      this.$nextTick(() => {
        this.$refs.addressFormRef && this.$refs.addressFormRef.clearValidate();
      });
      this.addressDialogVisible = true;
    },
    editAddress(addr) {
      this.editingAddress = addr;
      this.addressForm = {
        receiverName: addr.receiverName,
        receiverPhone: addr.receiverPhone,
        province: addr.province,
        city: addr.city,
        district: addr.district,
        region: [addr.province, addr.city, addr.district],
        detailAddress: addr.detailAddress,
        isDefault: addr.isDefault === 1,
      };
      this.$nextTick(() => {
        this.$refs.addressFormRef && this.$refs.addressFormRef.clearValidate();
      });
      this.addressDialogVisible = true;
    },
    handleRegionChange(value) {
      if (value && value.length >= 3) {
        this.addressForm.province = value[0];
        this.addressForm.city = value[1];
        this.addressForm.district = value[2];
      }
    },
    saveAddress() {
      this.$refs.addressFormRef.validate((valid) => {
        if (!valid) {
          return;
        }

        const userId = localStorage.getItem("userId");
        const { region, ...restForm } = this.addressForm;
        const data = {
          ...restForm,
          userId: parseInt(userId),
          isDefault: this.addressForm.isDefault ? 1 : 0,
        };

        if (this.editingAddress) {
          data.id = this.editingAddress.id;
          this.$http.put("/address", data).then((res) => {
            if (res.code === 200) {
              this.$message.success("修改成功");
              this.addressDialogVisible = false;
              this.loadAddresses();
            }
          });
        } else {
          this.$http.post("/address", data).then((res) => {
            if (res.code === 200) {
              this.$message.success("添加成功");
              this.addressDialogVisible = false;
              this.loadAddresses();
            }
          });
        }
      });
    },
    deleteAddress(id) {
      this.$confirm("确认删除该地址吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$http.delete(`/address/${id}`).then((res) => {
            if (res.code === 200) {
              this.$message.success("删除成功");
              this.loadAddresses();
            }
          });
        })
        .catch(() => {
          return Promise.resolve();
        });
    },
    setDefault(id) {
      this.$http.put(`/address/default/${id}`).then((res) => {
        if (res.code === 200) {
          this.$message.success("设置成功");
          this.loadAddresses();
        } else {
          this.$message.error(res.message || "设置失败");
        }
      });
    },
  },
};
</script>

<style scoped>
.my-address {
  padding: 30px;
  max-width: 900px;
  margin: 0 auto;
}

.my-address .el-card {
  border-radius: 16px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.address-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.address-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 20px;
  border: 2px solid #e4e4e4;
  border-radius: 8px;
  transition: all 0.3s;
}

.address-item:hover {
  border-color: #409eff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.2);
}

.address-item.is-default {
  border-color: #409eff;
  background: #f0f7ff;
}

.address-content {
  flex: 1;
}

.address-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 10px;
}

.receiver {
  font-weight: bold;
  font-size: 16px;
  color: #333;
}

.phone {
  color: #666;
  font-size: 14px;
}

.address-detail {
  color: #666;
  font-size: 14px;
  line-height: 1.5;
}

.address-actions {
  display: flex;
  gap: 10px;
}

.no-address {
  text-align: center;
  padding: 60px 20px;
  color: #999;
}

.no-address p {
  margin-bottom: 20px;
  font-size: 16px;
}
</style>
