<template>
  <div class="book-list-page">
    <div class="book-list-header">
      <h2 v-if="filterType === 'hot'">热销推荐</h2>
      <h2 v-else-if="filterType === 'new'">新书上架</h2>
      <h2 v-else>全部图书</h2>
      <span class="book-count">共 {{ total }} 本图书</span>
    </div>

    <div class="category-filter">
      <div class="filter-section">
        <div class="filter-header">
          <span class="filter-label">分类筛选：</span>
          <el-button
            v-if="selectedFirstCategory || selectedSecondCategory"
            size="mini"
            type="text"
            @click="clearCategoryFilter"
            class="clear-btn"
          >
            <i class="el-icon-close"></i> 清除筛选
          </el-button>
        </div>

        <div class="category-tabs">
          <span
            class="category-tab"
            :class="{
              active: !selectedFirstCategory && !selectedSecondCategory,
            }"
            @click="selectFirstCategory(null)"
          >
            全部
          </span>
          <span
            v-for="cat in firstCategoryList"
            :key="cat.id"
            class="category-tab"
            :class="{
              active:
                selectedFirstCategory === cat.id && !selectedSecondCategory,
            }"
            @click="selectFirstCategory(cat.id)"
          >
            {{ cat.categoryName }}
          </span>
        </div>

        <transition name="fade-slide">
          <div v-if="selectedFirstCategory" class="sub-category-panel">
            <div class="sub-category-header">
              <span class="current-category">
                {{ getFirstCategoryName(selectedFirstCategory) }}
              </span>
              <span class="sub-category-tip">选择子分类：</span>
            </div>
            <div class="sub-category-tags">
              <span
                class="sub-category-tag"
                :class="{
                  active:
                    selectedSecondCategory === null && selectedFirstCategory,
                }"
                @click="selectSecondCategory(null)"
              >
                全部
              </span>
              <span
                v-for="cat in secondCategoryList"
                :key="cat.id"
                class="sub-category-tag"
                :class="{ active: selectedSecondCategory === cat.id }"
                @click="selectSecondCategory(cat.id)"
              >
                {{ cat.categoryName }}
              </span>
            </div>
          </div>
        </transition>
      </div>
    </div>

    <div
      class="search-result-tip"
      v-if="searchKeyword || category || selectedSecondCategory"
    >
      <span>搜索结果：</span>
      <el-tag
        v-if="searchKeyword"
        size="medium"
        type="primary"
        closable
        @close="clearKeyword"
      >
        关键词: {{ searchKeyword }}
      </el-tag>
      <span v-if="bookList.length" class="result-count"
        >共 {{ total }} 本图书</span
      >
      <el-button
        size="mini"
        @click="clearFilters"
        v-if="searchKeyword || category"
        >清除筛选</el-button
      >
    </div>

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
            :alt="book.bookName"
          />
          <div v-else class="no-cover">暂无封面</div>
          <div
            class="favorite-btn"
            :class="{ active: favoritedBooks[book.id] }"
            @click.stop="toggleFavorite(book, $event)"
          >
            <i
              :class="
                favoritedBooks[book.id] ? 'el-icon-star-on' : 'el-icon-star-off'
              "
            ></i>
          </div>
        </div>
        <div class="book-info">
          <h3 class="book-name">{{ book.bookName }}</h3>
          <p class="book-author">{{ book.author }}</p>
          <div class="book-meta">
            <span class="price">¥{{ book.price }}</span>
            <span class="sales">已售 {{ book.sales || 0 }}</span>
          </div>
          <div class="merchant-info" v-if="book.merchantName || book.shopName">
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
      <i class="el-icon-goods" style="font-size: 64px; color: #ddd"></i>
      <p v-if="keyword || category || selectedCategory">未找到符合条件的图书</p>
      <p v-else>暂无图书</p>
    </div>

    <div class="pagination-container" v-if="total > pageSize">
      <el-pagination
        @current-change="handlePageChange"
        :current-page="currentPage"
        :page-size="pageSize"
        :total="total"
        layout="prev, pager, next, jumper"
        :background="true"
      >
      </el-pagination>
    </div>
  </div>
</template>

<script>
import { getImageUrl } from "@/utils/img";

