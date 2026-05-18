<template>
  <div class="book-detail-wrapper">
    <div v-if="loading" class="loading-container">
      <el-skeleton :rows="10" animated />
    </div>
    <div v-else-if="error" class="error-container">
      <el-result
        icon="error"
        title="加载失败"
        subTitle="请检查网络连接或稍后重试"
      >
        <template slot="extra">
          <el-button type="primary" @click="loadBookDetail">重新加载</el-button>
        </template>
      </el-result>
    </div>
    <div v-else-if="book" class="book-detail">
      <el-card>
        <div class="merchant-header" v-if="book.merchantName || book.shopName">
          <div class="merchant-avatar">
            <img
              v-if="book.merchantAvatar"
              :src="getImageUrl(book.merchantAvatar)"
              alt="商家头像"
            />
            <i v-else class="el-icon-user-solid"></i>
          </div>
          <div class="merchant-info">
            <span
              class="merchant-badge"
              :class="getMerchantBadgeClass(book.merchantType)"
            >
              {{ getMerchantTypeName(book.merchantType) }}
            </span>
            <span class="merchant-name">{{
              book.shopName || book.merchantName
            }}</span>
          </div>
        </div>

        <div class="detail-content">
          <div class="book-cover">
            <img
              v-if="book.coverImage"
              :src="getImageUrl(book.coverImage)"
              alt=""
            />
            <div v-else class="no-cover">暂无封面</div>
          </div>
          <div class="book-info">
            <h2>{{ book.bookName }}</h2>
            <p class="author">作者：{{ book.author }}</p>

            <p class="price">¥{{ book.price }}</p>

            <div class="services-row">
              <span class="service-item"
                ><i class="el-icon-circle-check"></i> 正品保障</span
              >
              <span class="service-item"
                ><i class="el-icon-present"></i> 假一赔三</span
              >
              <span class="service-item"
                ><i class="el-icon-truck"></i> 免运费</span
              >
              <span class="service-item"
                ><i class="el-icon-timer"></i> 48小时发货</span
              >
              <span class="service-item"
                ><i class="el-icon-refresh"></i> 7天无理由退换</span
              >
            </div>

            <div class="meta-row">
              <div class="meta-text" v-if="book.publisher">
                <span class="meta-label">出版社：</span>
                <span class="meta-value">{{ book.publisher }}</span>
              </div>
              <div class="meta-text" v-if="book.publishDate">
                <span class="meta-label">出版时间：</span>
                <span class="meta-value">{{
                  formatDate(book.publishDate)
                }}</span>
              </div>
              <div class="meta-text" v-if="book.createTime">
                <span class="meta-label">上架时间：</span>
                <span class="meta-value">{{
                  formatDate(book.createTime)
                }}</span>
              </div>
            </div>

            <div class="actions">
              <el-button
                plain
                size="medium"
                :type="isFavorited ? 'danger' : 'default'"
                :icon="isFavorited ? 'el-icon-star-on' : 'el-icon-star-off'"
                @click="toggleFavorite"
                :class="{ 'favorite-btn': true, 'is-favorited': isFavorited }"
              >
                {{ isFavorited ? "已收藏" : "收藏" }}
              </el-button>
              <el-button type="primary" size="large" @click="addToCart"
                >加入购物车</el-button
              >
              <el-button type="warning" size="large" @click="buyNow"
                >立即购买</el-button
              >
            </div>
          </div>
        </div>

        <div class="detail-tabs">
          <div
            class="tab-item"
            :class="{ active: activeNav === 'detail' }"
            @click="activeNav = 'detail'"
          >
            <i class="el-icon-document"></i>
            <span>详细信息</span>
          </div>
          <div
            class="tab-item"
            :class="{ active: activeNav === 'comment' }"
            @click="activeNav = 'comment'"
          >
            <i class="el-icon-chat-line-round"></i>
            <span>用户评价</span>
          </div>
        </div>

        <div class="detail-content-area">
          <div v-show="activeNav === 'detail'" class="detail-panel">
            <div class="intro-content">
              <div
                v-if="book.description"
                class="description-text"
                v-html="book.description"
              ></div>
              <div v-else class="empty-hint">
                <i class="el-icon-document-delete"></i>
                暂无内容简介
              </div>
            </div>
          </div>

          <div v-show="activeNav === 'comment'" class="comment-panel">
            <div class="comment-card">
              <BookComment v-if="book.id" :bookId="book.id" />
            </div>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script>
import axios from "@/api/request";
import BookComment from "./BookComment.vue";

