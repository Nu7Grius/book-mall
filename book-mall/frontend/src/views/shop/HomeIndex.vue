<template>
  <div class="home-index">
    <div class="banner-section">
      <el-carousel
        :interval="5000"
        type="card"
        height="400px"
        v-if="noticeList.length > 0"
        indicator-position="outside"
        @change="handleCarouselChange"
      >
        <el-carousel-item v-for="notice in noticeList" :key="notice.id">
          <div
            class="banner-item"
            :class="getNoticeBannerClass(notice.noticeType)"
            @click="handleNoticeClick(notice)"
          >
            <div class="banner-background">
              <img
                v-if="notice.coverImage"
                :src="getImageUrl(notice.coverImage)"
                :alt="notice.title"
                class="banner-cover-img"
              />
            </div>
            <div class="banner-overlay"></div>
            <div class="banner-content-wrapper">
              <div class="banner-badge">
                <span
                  class="badge-icon"
                  :class="getNoticeTypeClass(notice.noticeType)"
                >
                  {{ getNoticeTypeName(notice.noticeType) }}
                </span>
                <span class="badge-time">{{
                  formatTime(notice.publishTime)
                }}</span>
              </div>
              <div class="banner-content">
                <h2 class="banner-title">{{ notice.title }}</h2>
                <p class="banner-text">{{ stripHtml(notice.content) }}</p>
                <div class="banner-footer">
                  <span class="view-more"
                    >点击查看详情 <i class="el-icon-arrow-right"></i
                  ></span>
                </div>
              </div>
            </div>
          </div>
        </el-carousel-item>
      </el-carousel>
      <div v-else class="no-banners">
        <i class="el-icon-magic-stick" style="font-size: 48px; color: #ddd"></i>
        <p>暂无公告信息</p>
        <span class="hint">管理员可以在后台发布公告</span>
      </div>
    </div>

    <div class="search-results-section" v-if="searchKeyword">
      <div class="search-results-header">
        <h2>搜索结果：{{ searchKeyword }}</h2>
        <span class="search-count"
          >共找到 {{ searchResults.length }} 本图书</span
        >
        <el-button type="text" @click="clearSearch">
          <i class="el-icon-close"></i> 清除搜索
        </el-button>
      </div>
      <div class="search-results-grid" v-if="searchResults.length > 0">
        <div
          v-for="book in searchResults"
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
      <div v-else class="no-results">
        <i class="el-icon-search"></i>
        <p>未找到相关图书</p>
        <span>换个关键词试试吧</span>
      </div>
    </div>

    <div v-else>
      <div class="hot-books-section">
        <div class="section-header">
          <div class="section-title">
            <h2><i class="el-icon-s-goods"></i> 热销推荐</h2>
            <span class="section-desc">精选畅销好书，为您推荐</span>
          </div>
          <el-button type="text" @click="$router.push('/home/books/hot')">
            查看更多 <i class="el-icon-arrow-right"></i>
          </el-button>
        </div>
        <div class="hot-books-grid" v-if="hotBooks.length > 0">
          <div
            v-for="book in hotBooks"
            :key="book.id"
            class="hot-book-card"
            @click="goToDetail(book.id)"
          >
            <div class="hot-book-cover">
              <img
                v-if="book.coverImage"
                :src="getImageUrl(book.coverImage)"
                :alt="book.bookName"
              />
              <div v-else class="no-cover">暂无封面</div>
              <div class="hot-tag">热销</div>
            </div>
            <div class="hot-book-info">
              <h3 class="book-name">{{ book.bookName }}</h3>
              <p class="book-author">{{ book.author }}</p>
              <div class="book-price-row">
                <span class="price">¥{{ book.price }}</span>
                <span class="sales">已售 {{ book.sales || 0 }}</span>
              </div>
              <div
                class="merchant-info"
                v-if="book.merchantName || book.shopName"
              >
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
          </div>
        </div>
        <div v-else class="no-books">
          <p>暂无热销图书</p>
        </div>
      </div>

      <div class="new-books-section">
        <div class="section-header">
          <div class="section-title">
            <h2><i class="el-icon-time"></i> 新书上架</h2>
            <span class="section-desc">最新入库，好书不容错过</span>
          </div>
          <el-button type="text" @click="$router.push('/home/books/new')">
            查看更多 <i class="el-icon-arrow-right"></i>
          </el-button>
        </div>
        <div class="new-books-grid" v-if="newBooks.length > 0">
          <div
            v-for="book in newBooks"
            :key="book.id"
            class="new-book-card"
            @click="goToDetail(book.id)"
          >
            <div class="new-book-cover">
              <img
                v-if="book.coverImage"
                :src="getImageUrl(book.coverImage)"
                :alt="book.bookName"
              />
              <div v-else class="no-cover">暂无封面</div>
              <div class="new-tag">新书</div>
            </div>
            <div class="new-book-info">
              <h3 class="book-name">{{ book.bookName }}</h3>
              <p class="book-author">{{ book.author }}</p>
              <span class="price">¥{{ book.price }}</span>
              <div
                class="merchant-info"
                v-if="book.merchantName || book.shopName"
              >
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
          </div>
        </div>
        <div v-else class="no-books">
          <p>暂无新书</p>
        </div>
      </div>

      <div class="quick-links">
        <el-button
          type="primary"
          size="large"
          @click="$router.push('/home/books')"
        >
          <i class="el-icon-reading"></i> 浏览全部图书
        </el-button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "HomeIndex",
  data() {
    return {
      noticeList: [],
      hotBooks: [],
      newBooks: [],
      searchKeyword: "",
      searchResults: [],
    };
  },
  watch: {
    "$route.query.keyword": {
      handler(newKeyword) {
        if (newKeyword) {
          this.searchKeyword = newKeyword;
          this.loadSearchResults(newKeyword);
        } else {
          this.searchKeyword = "";
          this.searchResults = [];
        }
      },
      immediate: true,
    },
  },
  mounted() {
    this.loadNotices();
    this.loadHotBooks();
    this.loadNewBooks();
    this.startNoticeAutoRefresh();
  },
  beforeDestroy() {
    this.stopNoticeAutoRefresh();
  },
  methods: {
    startNoticeAutoRefresh() {
      this.noticeTimer = setInterval(() => {
        if (!document.hidden) {
          this.loadNotices();
        }
      }, 30000);
    },
    stopNoticeAutoRefresh() {
      if (this.noticeTimer) {
        clearInterval(this.noticeTimer);
        this.noticeTimer = null;
      }
    },
    loadNotices() {
      this.$http.get("/notice/list", { params: { status: 1 } }).then((res) => {
        if (res.code === 200) {
          this.noticeList = res.data || [];
        }
      });
    },
    stripHtml(html) {
      if (!html) return "";
      const div = document.createElement("div");
      div.innerHTML = html;
      return div.textContent || div.innerText || "";
    },
    getNoticeTypeName(type) {
      const typeMap = {
        promotion: "促销活动",
        activity: "精彩活动",
        news: "行业资讯",
        notice: "通知公告",
        system: "系统消息",
      };
      return typeMap[type] || "公告";
    },
    getNoticeTypeClass(type) {
      const classMap = {
        promotion: "promotion",
        activity: "activity",
        news: "news",
        notice: "notice",
        system: "system",
      };
      return classMap[type] || "notice";
    },
    getNoticeBannerClass(type) {
      const classMap = {
        promotion: "banner-promotion",
        activity: "banner-activity",
        news: "banner-news",
        notice: "banner-notice",
        system: "banner-system",
      };
      return classMap[type] || "banner-notice";
    },
    getNoticeOverlayClass(type) {
      const classMap = {
        promotion: "overlay-promotion",
        activity: "overlay-activity",
        news: "overlay-news",
        notice: "overlay-notice",
        system: "overlay-system",
      };
      return classMap[type] || "overlay-notice";
    },
    formatTime(time) {
      if (!time) return "";
      const date = new Date(time);
      const year = date.getFullYear();
      const month = (date.getMonth() + 1).toString().padStart(2, "0");
      const day = date.getDate().toString().padStart(2, "0");
      return `${year}-${month}-${day}`;
    },
    handleNoticeClick(notice) {
      this.$message.info("公告详情：" + notice.title);
    },
    handleCarouselChange() {},
    loadSearchResults(keyword) {
      this.$http
        .get("/book/list", { params: { keyword: keyword } })
        .then((res) => {
          if (res.code === 200) {
            this.searchResults = res.data || [];
          }
        });
    },
    clearSearch() {
      this.searchKeyword = "";
      this.searchResults = [];
      this.$router.push("/home").catch(() => Promise.resolve());
    },
    loadAllBooks() {
      this.$http.get("/book/list").then((res) => {
        if (res.code === 200) {
          const books = res.data || [];
          this.allHotBooks = books.sort(
            (a, b) => (b.sales || 0) - (a.sales || 0)
          );
          this.allNewBooks = books;
          this.hotBooks = this.allHotBooks.slice(0, this.hotDisplayCount);
          this.newBooks = this.allNewBooks.slice(0, this.newDisplayCount);
        }
      });
    },
    loadHotBooks() {
      this.$http
        .get("/book/list", { params: { filterType: "hot", size: 4 } })
        .then((res) => {
          if (res.code === 200) {
            const books = res.data.records || res.data || [];
            this.hotBooks = books.slice(0, 4);
          }
        });
    },
    loadNewBooks() {
      this.$http
        .get("/book/list", { params: { filterType: "new", size: 4 } })
        .then((res) => {
          if (res.code === 200) {
            const books = res.data.records || res.data || [];
            this.newBooks = books.slice(0, 4);
          }
        });
    },
    loadMoreHotBooks() {
      this.showAllHotBooks = !this.showAllHotBooks;
      if (this.showAllHotBooks) {
        this.hotDisplayCount = this.allHotBooks.length;
        this.hotBooks = this.allHotBooks.slice(0, this.hotDisplayCount);
      } else {
        this.hotDisplayCount = 8;
        this.hotBooks = this.allHotBooks.slice(0, 8);
      }
    },
    loadMoreNewBooks() {
      this.showAllNewBooks = !this.showAllNewBooks;
      if (this.showAllNewBooks) {
        this.newDisplayCount = this.allNewBooks.length;
        this.newBooks = this.allNewBooks.slice(0, this.newDisplayCount);
      } else {
        this.newDisplayCount = 8;
        this.newBooks = this.allNewBooks.slice(0, 8);
      }
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
    goToDetail(id) {
      this.$router.push(`/home/book-detail/${id}`);
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
  },
};
</script>

<style scoped>
.home-index {
  padding-bottom: 40px;
}

.banner-section {
  max-width: 1200px;
  margin: 0 auto 40px;
  padding: 20px 0;
}

.banner-item {
  height: 100%;
  border-radius: 16px;
  padding: 40px 50px;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  flex-direction: column;
  justify-content: center;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
}

.banner-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
}

