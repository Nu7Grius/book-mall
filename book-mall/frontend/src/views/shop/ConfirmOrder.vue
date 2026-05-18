<template>
  <div class="confirm-order">
    <el-card>
      <div slot="header">
        <span>确认订单</span>
      </div>

      <div class="order-content">
        <div class="address-section">
          <h3>收货地址</h3>
          <div class="address-list" v-if="addresses.length > 0">
            <div
              v-for="addr in addresses"
              :key="addr.id"
              class="address-item"
              :class="{
                selected: selectedAddress && selectedAddress.id === addr.id,
              }"
              @click="selectAddress(addr)"
            >
              <div class="address-content">
                <div class="address-tag" v-if="addr.isDefault === 1">
                  <el-tag size="mini" type="success">默认</el-tag>
                </div>
                <p class="receiver">
                  {{ addr.receiverName }} {{ addr.receiverPhone }}
                </p>
                <p class="detail">
                  {{ addr.province }}{{ addr.city }}{{ addr.district
                  }}{{ addr.detailAddress }}
                </p>
              </div>
              <div class="address-actions">
                <el-button
                  size="mini"
                  type="text"
                  @click.stop="editAddress(addr)"
                  >编辑</el-button
                >
                <el-button
                  size="mini"
                  type="text"
                  @click.stop="deleteAddress(addr.id)"
                  >删除</el-button
                >
              </div>
            </div>
          </div>
          <div class="no-address" v-else>
            <p>暂无收货地址</p>
          </div>
          <el-button type="text" @click="showAddDialog">
            <i class="el-icon-plus"></i> 添加新地址
          </el-button>
        </div>

        <div class="order-items">
          <h3>商品信息</h3>
          <div class="item-list">
            <div v-for="item in orderItems" :key="item.book.id" class="item">
              <img
                :src="getImageUrl(item.book.coverImage)"
                class="book-cover"
              />
              <div class="book-info">
                <p class="name">{{ item.book.bookName }}</p>
                <p class="author">{{ item.book.author }}</p>
              </div>
              <div class="quantity">x{{ item.quantity }}</div>
              <div class="price">
                ¥{{ (item.book.price * item.quantity).toFixed(2) }}
              </div>
            </div>
          </div>
        </div>

        <div class="order-total">
          <div class="total-row">
            <span>商品总价：</span>
            <span class="price">¥{{ totalPrice.toFixed(2) }}</span>
          </div>
          <div class="total-row">
            <span>运费：</span>
            <span class="price">¥0.00</span>
          </div>
          <div class="total-row final">
            <span>应付总额：</span>
            <span class="price">¥{{ totalPrice.toFixed(2) }}</span>
          </div>
        </div>

        <div class="order-actions">
          <el-button @click="$router.back().catch(() => {})">返回</el-button>
          <el-button
            type="primary"
            size="large"
            @click="submitOrder"
            :disabled="!selectedAddress && addresses.length > 0"
          >
            提交订单
          </el-button>
        </div>
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
  name: "ConfirmOrder",
  data() {
    return {
      orderItems: [],
      cartIds: [],
      addresses: [],
      selectedAddress: null,
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
  computed: {
    totalPrice() {
      return this.orderItems.reduce((sum, item) => {
        return sum + (item.book ? item.book.price : 0) * item.quantity;
      }, 0);
    },
  },
  watch: {
    addressDialogVisible(val) {
      if (!val && this.$refs.addressFormRef) {
        this.$refs.addressFormRef.resetFields();
      }
    },
  },
  mounted() {
    this.loadOrderItems();
    this.loadAddresses();
  },
  methods: {
    loadAddresses() {
      const userId = localStorage.getItem("userId");
      if (!userId) return;
      this.$http.get(`/address/user/${userId}`).then((res) => {
        if (res.code === 200) {
          this.addresses = res.data || [];
          const defaultAddr = this.addresses.find((a) => a.isDefault === 1);
          if (defaultAddr) {
            this.selectedAddress = defaultAddr;
          } else if (this.addresses.length > 0) {
            this.selectedAddress = this.addresses[0];
          }
        }
      });
    },
    selectAddress(addr) {
      this.selectedAddress = addr;
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
              if (this.selectedAddress && this.selectedAddress.id === id) {
                this.selectedAddress = null;
              }
              this.loadAddresses();
            }
          });
        })
        .catch(() => Promise.resolve());
    },
    loadOrderItems() {
      const query = this.$route.query;
      if (query.bookId) {
        this.$http.get(`/book/${query.bookId}`).then((res) => {
          if (res.code === 200) {
            this.orderItems = [
              { book: res.data, quantity: parseInt(query.quantity) || 1 },
            ];
            this.cartIds = [];
          }
        });
      } else if (query.items) {
        const items = JSON.parse(query.items);
        this.cartIds = items
          .map((item) => item.cartId)
          .filter((id) => id !== undefined);
        Promise.all(
          items.map((item) => this.$http.get(`/book/${item.bookId}`))
        ).then((results) => {
          this.orderItems = results.map((res, index) => ({
            book: res.data,
            quantity: items[index].quantity,
          }));
        });
      }
    },
    submitOrder() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => Promise.resolve());
        return;
      }

      if (!this.selectedAddress) {
        this.$message.warning("请选择收货地址");
        return;
      }

      const orderData = {
        userId: parseInt(userId),
        totalAmount: this.totalPrice,
        orderStatus: "待付款",
        addressId: this.selectedAddress.id,
        receiverName: this.selectedAddress.receiverName,
        receiverPhone: this.selectedAddress.receiverPhone,
        address:
          this.selectedAddress.province +
          this.selectedAddress.city +
          this.selectedAddress.district +
          this.selectedAddress.detailAddress,
        items: this.orderItems.map((item) => ({
          bookId: item.book.id,
          quantity: item.quantity,
          price: item.book.price,
        })),
      };

      this.$http.post("/order/create", orderData).then((res) => {
        if (res.code === 200) {
          const orderId = res.data.id;
          const orderNumber = res.data.orderNumber;

          if (this.cartIds.length > 0) {
            Promise.all(
              this.cartIds.map((cartId) => this.$http.delete(`/cart/${cartId}`))
            )
              .then(() => {
                this.$message.success("订单提交成功！订单号：" + orderNumber);
                this.$router
                  .push(`/home/order-detail/${orderId}`)
                  .catch(() => {});
              })
              .catch(() => {
                this.$message.warning(
                  "订单已创建，但购物车清理失败，请手动处理"
                );
                this.$router
                  .push(`/home/order-detail/${orderId}`)
                  .catch(() => {});
              });
          } else {
            this.$message.success("订单提交成功！订单号：" + orderNumber);
            this.$router.push(`/home/order-detail/${orderId}`).catch(() => {});
          }
        }
      });
    },
  },
};
</script>

