<template>
  <div class="cart-page">
    <el-card>
      <div slot="header">
        <span>我的购物车</span>
      </div>

      <el-table
        ref="cartTable"
        :data="cartList"
        border
        stripe
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column label="商品" min-width="300">
          <template slot-scope="scope">
            <div class="book-info">
              <img
                v-if="scope.row.book && scope.row.book.coverImage"
                :src="getImageUrl(scope.row.book.coverImage)"
                class="book-cover"
              />
              <div class="book-detail">
                <p class="book-name">
                  {{ scope.row.book ? scope.row.book.bookName : "未知" }}
                </p>
                <p class="book-author">
                  {{ scope.row.book ? scope.row.book.author : "" }}
                </p>
                <p class="book-price">
                  ¥{{ scope.row.book ? scope.row.book.price : 0 }}
                </p>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="数量" width="150">
          <template slot-scope="scope">
            <el-input-number
              v-model="scope.row.quantity"
              :min="1"
              size="small"
              @change="updateQuantity(scope.row)"
            ></el-input-number>
          </template>
        </el-table-column>
        <el-table-column label="小计" width="120">
          <template slot-scope="scope">
            <span class="subtotal">
              ¥{{
                (
                  (scope.row.book ? scope.row.book.price : 0) *
                  scope.row.quantity
                ).toFixed(2)
              }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100">
          <template slot-scope="scope">
            <el-button type="text" @click="removeItem(scope.row.id)"
              >删除</el-button
            >
          </template>
        </el-table-column>
      </el-table>

      <div class="cart-footer" v-if="cartList.length > 0">
        <div class="total">
          <span>已选 {{ selectedItems.length }} 件商品，总计：</span>
          <span class="total-price">¥{{ totalPrice.toFixed(2) }}</span>
        </div>
        <el-button
          type="primary"
          size="large"
          @click="goCheckout"
          :disabled="selectedItems.length === 0"
        >
          去结算
        </el-button>
      </div>
    </el-card>
  </div>
</template>

<script>
import { getImageUrl } from "@/utils/img";

export default {
  name: "Cart",
  data() {
    return {
      cartList: [],
      selectedItems: [],
      currentUserId: null,
      refreshInterval: null,
      lastUpdateTime: null,
    };
  },
  computed: {
    totalPrice() {
      return this.selectedItems.reduce((sum, item) => {
        return sum + (item.book ? item.book.price : 0) * item.quantity;
      }, 0);
    },
  },
  mounted() {
    this.loadCart();
    this.startSmartRefresh(60000, this.loadCart, {
      stopOnHidden: true,
      resumeOnVisible: true,
      updateOnFocus: true,
    });
  },
  beforeDestroy() {
    this.stopAutoRefresh();
  },
  methods: {
    loadCart() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => {});
        return;
      }
      this.currentUserId = parseInt(userId);
      this.$http.get("/cart/list").then((res) => {
        if (res.code === 200) {
          const parsedUserId = parseInt(userId);
          this.cartList = res.data.filter(
            (item) => item.userId === parsedUserId
          );
        }
      });
    },
    handleSelectionChange(val) {
      this.selectedItems = val;
    },
    updateQuantity(item) {
      // 只更新本地数据，不需要重新加载整个列表
      this.$http.put("/cart", item).then((res) => {
        if (res.code === 200) {
          // 已经在 v-model 中更新了数量，这里不需要额外操作
        }
      });
    },
    removeItem(id) {
      this.$confirm("确定要从购物车移除吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$http.delete(`/cart/${id}`).then((res) => {
            if (res.code === 200) {
              this.$message.success("已移除");
              this.loadCart();
            }
          });
        })
        .catch(() => Promise.resolve());
    },
    goCheckout() {
      if (this.selectedItems.length === 0) {
        this.$message.warning("请选择要结算的商品");
        return;
      }

      const items = this.selectedItems.map((item) => ({
        cartId: item.id,
        book: item.book,
        bookId: item.bookId || item.book.id,
        quantity: item.quantity,
      }));
      this.$router
        .push({
          path: "/home/confirm-order",
          query: { items: JSON.stringify(items) },
        })
        .catch(() => {});
    },
  },
};
</script>

<style scoped>
.cart-page {
  max-width: 1200px;
  margin: 0 auto;
}

.book-info {
  display: flex;
  gap: 15px;
  align-items: center;
}

.book-cover {
  width: 60px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
}

.book-detail {
  flex: 1;
}

.book-name {
  margin: 0;
  font-weight: bold;
}

.book-author {
  margin: 5px 0;
  color: #666;
  font-size: 13px;
}

.book-price {
  margin: 0;
  color: #ff4400;
}

.subtotal {
  color: #ff4400;
  font-weight: bold;
}

.cart-footer {
  margin-top: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 4px;
}

.total {
  font-size: 16px;
}

.total-price {
  color: #ff4400;
  font-size: 24px;
  font-weight: bold;
  margin-left: 10px;
}
</style>