export default {
  name: "BookDetail",
  components: {
    BookComment,
  },
  data() {
    return {
      book: null,
      loading: true,
      error: false,
      isFavorited: false,
      isCheckingFavorite: true,
      activeNav: "detail",
    };
  },
  watch: {
    $route(to, from) {
      this.loadBookDetail();
    },
  },
  mounted() {
    this.loading = true;
    this.error = false;
    this.loadBookDetail();
  },
  methods: {
    loadBookDetail() {
      this.loading = true;
      this.error = false;
      const id = this.$route.params.id;

      if (!id) {
        this.loading = false;
        this.error = true;
        return;
      }

      axios
        .get(`/book/${id}`)
        .then((res) => {
          this.loading = false;

          if (!res || res.code === undefined) {
            this.error = true;
            return;
          }

          if (res.code === 200) {
            this.book = res.data;
            this.checkFavoriteStatus();
          } else {
            this.error = true;
          }
        })
        .catch((error) => {
          this.loading = false;
          this.error = true;
        });
    },
    checkFavoriteStatus() {
      const userId = localStorage.getItem("userId");
      if (!userId || !this.book) {
        this.isCheckingFavorite = false;
        return;
      }

      axios
        .get(`/favorite/check?userId=${userId}&bookId=${this.book.id}`)
        .then((res) => {
          if (res.code === 200) {
            this.isFavorited = res.data;
          }
        })
        .finally(() => {
          this.isCheckingFavorite = false;
        });
    },
    toggleFavorite() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => Promise.resolve());
        return;
      }

      if (this.isFavorited) {
        this.$http
          .delete(`/favorite/remove?userId=${userId}&bookId=${this.book.id}`)
          .then((res) => {
            if (res.code === 200) {
              this.isFavorited = false;
              this.$message.success("已取消收藏");
            } else {
              this.$message.error(res.message || "操作失败");
            }
          })
          .catch(() => {
            this.$message.error("网络错误，请稍后重试");
          });
      } else {
        this.$http
          .post("/favorite/add", {
            userId: parseInt(userId),
            bookId: parseInt(this.book.id),
          })
          .then((res) => {
            if (res.code === 200) {
              this.isFavorited = true;
              this.$message.success("收藏成功");
            } else {
              this.$message.error(res.message || "操作失败");
            }
          })
          .catch(() => {
            this.$message.error("网络错误，请稍后重试");
          });
      }
    },
    getImageUrl(path) {
      if (!path) return "";
      if (path.startsWith("http")) return path;
      if (path.startsWith("data:")) return path;
      return "http://localhost:8080" + path;
    },
    formatDate(date) {
      if (!date) return "";
      const d = new Date(date);
      const year = d.getFullYear();
      const month = (d.getMonth() + 1).toString().padStart(2, "0");
      const day = d.getDate().toString().padStart(2, "0");
      return `${year}-${month}-${day}`;
    },
    getMerchantTypeName(type) {
      const typeMap = {
        self: "自营",
        flagship: "旗舰",
        third_party: "第三方",
      };
      return typeMap[type] || "第三方";
    },
    getMerchantBadgeClass(type) {
      const classMap = {
        self: "badge-self",
        flagship: "badge-flagship",
        third_party: "badge-third",
      };
      return classMap[type] || "badge-third";
    },
    addToCart() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => Promise.resolve());
        return;
      }
      this.$http
        .post("/cart/add", {
          userId: parseInt(userId),
          bookId: this.book.id,
          quantity: 1,
        })
        .then((res) => {
          if (res.code === 200) {
            this.$message.success("已加入购物车");
          }
        });
    },
    buyNow() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => {});
        return;
      }
      this.$router
        .push({
          path: "/home/confirm-order",
          query: { bookId: this.book.id, quantity: 1 },
        })
        .catch(() => {});
    },
  },
};
</script>

<style scoped>
.book-detail {
  padding: 30px 0;
  max-width: 1200px;
  margin: 0 auto;
}

.book-detail .el-card {
  border-radius: 16px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.detail-content {
  display: flex;
  gap: 30px;
  padding: 16px;
}

.book-cover {
  width: 320px;
  height: 450px;
  min-width: 320px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  transition: transform 0.3s, box-shadow 0.3s;
}

.book-cover:hover {
  transform: scale(1.02);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.18);
}

.book-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-cover {
  color: #999;
  font-size: 16px;
}

.book-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  min-width: 320px;
}

.book-info h2 {
  margin: 0 0 12px 0;
  font-size: 26px;
  font-weight: 700;
  color: #333;
  line-height: 1.3;
}

.book-info .author {
  margin: 12px 0;
  font-size: 16px;
  color: #666;
  display: flex;
  align-items: center;
}

.book-info .author::before {
  content: "✍️";
  margin-right: 8px;
}

.merchant-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
}

.merchant-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);
}

.merchant-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.merchant-avatar i {
  font-size: 24px;
  color: #fff;
}

.merchant-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.merchant-info .merchant-badge {
  padding: 3px 10px;
  border-radius: 5px;
  font-size: 12px;
  font-weight: 600;
  color: #fff;
  width: fit-content;
}

