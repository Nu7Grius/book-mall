<template>
  <div class="shop-home">
    <div class="notice-banner" v-if="noticeList.length > 0">
      <el-carousel height="60px" :interval="5000" indicator-position="none">
        <el-carousel-item v-for="notice in noticeList" :key="notice.id">
          <div class="notice-item" @click="showNoticeDetail(notice)">
            <span class="notice-tag" :class="notice.noticeType">
              {{ getNoticeTypeName(notice.noticeType) }}
            </span>
            <span class="notice-title">{{ notice.title }}</span>
            <span class="notice-time">{{ notice.publishTime }}</span>
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>

    <div class="search-result-tip" v-if="keyword || category">
      <span>搜索结果：</span>
      <el-tag
        v-if="keyword"
        size="medium"
        type="primary"
        closable
        @close="clearKeyword"
      >
        关键词: {{ keyword }}
      </el-tag>
      <span v-if="bookList.length" class="result-count"
        >共 {{ bookList.length }} 本图书</span
      >
      <el-button size="mini" @click="clearFilters" v-if="keyword || category"
        >清除筛选</el-button
      >
    </div>

    <div class="book-list">
      <div class="book-grid" v-if="bookList.length > 0">
        <div
          v-for="book in bookList"
          :key="book.id"
          class="book-card"
          @click="goToDetail(book.id)"
        >
          <div class="book-cover">
            <img
              v-if="book.coverImage"
              :src="getImageUrl(book.coverImage)"
              alt=""
            />
            <div v-else class="no-cover">暂无封面</div>
            <div
              class="favorite-btn"
              :class="{ active: favoritedBooks[book.id] }"
              @click="toggleFavorite(book, $event)"
            >
              <i
                :class="
                  favoritedBooks[book.id]
                    ? 'el-icon-star-on'
                    : 'el-icon-star-off'
                "
              ></i>
            </div>
          </div>
          <div class="book-info">
            <h3 class="book-name">{{ book.bookName }}</h3>
            <p class="book-author">{{ book.author }}</p>
            <p class="book-price">¥{{ book.price }}</p>
            <div class="book-actions">
              <el-button type="warning" size="small" @click.stop="buyNow(book)">
                立即购买
              </el-button>
              <el-button
                type="primary"
                size="small"
                @click.stop="addToCart(book)"
              >
                加入购物车
              </el-button>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="empty">
        <p v-if="keyword || category">未找到相关图书</p>
        <p v-else>暂无图书</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "ShopHome",
  props: {
    keyword: {
      type: String,
      default: "",
    },
    category: {
      type: [Number, String],
      default: null,
    },
  },
  data() {
    return {
      bookList: [],
      noticeList: [],
      favoritedBooks: {},
    };
  },
  watch: {
    keyword() {
      this.loadBookList();
    },
    category() {
      this.loadBookList();
    },
  },
  mounted() {
    this.loadBookList();
    this.loadNoticeList();
  },
  methods: {
    loadBookList() {
      let params = {};
      if (this.keyword) {
        params.keyword = this.keyword;
      }
      if (this.category) {
        params.categoryId = this.category;
      }
      this.$http.get("/book/list", { params }).then((res) => {
        if (res.code === 200) {
          this.bookList = res.data.records || res.data || [];
          this.checkFavorites();
        }
      });
    },
    checkFavorites() {
      const userId = localStorage.getItem("userId");
      if (!userId) return;

      const bookIds = this.bookList.map((b) => b.id);
      if (bookIds.length === 0) return;

      Promise.all(
        bookIds.map((bookId) =>
          this.$http
            .get(`/favorite/check?userId=${userId}&bookId=${bookId}`)
            .then((res) => {
              if (res.code === 200) {
                this.$set(this.favoritedBooks, bookId, res.data);
              }
            })
            .catch(() => Promise.resolve())
        )
      );
    },
    toggleFavorite(book, event) {
      event.stopPropagation();
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => Promise.resolve());
        return;
      }

      if (this.favoritedBooks[book.id]) {
        this.$http
          .delete(`/favorite/remove?userId=${userId}&bookId=${book.id}`)
          .then((res) => {
            if (res.code === 200) {
              this.$set(this.favoritedBooks, book.id, false);
              this.$message.success("已取消收藏");
            }
          })
          .catch(() => Promise.resolve());
      } else {
        this.$http
          .post("/favorite/add", {
            userId: parseInt(userId),
            bookId: book.id,
          })
          .then((res) => {
            if (res.code === 200) {
              this.$set(this.favoritedBooks, book.id, true);
              this.$message.success("收藏成功");
            }
          })
          .catch(() => Promise.resolve());
      }
    },
    loadNoticeList() {
      this.$http.get("/notice/list", { params: { status: 1 } }).then((res) => {
        if (res.code === 200) {
          this.noticeList = res.data || [];
        }
      });
    },
    getNoticeTypeName(type) {
      const typeMap = {
        system: "系统公告",
        activity: "活动公告",
        maintenance: "维护公告",
      };
      return typeMap[type] || type;
    },
    showNoticeDetail(notice) {
      this.$alert(
        '<div class="notice-content">' +
          (notice.content || "暂无内容") +
          "</div>",
        notice.title,
        {
          dangerouslyUseHTMLString: true,
          confirmButtonText: "关闭",
        }
      );
    },
    getImageUrl(path) {
      if (!path) return "";
      if (path.startsWith("http")) return path;
      if (path.startsWith("data:")) return path;
      return "http://localhost:8080" + path;
    },
    goToDetail(id) {
      this.$router.push(`/home/book-detail/${id}`);
    },
    addToCart(book) {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => Promise.resolve());
        return;
      }
      this.$http
        .post("/cart/add", {
          userId: parseInt(userId),
          bookId: book.id,
          quantity: 1,
        })
        .then((res) => {
          if (res.code === 200) {
            this.$message.success("已加入购物车");
          }
        });
    },
    buyNow(book) {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => Promise.resolve());
        return;
      }
      this.$router
        .push({
          path: "/home/confirm-order",
          query: {
            items: JSON.stringify([
              { book: book, bookId: book.id, quantity: 1 },
            ]),
          },
        })
        .catch(() => Promise.resolve());
    },
    clearKeyword() {
      this.$emit("search", "");
    },
    clearFilters() {
      if (this.keyword) {
        this.$emit("search", "");
      }
      if (this.category) {
        this.$emit("category", null);
      }
    },
  },
};
</script>