export default {
  name: "BookListPage",
  props: {
    keyword: {
      type: String,
      default: "",
    },
    category: {
      type: [Number, String],
      default: null,
    },
    filterType: {
      type: String,
      default: "",
      validator: (value) => ["", "hot", "new"].includes(value),
    },
  },
  data() {
    return {
      bookList: [],
      favoritedBooks: {},
      categoryList: [],
      selectedCategory: "",
      selectedFirstCategory: null,
      selectedSecondCategory: null,
      firstCategoryList: [],
      secondCategoryList: [],
      searchKeyword: "",
      currentPage: 1,
      pageSize: 8,
      total: 0,
    };
  },
  watch: {
    "$route.query.keyword": {
      handler(newKeyword) {
        this.searchKeyword = newKeyword || "";
        this.currentPage = 1; // 搜索时重置到第1页
        this.loadBookList();
      },
      immediate: true,
    },
    category() {
      this.currentPage = 1; // 分类变化时重置到第1页
      this.loadBookList();
    },
    filterType() {
      this.currentPage = 1; // 排序变化时重置到第1页
      this.loadBookList();
    },
    selectedFirstCategory() {
      this.currentPage = 1; // 一级分类变化时重置到第1页
      this.loadBookList();
    },
    selectedSecondCategory() {
      this.currentPage = 1; // 二级分类变化时重置到第1页
      this.loadBookList();
    },
    currentPage() {
      this.loadBookList();
    },
  },
  mounted() {
    this.loadBookList();
    this.loadCategories();
  },
  methods: {
    loadCategories() {
      this.$http.get("/category/list").then((res) => {
        if (res.code === 200) {
          this.categoryList = res.data || [];
          this.firstCategoryList = this.categoryList.filter(
            (cat) => cat.categoryLevel === 1
          );
          this.secondCategoryList = this.categoryList.filter(
            (cat) => cat.categoryLevel === 2
          );
        }
      });
    },
    selectFirstCategory(categoryId) {
      this.selectedFirstCategory = categoryId;
      this.selectedSecondCategory = null;
      if (categoryId) {
        this.secondCategoryList = this.categoryList.filter(
          (cat) => cat.categoryLevel === 2 && cat.parentId === categoryId
        );
      } else {
        this.secondCategoryList = this.categoryList.filter(
          (cat) => cat.categoryLevel === 2
        );
      }
      this.loadBookList();
    },
    selectSecondCategory(categoryId) {
      this.selectedSecondCategory = categoryId;
      this.loadBookList();
    },
    clearCategoryFilter() {
      this.selectedFirstCategory = null;
      this.selectedSecondCategory = null;
      this.secondCategoryList = this.categoryList.filter(
        (cat) => cat.categoryLevel === 2
      );
      this.loadBookList();
    },
    getFirstCategoryName(categoryId) {
      const category = this.firstCategoryList.find(
        (cat) => cat.id === categoryId
      );
      return category ? category.categoryName : "";
    },
    loadBookList() {
      let params = {
        page: this.currentPage,
        size: this.pageSize,
      };
      if (this.searchKeyword) {
        params.keyword = this.searchKeyword;
      }
      if (this.category) {
        params.categoryId = this.category;
      }
      // 只使用二级分类筛选
      if (this.selectedSecondCategory) {
        params.categoryId = this.selectedSecondCategory;
      } else if (this.selectedFirstCategory) {
        // 如果只选了一级分类，只查询该一级分类下的所有二级分类的图书
        const childIds = this.categoryList
          .filter((cat) => cat.parentId === this.selectedFirstCategory)
          .map((cat) => cat.id);
        if (childIds.length > 0) {
          params.categoryIds = childIds;
        }
      }
      if (this.filterType) {
        params.filterType = this.filterType;
      }
      this.$http.get("/book/list", { params }).then((res) => {
        if (res.code === 200) {
          let books = res.data.records || res.data || [];
          // 使用后端返回的总数，这个总数是全局搜索后的总数
          this.total = res.data.total || 0;
          if (this.filterType === "hot") {
            books = books.sort((a, b) => (b.sales || 0) - (a.sales || 0));
          } else if (this.filterType === "new") {
            books = books.sort(
              (a, b) => new Date(b.createTime) - new Date(a.createTime)
            );
          }
          this.bookList = books;
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
    goToDetail(id) {
      this.$router.push(`/home/book-detail/${id}`);
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
      this.$router
        .replace({ path: "/home/books" })
        .catch(() => Promise.resolve());
    },
    clearFilters() {
      if (this.searchKeyword || this.category) {
        this.$router
          .replace({ path: "/home/books" })
          .catch(() => Promise.resolve());
      }
      this.selectedCategory = "";
      this.selectedFirstCategory = null;
      this.selectedSecondCategory = null;
      this.secondCategoryList = this.categoryList.filter(
        (cat) => cat.categoryLevel === 2
      );
      this.currentPage = 1;
      this.loadBookList();
    },
    handlePageChange(page) {
      this.currentPage = page;
      window.scrollTo({ top: 0, behavior: "smooth" });
    },
  },
};
</script>

<style scoped>
.book-list-page {
  padding: 20px 0;
  max-width: 1200px;
  margin: 0 auto;
}

.book-list-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 3px solid #409eff;
}

.book-list-header h2 {
  margin: 0;
  font-size: 24px;
  color: #333;
}

.book-count {
  color: #999;
  font-size: 14px;
}

/* 分类筛选区域 - 胶囊标签式 */
.category-filter {
  margin-bottom: 24px;
  padding: 20px 24px;
  background: linear-gradient(135deg, #f8fafc 0%, #fff 100%);
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid #e8ecf0;
}

.filter-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.filter-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 12px;
  border-bottom: 1px solid #e8ecf0;
}

.filter-label {
  font-weight: 700;
  color: #1a1a2e;
  font-size: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-label::before {
  content: "";
  width: 4px;
  height: 16px;
  background: linear-gradient(180deg, #409eff 0%, #66b1ff 100%);
  border-radius: 2px;
}

.clear-btn {
  padding: 6px 14px;
  font-size: 12px;
  color: #909399;
  background: #f5f7fa;
  border: 1px solid #e4e7ed;
  border-radius: 20px;
  transition: all 0.3s;
}

.clear-btn:hover {
  color: #f56c6c;
  background: #fef0f0;
  border-color: #fde2e2;
}

/* 一级分类标签 - 胶囊式 */
.category-tabs {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
  padding: 4px 0;
}

.category-tab {
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 500;
  color: #606266;
  background: #fff;
  border: 2px solid #e4e7ed;
  border-radius: 24px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.category-tab::before {
  content: "";
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(64, 158, 255, 0.1),
    transparent
  );
  transition: left 0.5s;
}

.category-tab:hover {
  color: #409eff;
  border-color: #409eff;
  background: #ecf5ff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.2);
}

.category-tab:hover::before {
  left: 100%;
}

.category-tab.active {
  color: #fff;
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border-color: #409eff;
  box-shadow: 0 4px 16px rgba(64, 158, 255, 0.4);
  transform: translateY(-2px);
}

/* 二级分类展开面板 */
.sub-category-panel {
  padding: 16px 20px;
  background: linear-gradient(135deg, #f0f9eb 0%, #e8f5e9 100%);
  border-radius: 12px;
  border: 1px solid #c8e6c9;
  margin-top: 8px;
}

.sub-category-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 1px dashed #a5d6a7;
}

.current-category {
  padding: 6px 14px;
  font-size: 13px;
  font-weight: 600;
  color: #2e7d32;
  background: #fff;
  border-radius: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.sub-category-tip {
  font-size: 13px;
  color: #558b2f;
  font-weight: 500;
}

/* 二级分类标签 */
.sub-category-tags {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.sub-category-tag {
  padding: 8px 16px;
  font-size: 13px;
  font-weight: 500;
  color: #546e7a;
  background: #fff;
  border: 1px solid #b0bec5;
  border-radius: 18px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.sub-category-tag:hover {
  color: #4caf50;
  border-color: #4caf50;
  background: #e8f5e9;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(76, 175, 80, 0.2);
}

.sub-category-tag.active {
  color: #fff;
  background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
  border-color: #66bb6a;
  box-shadow: 0 4px 12px rgba(102, 187, 106, 0.4);
  transform: translateY(-1px);
}

/* 展开收起动画 */
.fade-slide-enter-active {
  animation: slideDown 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-slide-leave-active {
  animation: slideUp 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes slideDown {
  0% {
    opacity: 0;
    transform: translateY(-20px);
    max-height: 0;
  }
  100% {
    opacity: 1;
    transform: translateY(0);
    max-height: 500px;
  }
}

@keyframes slideUp {
  0% {
    opacity: 1;
    transform: translateY(0);
    max-height: 500px;
  }
  100% {
    opacity: 0;
    transform: translateY(-20px);
    max-height: 0;
  }
}

.search-result-tip {
  margin-bottom: 20px;
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

.book-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
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

.book-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.book-meta .price {
  font-size: 20px;
  color: #f56c6c;
  font-weight: bold;
}

.book-meta .sales {
  font-size: 13px;
  color: #999;
}

.merchant-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
  padding: 6px 0;
}

.merchant-badge {
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 600;
  color: #fff;
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

.merchant-name {
  font-size: 12px;
  color: #666;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.book-actions {
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

.empty p {
  margin: 10px 0;
  font-size: 16px;
}

.pagination-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 40px;
  padding: 24px 0;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.pagination-container /deep/ .el-pagination {
  font-weight: 500;
}

.pagination-container /deep/ .el-pagination .el-pager li {
  border-radius: 8px;
  transition: all 0.3s;
}

.pagination-container /deep/ .el-pagination .el-pager li:hover {
  background: #ecf5ff;
  color: #409eff;
}

.pagination-container /deep/ .el-pagination .el-pager li.active {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  color: #fff;
}

.pagination-container /deep/ .el-pagination .btn-prev,
.pagination-container /deep/ .el-pagination .btn-next {
  border-radius: 8px;
}

.pagination-container /deep/ .el-pagination .btn-prev:hover,
.pagination-container /deep/ .el-pagination .btn-next:hover {
  background: #ecf5ff;
  color: #409eff;
}
</style>