.banner-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 16px;
  overflow: hidden;
}

.banner-cover-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}

.banner-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 16px;
  background: linear-gradient(
    135deg,
    rgba(0, 0, 0, 0.7) 0%,
    rgba(0, 0, 0, 0.3) 100%
  );
  z-index: 0;
}

.banner-content-wrapper {
  position: relative;
  z-index: 1;
  max-width: 900px;
  margin: 0 auto;
}

.banner-promotion {
  background: linear-gradient(135deg, #ff6b6b 0%, #ff8e53 100%);
}

.banner-activity {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.banner-news {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.banner-notice {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.banner-system {
  background: linear-gradient(135deg, #4facfe 0%, #43e97b 100%);
}

.banner-content-wrapper {
  max-width: 900px;
  margin: 0 auto;
}

.banner-badge {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
}

.badge-icon {
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: bold;
  color: #fff;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.badge-icon.promotion {
  background: rgba(255, 255, 255, 0.3);
}

.badge-icon.activity {
  background: rgba(255, 255, 255, 0.3);
}

.badge-icon.news {
  background: rgba(255, 255, 255, 0.3);
}

.badge-icon.notice {
  background: rgba(255, 255, 255, 0.3);
}

.badge-icon.system {
  background: rgba(255, 255, 255, 0.3);
}

.badge-time {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
}

.banner-content {
  color: #fff;
}

.banner-title {
  font-size: 32px;
  margin: 0 0 20px 0;
  font-weight: bold;
  line-height: 1.4;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

.banner-text {
  font-size: 16px;
  line-height: 1.8;
  margin: 0 0 24px 0;
  opacity: 0.95;
  max-height: 100px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

.banner-footer {
  display: flex;
  justify-content: flex-end;
}

.view-more {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s;
}

.banner-item:hover .view-more {
  transform: translateX(8px);
}

.no-banners {
  text-align: center;
  padding: 80px 0;
  background: #f9f9f9;
  border-radius: 12px;
  color: #999;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.no-banners .hint {
  font-size: 12px;
  color: #bbb;
}

.section-header {
  max-width: 1200px;
  margin: 0 auto 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 16px;
  border-bottom: 3px solid #409eff;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 16px;
}

.section-header h2 {
  margin: 0;
  font-size: 24px;
  color: #333;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-header h2 i {
  color: #409eff;
}

.section-desc {
  color: #999;
  font-size: 14px;
}

.section-header .el-button {
  color: #409eff;
  font-size: 14px;
  transition: all 0.3s;
}

.section-header .el-button:hover {
  color: #66b1ff;
  transform: translateX(4px);
}

.hot-books-section,
.new-books-section {
  max-width: 1200px;
  margin: 0 auto 40px;
}

.hot-books-grid,
.new-books-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.hot-book-card,
.new-book-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s;
  cursor: pointer;
}

.hot-book-card:hover,
.new-book-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.hot-book-cover,
.new-book-cover {
  position: relative;
  width: 100%;
  height: 240px;
  overflow: hidden;
}

.hot-book-cover img,
.new-book-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.hot-book-card:hover .hot-book-cover img,
.new-book-card:hover .new-book-cover img {
  transform: scale(1.05);
}

.hot-tag,
.new-tag {
  position: absolute;
  top: 10px;
  left: 10px;
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
  color: #fff;
}

.hot-tag {
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
}

.new-tag {
  background: linear-gradient(135deg, #26de81 0%, #20bf6b 100%);
}

.hot-book-info,
.new-book-info {
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

.hot-book-card:hover .book-name,
.new-book-card:hover .book-name {
  color: #409eff;
}

.book-author {
  margin: 0 0 12px 0;
  font-size: 13px;
  color: #888;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.book-price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.price {
  font-size: 20px;
  font-weight: bold;
  color: #ff4400;
}

.sales {
  font-size: 12px;
  color: #999;
}

.no-books {
  text-align: center;
  padding: 60px 0;
  background: #f9f9f9;
  border-radius: 12px;
  color: #999;
}

.quick-links {
  text-align: center;
  padding: 40px 0;
  max-width: 1200px;
  margin: 0 auto;
}

.quick-links .el-button {
  padding: 16px 48px;
  font-size: 18px;
  border-radius: 30px;
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border: none;
  transition: all 0.3s;
}

.quick-links .el-button:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 16px rgba(64, 158, 255, 0.4);
}

/* 搜索结果样式 */
.search-results-section {
  max-width: 1200px;
  margin: 0 auto 40px;
  animation: fadeIn 0.3s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.search-results-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 3px solid #409eff;
}

.search-results-header h2 {
  margin: 0;
  font-size: 24px;
  color: #333;
}

.search-count {
  color: #999;
  font-size: 14px;
}

.search-results-header .el-button {
  margin-left: auto;
  color: #909399;
  font-size: 13px;
}

.search-results-header .el-button:hover {
  color: #f56c6c;
}

.search-results-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.book-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s;
  cursor: pointer;
}

.book-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.book-cover {
  position: relative;
  width: 100%;
  height: 240px;
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
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  color: #999;
  font-size: 14px;
}

.book-info {
  padding: 16px;
}

.book-price {
  margin: 8px 0;
  font-size: 20px;
  font-weight: bold;
  color: #ff4400;
}

.book-actions {
  display: flex;
  gap: 8px;
  margin-top: 12px;
}

.book-actions .el-button {
  flex: 1;
  padding: 8px 0;
  font-size: 13px;
}

.no-results {
  text-align: center;
  padding: 80px 0;
  background: #f9f9f9;
  border-radius: 12px;
  color: #999;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.no-results i {
  font-size: 64px;
  color: #ddd;
  margin-bottom: 16px;
}

.no-results p {
  font-size: 18px;
  margin: 0;
}

.no-results span {
  font-size: 14px;
  color: #bbb;
}

.merchant-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px dashed #f0f0f0;
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
</style>