.badge-self {
  background: linear-gradient(135deg, #e6a23c 0%, #f56c6c 100%);
}

.badge-flagship {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
}

.badge-third {
  background: linear-gradient(135deg, #909399 0%, #606266 100%);
}

.merchant-info .merchant-name {
  font-size: 14px;
  color: #333;
  font-weight: 600;
}

.book-info .price {
  margin: 14px 0;
  font-size: 36px;
  font-weight: bold;
  color: #ff4400;
}

.services-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  margin: 14px 0;
}

.service-item {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 13px;
  color: #67c23a;
  font-weight: 500;
}

.service-item i {
  font-size: 14px;
}

.meta-row {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin: 14px 0;
  padding: 12px 0;
  border-top: 1px solid #f0f0f0;
}

.meta-text {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
}

.meta-label {
  color: #909399;
  font-weight: 500;
}

.meta-value {
  color: #606266;
}

.meta-text i {
  font-size: 14px;
  color: #409eff;
  margin-right: 4px;
}

.book-info .stock {
  margin: 12px 0;
  font-size: 15px;
  color: #999;
}

.book-info .stock::before {
  content: "📦";
  margin-right: 8px;
}

.book-info .description {
  margin: 24px 0;
  font-size: 15px;
  color: #555;
  line-height: 1.8;
  padding: 20px;
  background: #f9fafb;
  border-radius: 8px;
  border-left: 4px solid #409eff;
}

.description-text {
  font-size: 14px;
  line-height: 1.8;
  color: #606266;
}

.description-text :deep(p) {
  margin: 10px 0 !important;
  text-indent: 2em !important;
  text-align: justify !important;
}

.description-text :deep(img) {
  max-width: 100% !important;
  border-radius: 4px;
  margin: 10px 0;
}

.description-text :deep(h1),
.description-text :deep(h2),
.description-text :deep(h3) {
  margin: 18px 0 12px 0 !important;
  color: #333 !important;
  font-weight: 700 !important;
  padding-left: 0 !important;
  text-indent: 0 !important;
}

.description-text :deep(h2) {
  font-size: 18px !important;
  border-bottom: 2px solid #409eff !important;
  padding-bottom: 8px !important;
}

.description-text :deep(h3) {
  font-size: 16px !important;
  color: #409eff !important;
}

.description-text :deep(ul),
.description-text :deep(ol) {
  padding-left: 2em !important;
  margin: 12px 0 !important;
  text-align: left !important;
}

.description-text :deep(li) {
  margin: 8px 0 !important;
  line-height: 1.6 !important;
}

.description-text :deep(li)::marker {
  color: #409eff !important;
}

.description-text :deep(blockquote) {
  margin: 15px 0 !important;
  padding: 12px 15px !important;
  background: #fff !important;
  border-left: 4px solid #67c23a !important;
  border-radius: 0 4px 4px 0 !important;
  font-style: italic !important;
  color: #666 !important;
}

.actions {
  margin-top: 32px;
  display: flex;
  gap: 20px;
}

.actions .favorite-btn {
  background: #fff;
  border: 2px solid #f56c6c;
  color: #f56c6c;
  font-weight: bold;
  transition: all 0.3s;
}

.actions .favorite-btn:hover {
  background: #f56c6c;
  color: #fff;
  border-color: #f56c6c;
}

.actions .favorite-btn.is-favorited {
  background: #f56c6c;
  border-color: #f56c6c;
  color: #fff;
}

.actions .favorite-btn.is-favorited:hover {
  background: #f78989;
  border-color: #f78989;
}

.actions .el-button {
  flex: 1;
  height: 50px;
  font-size: 18px;
  border-radius: 25px;
  transition: all 0.3s;
}

.actions .el-button:not(.favorite-btn):first-child {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border: none;
}

.actions .el-button:first-child:hover {
  background: linear-gradient(135deg, #66b1ff 0%, #409eff 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.actions .el-button:last-child {
  background: linear-gradient(135deg, #ff8800 0%, #ffaa33 100%);
  border: none;
  color: #fff;
}

/* 现代化导航设计 */
.detail-navigation {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin: 24px 0;
  padding: 0;
}

.detail-tabs {
  display: flex;
  background: #fff;
  border-bottom: 2px solid #e4e7ed;
  margin: 16px 0;
}

.tab-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 20px;
  font-size: 14px;
  font-weight: 500;
  color: #606266;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
}

.tab-item:hover {
  color: #002fa7;
  background: #f5f7fa;
}

.tab-item.active {
  color: #002fa7;
  border-bottom-color: #002fa7;
  background: linear-gradient(to top, rgba(0, 47, 167, 0.05), transparent);
}

.tab-item i {
  font-size: 16px;
}

.detail-content-area {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  min-height: 200px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
  color: #002fa7;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid #e4e7ed;
}

.section-title i {
  font-size: 18px;
}

.intro-content {
  padding: 0 4px;
}

.description-text {
  font-size: 14px;
  line-height: 1.8;
  color: #606266;
  text-indent: 2em;
}

.empty-hint {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 32px;
  color: #909399;
  font-size: 14px;
}

.empty-hint i {
  font-size: 20px;
}

.comment-card {
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
}

.loading-container,
.error-container {
  padding: 40px 20px;
}

.book-detail-wrapper {
  min-height: 500px;
}

@media (max-width: 768px) {
  .detail-tabs {
    margin: 12px 0;
  }

  .tab-item {
    padding: 10px 12px;
    font-size: 13px;
  }

  .tab-item i {
    font-size: 14px;
  }

  .detail-content-area {
    padding: 16px;
  }
}
</style>
