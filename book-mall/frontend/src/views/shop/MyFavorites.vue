<template>
  <div class="my-favorites">
    <el-card>
      <div slot="header" class="header">
        <span>我的收藏</span>
        <el-input
          v-model="searchKeyword"
          placeholder="搜索图书名称"
          prefix-icon="el-icon-search"
          clearable
          class="search-input"
        />
      </div>

      <div v-if="loading" class="loading">
        <i class="el-icon-loading"></i> 加载中...
      </div>

      <div v-else-if="filteredFavorites.length === 0" class="no-data">
        <p>暂无收藏图书</p>
        <el-button type="primary" @click="$router.push('/home')">
          去逛逛
        </el-button>
      </div>

      <div v-else class="book-grid">
        <div v-for="book in filteredFavorites" :key="book.id" class="book-card">
          <div class="book-cover" @click="viewBook(book.id)">
            <img
              v-if="book.coverImage"
              :src="getImageUrl(book.coverImage)"
              :alt="book.bookName"
            />
            <div v-else class="no-cover">暂无封面</div>
          </div>
          <div class="book-info">
            <h3 class="book-name" @click="viewBook(book.id)">
              {{ book.bookName }}
            </h3>
            <p class="author">{{ book.author }}</p>
            <p class="price">¥{{ book.price }}</p>
          </div>
          <div class="book-actions">
            <el-button size="mini" type="primary" @click="addToCart(book)">
              加入购物车
            </el-button>
            <el-button
              size="mini"
              type="danger"
              @click="removeFavorite(book.id)"
            >
              取消收藏
            </el-button>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
import { getImageUrl } from "@/utils/img";

export default {
  name: "MyFavorites",
  data() {
    return {
      favorites: [],
      loading: false,
      searchKeyword: "",
    };
  },
  computed: {
    filteredFavorites() {
      if (!this.searchKeyword) {
        return this.favorites;
      }
      const keyword = this.searchKeyword.toLowerCase();
      return this.favorites.filter((book) =>
        book.bookName.toLowerCase().includes(keyword)
      );
    },
  },
  mounted() {
    this.loadFavorites();
  },
  methods: {
    loadFavorites() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        this.$message.warning("请先登录");
        this.$router.push("/login").catch(() => Promise.resolve());
        return;
      }

      this.loading = true;
      this.$http
        .get(`/favorite/user/${userId}`)
        .then((res) => {
          this.loading = false;
          if (res.code === 200) {
            this.favorites = res.data || [];
          }
        })
        .catch(() => {
          this.loading = false;
        });
    },
    viewBook(bookId) {
      this.$router
        .push(`/home/book-detail/${bookId}`)
        .catch(() => Promise.resolve());
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
          bookId: parseInt(book.id),
          quantity: 1,
        })
        .then((res) => {
          if (res.code === 200) {
            this.$message.success("已加入购物车");
          }
        });
    },
    removeFavorite(bookId) {
      const userId = localStorage.getItem("userId");
      if (!userId) return;

      this.$confirm("确认取消收藏该图书吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$http
            .delete(`/favorite/remove?userId=${userId}&bookId=${bookId}`)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("已取消收藏");
                this.loadFavorites();
              }
            });
        })
        .catch(() => Promise.resolve());
    },
  },
};
</script>

<style scoped>
.my-favorites {
  padding: 30px;
  max-width: 1200px;
  margin: 0 auto;
}

.my-favorites .el-card {
  border-radius: 16px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.my-favorites .header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.my-favorites .header span {
  font-size: 18px;
  font-weight: bold;
}

.search-input {
  width: 300px;
}

.loading {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
}

.no-data {
  text-align: center;
  padding: 60px 20px;
  color: #999;
}

.no-data p {
  margin-bottom: 20px;
  font-size: 16px;
}

.book-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 20px;
}

.book-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s;
  border: 1px solid #ebeef5;
}

.book-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.book-cover {
  width: 100%;
  height: 280px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  overflow: hidden;
}

.book-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.book-cover:hover img {
  transform: scale(1.05);
}

.no-cover {
  color: #999;
  font-size: 14px;
}

.book-info {
  padding: 15px;
}

.book-name {
  margin: 0 0 8px 0;
  font-size: 16px;
  font-weight: bold;
  color: #333;
  cursor: pointer;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.book-name:hover {
  color: #409eff;
}

.author {
  margin: 0 0 10px 0;
  font-size: 13px;
  color: #888;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.price {
  margin: 0;
  font-size: 20px;
  font-weight: bold;
  color: #ff4400;
}

.book-actions {
  padding: 0 15px 15px;
  display: flex;
  gap: 8px;
}

.book-actions .el-button {
  flex: 1;
  font-size: 12px;
}
</style>