<style scoped>
.confirm-order {
  padding: 30px;
  max-width: 1200px;
  margin: 0 auto;
}

.confirm-order .el-card {
  border-radius: 16px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.order-items {
  margin-bottom: 30px;
}

.order-items h3 {
  margin: 0 0 20px 0;
  font-size: 18px;
  color: #333;
  padding-bottom: 15px;
  border-bottom: 2px solid #409eff;
}

.address-section {
  margin-bottom: 30px;
}

.address-section h3 {
  margin: 0 0 20px 0;
  font-size: 18px;
  color: #333;
  padding-bottom: 15px;
  border-bottom: 2px solid #409eff;
}

.address-list {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 15px;
}

.address-item {
  position: relative;
  width: 280px;
  padding: 15px;
  border: 2px solid #e4e4e4;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.address-item:hover {
  border-color: #409eff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.2);
}

.address-item.selected {
  border-color: #409eff;
  background: #f0f7ff;
}

.address-tag {
  margin-bottom: 8px;
}

.address-item .receiver {
  margin: 0 0 8px 0;
  font-weight: bold;
  font-size: 15px;
  color: #333;
}

.address-item .detail {
  margin: 0;
  color: #666;
  font-size: 13px;
  line-height: 1.5;
}

.address-actions {
  position: absolute;
  top: 10px;
  right: 10px;
  display: flex;
  gap: 5px;
}

.no-address {
  text-align: center;
  padding: 20px;
  color: #999;
  font-size: 14px;
}

.item-list {
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.item {
  display: flex;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
  transition: background 0.3s;
}

.item:hover {
  background: #fafafa;
}

.item:last-child {
  border-bottom: none;
}

.book-cover {
  width: 80px;
  height: 100px;
  object-fit: cover;
  border-radius: 6px;
  margin-right: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.book-info {
  flex: 1;
}

.book-info .name {
  margin: 0;
  font-weight: bold;
  font-size: 16px;
  color: #333;
}

.book-info .author {
  margin: 8px 0 0 0;
  color: #888;
  font-size: 14px;
}

.quantity {
  width: 80px;
  text-align: center;
  color: #666;
  font-size: 14px;
}

.price {
  width: 120px;
  text-align: right;
  color: #ff4400;
  font-weight: bold;
  font-size: 16px;
}

.order-total {
  margin-top: 30px;
  padding: 25px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.total-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12px;
  font-size: 15px;
  color: #666;
}

.total-row.final {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 2px solid #ddd;
  font-size: 20px;
  font-weight: bold;
  color: #333;
}

.total-row .price {
  font-size: 18px;
  color: #666;
}

.total-row.final .price {
  font-size: 28px;
  color: #ff4400;
}

.order-actions {
  margin-top: 30px;
  display: flex;
  justify-content: flex-end;
  gap: 15px;
}

.order-actions .el-button:first-child {
  width: 120px;
  border-radius: 20px;
}

.order-actions .el-button:last-child {
  width: 160px;
  height: 50px;
  font-size: 18px;
  border-radius: 25px;
  background: linear-gradient(135deg, #ff8800 0%, #ffaa33 100%);
  border: none;
  color: #fff;
}

.order-actions .el-button:last-child:hover {
  background: linear-gradient(135deg, #ffaa33 0%, #ff8800 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 136, 0, 0.4);
}
</style>