<style scoped>
.shop-home {
  padding: 20px 0;
}

.search-result-tip {
  max-width: 1200px;
  margin: 0 auto 20px;
  padding: 12px 20px;
  background: #fff;
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.search-result-tip > span:first-child {
  font-weight: 600;
  color: #333;
}

.search-result-tip .result-count {
  color: #666;
  margin-left: auto;
}

.book-list {
  max-width: 1200px;
  margin: 0 auto;
}

.book-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
}

.book-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
  cursor: pointer;
}

.book-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.book-cover {
  position: relative;
  width: 100%;
  height: 220px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
  overflow: hidden;
}

.book-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.book-card:hover .book-cover img {
  transform: scale(1.05);
}

.no-cover {
  color: #999;
  font-size: 14px;
  padding: 20px;
  text-align: center;
}

.favorite-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.book-card:hover .favorite-btn {
  transform: scale(1.1);
}

.favorite-btn i {
  font-size: 20px;
  color: #999;
  transition: all 0.3s;
}

.favorite-btn:hover i {
  color: #ffaa00;
  transform: scale(1.2);
}

.favorite-btn.active i {
  color: #ffaa00;
}

.favorite-btn.active {
  background: rgba(255, 170, 0, 0.1);
}

.book-info {
  padding: 16px;
}

.book-name {
  margin: 0 0 8px 0;
  font-size: 15px;
  font-weight: 600;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  transition: color 0.3s;
}

.book-card:hover .book-name {
  color: #409eff;
}

.book-author {
  margin: 0 0 8px 0;
  font-size: 13px;
  color: #888;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.book-price {
  margin: 0 0 12px 0;
  font-size: 22px;
  font-weight: bold;
  color: #ff4400;
}

.book-actions {
  text-align: center;
  display: flex;
  gap: 8px;
}

.book-actions .el-button {
  flex: 1;
  border-radius: 20px;
  transition: all 0.3s;
  font-size: 13px;
  padding: 8px 0;
}

.book-actions .el-button--warning {
  background: linear-gradient(135deg, #ff8800 0%, #ffaa33 100%);
  border: none;
}

.book-actions .el-button--warning:hover {
  background: linear-gradient(135deg, #ffaa33 0%, #ff8800 100%);
  transform: scale(1.05);
}

.book-actions .el-button--primary {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border: none;
}

.book-actions .el-button--primary:hover {
  background: linear-gradient(135deg, #66b1ff 0%, #409eff 100%);
  transform: scale(1.05);
}

.empty {
  text-align: center;
  padding: 80px 0;
  color: #999;
  background: #fff;
  border-radius: 12px;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 20px;
}

.empty p {
  margin: 10px 0;
  font-size: 16px;
}

.notice-banner {
  max-width: 1200px;
  margin: 0 auto 20px;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.notice-item {
  display: flex;
  align-items: center;
  padding: 0 30px;
  height: 60px;
  cursor: pointer;
  transition: background 0.3s;
}

.notice-item:hover {
  background: #f5f7fa;
}

.notice-tag {
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
  margin-right: 16px;
  white-space: nowrap;
}

.notice-tag.system {
  background: #ecf5ff;
  color: #409eff;
}

.notice-tag.activity {
  background: #f0f9eb;
  color: #67c23a;
}

.notice-tag.maintenance {
  background: #fdf6ec;
  color: #e6a23c;
}

.notice-title {
  flex: 1;
  font-size: 14px;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.notice-time {
  font-size: 12px;
  color: #999;
  margin-left: 20px;
  white-space: nowrap;
}

.notice-banner /deep/ .el-carousel__item {
  display: flex;
  align-items: center;
}

.notice-banner /deep/ .el-carousel__arrow {
  display: none;
}

:global(.notice-content) {
  font-size: 14px;
  line-height: 1.8;
  color: #555;
}

:global(.notice-content p) {
  margin: 10px 0;
}

:global(.notice-content img) {
  max-width: 100%;
  border-radius: 4px;
}
</style>
