<template>
  <view class="home-container">
    <!-- 搜索栏 -->
    <view class="search-bar">
      <view class="search-input" @click="goToSearch">
        <text class="icon">🔍</text>
        <text class="placeholder">搜索图书</text>
      </view>
      <view class="category-btn" @click="showCategorySelector">
        <text class="icon">📂</text>
        <text class="text">分类</text>
      </view>
    </view>

    <!-- 分类选择弹窗 -->
    <view class="category-popup" v-if="showCategoryPopup" @touchmove.stop>
      <view class="popup-mask" @click="closeCategoryPopup"></view>
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">选择分类</text>
          <text class="popup-close" @click="closeCategoryPopup">✕</text>
        </view>
        <view class="popup-body">
          <!-- 一级分类 -->
          <scroll-view scroll-y class="level1-list">
            <view
              class="level1-item"
              :class="{ active: currentLevel1 && currentLevel1.id === item.id }"
              v-for="item in categoryList"
              :key="item.id"
              @click="selectLevel1(item)"
            >
              <text class="emoji">{{
                getCategoryEmoji(item.categoryName)
              }}</text>
              <text class="name">{{ item.categoryName }}</text>
            </view>
          </scroll-view>
          <!-- 二级分类 -->
          <scroll-view scroll-y class="level2-list">
            <view class="level2-header" v-if="currentLevel1">
              <text class="title">{{ currentLevel1.categoryName }}</text>
              <text class="subtitle"
                >共 {{ (currentLevel1.children || []).length }} 个子类</text
              >
            </view>
            <view
              class="level2-grid"
              v-if="
                currentLevel1 &&
                currentLevel1.children &&
                currentLevel1.children.length > 0
              "
            >
              <view
                class="level2-item"
                v-for="item in currentLevel1.children"
                :key="item.id"
                @click="selectLevel2(item)"
              >
                <text class="emoji">{{
                  getCategoryEmoji(item.categoryName)
                }}</text>
                <text class="name">{{ item.categoryName }}</text>
              </view>
            </view>
            <view
              class="level2-all"
              v-if="currentLevel1"
              @click="goToBookList(currentLevel1)"
            >
              <text class="icon">📚</text>
              <text class="text"
                >查看全部「{{ currentLevel1.categoryName }}」图书</text
              >
            </view>
            <view class="level2-empty" v-if="!currentLevel1">
              <text class="icon">👈</text>
              <text class="text">请选择左侧一级分类</text>
            </view>
          </scroll-view>
        </view>
      </view>
    </view>

    <!-- 轮播图 -->
    <view class="banner-section">
      <swiper
        class="banner-swiper"
        indicator-dots
        autoplay
        circular
        v-if="banners.length > 0"
      >
        <swiper-item v-for="(banner, index) in banners" :key="index">
          <view
            class="banner-item"
            :class="'banner-' + (banner.noticeType || 'notice')"
          >
            <!-- 背景图片 -->
            <image
              v-if="banner.coverImage"
              class="banner-bg"
              :src="banner.coverImage"
              mode="aspectFill"
            ></image>

            <!-- 渐变遮罩 -->
            <view class="banner-overlay"></view>

            <!-- 内容 -->
            <view class="banner-content">
              <view class="banner-badge">
                <text class="badge-icon" :class="banner.noticeType || 'notice'">
                  {{ getTypeName(banner.noticeType) }}
                </text>
                <text class="badge-time">{{
                  formatTime(banner.publishTime)
                }}</text>
              </view>
              <view class="banner-text-content">
                <text class="banner-title">{{ banner.title }}</text>
                <text class="banner-text">{{ stripHtml(banner.content) }}</text>
              </view>
            </view>
          </view>
        </swiper-item>
      </swiper>
      <view v-else class="no-banners">
        <text class="no-banners-icon">📢</text>
        <text class="no-banners-text">暂无公告信息</text>
        <text class="no-banners-hint">管理员可以在后台发布公告</text>
      </view>
    </view>

    <!-- 热门图书 -->
    <view class="section">
      <view class="section-header">
        <text class="section-title">热门图书</text>
        <text class="section-more" @click="goToBookList">更多 ></text>
      </view>
      <scroll-view scroll-x class="book-scroll">
        <view
          class="book-card"
          v-for="item in hotBooks"
          :key="item.id"
          @click="goToDetail(item.id)"
        >
          <image
            class="book-cover"
            :src="item.coverImage"
            mode="aspectFill"
            @error="onImageError"
          ></image>
          <text class="book-name">{{ item.bookName }}</text>
          <text class="book-price">¥{{ item.price }}</text>
        </view>
      </scroll-view>
    </view>

    <!-- 新书上架 -->
    <view class="section">
      <view class="section-header">
        <text class="section-title">新书上架</text>
        <text class="section-more" @click="goToBookList">更多 ></text>
      </view>
      <scroll-view scroll-x class="book-scroll">
        <view
          class="book-card"
          v-for="item in newBooks"
          :key="item.id"
          @click="goToDetail(item.id)"
        >
          <image
            class="book-cover"
            :src="item.coverImage"
            mode="aspectFill"
            @error="onImageError"
          ></image>
          <text class="book-name">{{ item.bookName }}</text>
          <text class="book-price">¥{{ item.price }}</text>
        </view>
      </scroll-view>
    </view>

    <!-- 推荐图书 -->
    <view class="section">
      <view class="section-header">
        <text class="section-title">推荐图书</text>
        <text class="section-more" @click="goToBookList">更多 ></text>
      </view>
      <view class="book-list">
        <view
          class="book-list-item"
          v-for="item in recommendBooks"
          :key="item.id"
          @click="goToDetail(item.id)"
        >
          <image
            class="book-cover"
            :src="item.coverImage"
            mode="aspectFill"
            @error="onImageError"
          ></image>
          <view class="book-detail">
            <text class="book-name">{{ item.bookName }}</text>
            <text class="book-author">{{ item.author }}</text>
            <text class="book-desc text-ellipsis-2">{{
              formatBookDesc(item.description)
            }}</text>
            <view class="book-bottom">
              <text class="book-price">¥{{ item.price }}</text>
              <text class="book-sales">已售 {{ item.sales || 0 }}</text>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 加载更多 -->
    <view class="loading-more" v-if="loading">
      <text>加载中...</text>
    </view>
  </view>
</template>

<script>
import { getCategoryList, getHotBooks, getBookList } from "../../api/book.js";
import { getNoticeList } from "../../api/notice.js";
import { getImageUrl } from "../../utils/image.js";
import {
  formatDescriptionForCard,
  containsHtmlTags,
} from "../../utils/format.js";

export default {
  data() {
    return {
      categoryList: [],
      hotBooks: [],
      newBooks: [],
      recommendBooks: [],
      banners: [],
      loading: false,
      showCategoryPopup: false,
      currentLevel1: null,
    };
  },
  onLoad() {
    this.loadData();
  },
  onShareAppMessage(res) {
    return {
      title: "OpenBook - 发现更多好书",
      path: "/pages/home/home",
      imageUrl: "/static/icons/logo.png",
    };
  },
  methods: {
    showCategorySelector() {
      this.showCategoryPopup = true;
    },
    closeCategoryPopup() {
      this.showCategoryPopup = false;
    },
    selectLevel1(item) {
      this.currentLevel1 = item;
    },
    selectLevel2(item) {
      this.showCategoryPopup = false;
      uni.navigateTo({
        url: `/pages/book-list/book-list?categoryId=${item.id}&categoryName=${item.categoryName}`,
      });
    },
    formatBookDesc(desc) {
      if (!desc) return "";
      if (containsHtmlTags(desc)) {
        return formatDescriptionForCard(desc, 2);
      }
      return desc;
    },
    async loadData() {
      this.loading = true;
      try {
        await Promise.all([
          this.loadCategories(),
          this.loadBanners(),
          this.loadHotBooks(),
          this.loadNewBooks(),
          this.loadRecommendBooks(),
        ]);
      } catch (error) {
        console.error("加载数据失败:", error);
      } finally {
        this.loading = false;
      }
    },
    async loadBanners() {
      try {
        const res = await getNoticeList({ status: 1 });

        if (res && res.data && res.data.length > 0) {
          this.banners = res.data.map((notice) => {
            return {
              coverImage: notice.coverImage || null,
              title: notice.title || "",
              content: notice.content || "",
              noticeType: notice.noticeType || "notice",
              publishTime: notice.publishTime || new Date().toISOString(),
            };
          });
        } else {
          this.banners = this.getDefaultBanners();
        }
      } catch (error) {
        console.error("加载轮播图失败:", error);
        this.banners = this.getDefaultBanners();
      }
    },
    getDefaultBanners() {
      return [
        {
          coverImage: null,
          title: "欢迎来到OpenBook",
          content: "发现更多好书",
          noticeType: "notice",
          publishTime: new Date().toISOString(),
        },
        {
          coverImage: null,
          title: "海量图书等你来选",
          content: "优质书籍推荐",
          noticeType: "activity",
          publishTime: new Date().toISOString(),
        },
        {
          coverImage: null,
          title: "新书上架，优惠多多",
          content: "限时优惠活动",
          noticeType: "promotion",
          publishTime: new Date().toISOString(),
        },
      ];
    },
    async loadCategories() {
      try {
        const res = await getCategoryList();
        if (res.code === 200) {
          this.categoryList = res.data || [];
        }
      } catch (error) {
        console.error("加载分类失败:", error);
      }
    },
    async loadHotBooks() {
      try {
        const res = await getHotBooks(10);
        if (res.code === 200) {
          this.hotBooks = this.processBookImages(res.data || []);
        }
      } catch (error) {
        console.error("加载热门图书失败:", error);
      }
    },
    async loadNewBooks() {
      try {
        const res = await getBookList({
          page: 1,
          size: 6,
          sort: "createTime",
          order: "desc",
        });
        if (res.code === 200) {
          this.newBooks = this.processBookImages(res.data.records || []);
        }
      } catch (error) {
        console.error("加载新书失败:", error);
      }
    },
    async loadRecommendBooks() {
      try {
        const res = await getBookList({
          page: 1,
          size: 10,
          recommend: true,
        });
        if (res.code === 200) {
          this.recommendBooks = this.processBookImages(res.data.records || []);
        }
      } catch (error) {
        console.error("加载推荐图书失败:", error);
      }
    },
    processBookImages(bookList) {
      return bookList.map((item) => ({
        ...item,
        coverImage: item.coverImage
          ? getImageUrl(item.coverImage)
          : "/static/default-cover.png",
      }));
    },
    goToSearch() {
      uni.navigateTo({
        url: "/pages/book-list/book-list?search=true",
      });
    },
    goToBookList(category) {
      if (!category) {
        uni.navigateTo({
          url: "/pages/book-list/book-list",
        });
      } else {
        const url = `/pages/book-list/book-list?categoryId=${category.id}&categoryName=${category.categoryName}`;
        uni.navigateTo({
          url: url,
        });
      }
    },
    goToDetail(id) {
      uni.navigateTo({
        url: `/pages/book-detail/book-detail?id=${id}`,
      });
    },
    getCategoryEmoji(categoryName) {
      const emojiMap = {
        文学: "📚",
        小说: "📖",
        科幻: "🚀",
        历史: "🏛️",
        哲学: "💡",
        心理: "🧠",
        经济: "💰",
        管理: "📊",
        计算机: "💻",
        技术: "⚙️",
        互联网: "🌐",
        艺术: "🎨",
        设计: "✒️",
        摄影: "📷",
        音乐: "🎵",
        体育: "⚽",
        健身: "💪",
        旅游: "✈️",
        美食: "🍜",
        教育: "🎓",
        考试: "📝",
        童书: "👶",
        绘本: "📕",
        生活: "🏠",
        婚恋: "💑",
        两性: "💕",
        时尚: "👗",
        家居: "🛋️",
        保健: "🏥",
        中医: "🌿",
        成功: "🏆",
        励志: "💪",
        职场: "💼",
        投资: "📈",
        理财: "💵",
      };
      const name = categoryName || "";
      for (const key in emojiMap) {
        if (name.includes(key)) {
          return emojiMap[key];
        }
      }
      return "📚";
    },
    getCategoryColor(categoryName) {
      const colorMap = [
        "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
        "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)",
        "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)",
        "linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)",
        "linear-gradient(135deg, #fa709a 0%, #fee140 100%)",
        "linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)",
        "linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)",
        "linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)",
        "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
        "linear-gradient(135deg, #f5576c 0%, #f093fb 100%)",
        "linear-gradient(135deg, #4facfe 0%, #43e97b 100%)",
        "linear-gradient(135deg, #38f9d7 0%, #4facfe 100%)",
      ];
      const name = categoryName || "";
      let hash = 0;
      for (let i = 0; i < name.length; i++) {
        hash = (hash << 5) - hash + name.charCodeAt(i);
        hash = hash & hash;
      }
      return colorMap[Math.abs(hash) % colorMap.length];
    },
    onImageError(e) {
      e.target.src = "/static/default-cover.png";
    },
    getNoticeBannerClass(type) {
      const classMap = {
        promotion: "banner-promotion",
        activity: "banner-activity",
        news: "banner-news",
        notice: "banner-notice",
        system: "banner-system",
        maintenance: "banner-maintenance",
      };
      return classMap[type] || "banner-notice";
    },
    getNoticeTypeClass(type) {
      const classMap = {
        promotion: "promotion",
        activity: "activity",
        news: "news",
        notice: "notice",
        system: "system",
        maintenance: "maintenance",
      };
      return classMap[type] || "notice";
    },
    getTypeName(type) {
      const typeMap = {
        promotion: "促销",
        activity: "活动",
        news: "新闻",
        notice: "公告",
        system: "系统",
        maintenance: "维护",
      };
      return typeMap[type] || "公告";
    },
    formatTime(time) {
      if (!time) return "";
      const date = new Date(time);
      const year = date.getFullYear();
      const month = (date.getMonth() + 1).toString().padStart(2, "0");
      const day = date.getDate().toString().padStart(2, "0");
      return `${year}-${month}-${day}`;
    },
    stripHtml(str) {
      if (!str) return "";
      return str.replace(/<[^>]+>/g, "").substring(0, 100);
    },
  },
};
</script>

<style scoped>
.home-container {
  background-color: #f5f5f5;
  min-height: 100vh;
}

.search-bar {
  display: flex;
  align-items: center;
  padding: 20rpx 30rpx;
  background-color: #15803d;
  gap: 20rpx;
}

.search-input {
  flex: 1;
  display: flex;
  align-items: center;
  height: 72rpx;
  background-color: #fff;
  border-radius: 36rpx;
  padding: 0 30rpx;
}

.search-input .icon {
  font-size: 28rpx;
  margin-right: 16rpx;
}

.search-input .placeholder {
  font-size: 28rpx;
  color: #999;
}

.category-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8rpx 16rpx;
  background-color: rgba(255, 255, 255, 0.2);
  border-radius: 12rpx;
}

.category-btn .icon {
  font-size: 32rpx;
}

.category-btn .text {
  font-size: 20rpx;
  color: #fff;
  margin-top: 4rpx;
}

/* 分类选择弹窗 */
.category-popup {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 999;
}

.popup-mask {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
}

.popup-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 70vh;
  background-color: #fff;
  border-radius: 32rpx 32rpx 0 0;
}

.popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 32rpx;
  border-bottom: 1px solid #f0f0f0;
}

.popup-title {
  font-size: 34rpx;
  font-weight: bold;
  color: #333;
}

.popup-close {
  font-size: 48rpx;
  color: #999;
  padding: 0 20rpx;
}

.popup-body {
  display: flex;
  height: calc(70vh - 120rpx);
}

/* 一级分类 */
.level1-list {
  width: 200rpx;
  background-color: #f8f8f8;
}

.level1-item {
  display: flex;
  align-items: center;
  padding: 28rpx 20rpx;
  border-left: 6rpx solid transparent;
}

.level1-item .emoji {
  font-size: 36rpx;
  margin-right: 12rpx;
}

.level1-item .name {
  font-size: 28rpx;
  color: #666;
}

.level1-item.active {
  background-color: #fff;
  color: #15803d;
  font-weight: bold;
  border-left-color: #15803d;
}

.level1-item.active .name {
  color: #15803d;
}

/* 二级分类 */
.level2-list {
  flex: 1;
  padding: 24rpx;
  background-color: #fff;
}

.level2-header {
  margin-bottom: 24rpx;
  padding-bottom: 20rpx;
  border-bottom: 1px solid #f0f0f0;
}

.level2-header .title {
  display: block;
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 8rpx;
}

.level2-header .subtitle {
  font-size: 24rpx;
  color: #999;
}

.level2-grid {
  display: flex;
  flex-wrap: wrap;
}

.level2-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 140rpx;
  padding: 20rpx;
  margin: 0 16rpx 16rpx 0;
  background-color: #f5f5f5;
  border-radius: 16rpx;
}

.level2-item .emoji {
  font-size: 48rpx;
  margin-bottom: 12rpx;
}

.level2-item .name {
  font-size: 24rpx;
  color: #666;
  text-align: center;
}

.level2-item:active {
  background-color: #e8f5e9;
}

.level2-item:active .name {
  color: #15803d;
}

.level2-all {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24rpx;
  margin-top: 20rpx;
  background: linear-gradient(135deg, #15803d 0%, #22c55e 100%);
  border-radius: 16rpx;
}

.level2-all .icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.level2-all .text {
  font-size: 28rpx;
  color: #fff;
  font-weight: bold;
}

.level2-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 300rpx;
  color: #999;
}

.level2-empty .icon {
  font-size: 64rpx;
  margin-bottom: 20rpx;
}

.level2-empty .text {
  font-size: 28rpx;
}

.banner-section {
  padding: 20rpx 30rpx;
}

.banner-swiper {
  height: 300rpx;
  border-radius: 16rpx;
  overflow: hidden;
}

.banner-image {
  width: 100%;
  height: 100%;
}

.section {
  background-color: #fff;
  margin-top: 20rpx;
  padding: 30rpx;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.section-more {
  font-size: 26rpx;
  color: #999;
}

.book-scroll {
  white-space: nowrap;
}

.book-card {
  display: inline-block;
  width: 200rpx;
  margin-right: 20rpx;
}

.book-cover {
  width: 200rpx;
  height: 280rpx;
  border-radius: 12rpx;
  background-color: #f5f5f5;
}

.book-name {
  display: block;
  font-size: 26rpx;
  color: #333;
  margin-top: 16rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.book-price {
  display: block;
  font-size: 28rpx;
  color: #15803d;
  font-weight: bold;
  margin-top: 8rpx;
}

.book-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

.book-item {
  width: 48%;
  margin-bottom: 30rpx;
}

.book-item .book-cover {
  width: 100%;
  height: 400rpx;
}

.book-info {
  padding: 16rpx 0;
}

.book-author {
  display: block;
  font-size: 24rpx;
  color: #999;
  margin-top: 8rpx;
}

.book-list {
  display: flex;
  flex-direction: column;
}

.book-list-item {
  display: flex;
  padding: 20rpx 0;
  border-bottom: 1px solid #f5f5f5;
}

.book-list-item:last-child {
  border-bottom: none;
}

.book-list-item .book-cover {
  width: 160rpx;
  height: 220rpx;
  border-radius: 12rpx;
  flex-shrink: 0;
}

.book-detail {
  flex: 1;
  margin-left: 24rpx;
  display: flex;
  flex-direction: column;
  min-width: 0;
  overflow: hidden;
}

.book-desc {
  font-size: 24rpx;
  color: #666;
  margin-top: 12rpx;
  line-height: 1.5;
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  text-overflow: ellipsis;
  word-break: break-all;
}

.book-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
  padding-top: 16rpx;
  flex-shrink: 0;
}

.book-bottom .book-price {
  flex-shrink: 0;
  max-width: 50%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.book-sales {
  font-size: 24rpx;
  color: #999;
  flex-shrink: 0;
  max-width: 45%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.loading-more {
  text-align: center;
  padding: 30rpx;
  color: #999;
  font-size: 26rpx;
}

/* 轮播图样式 */
.banner-item {
  height: 100%;
  border-radius: 16rpx;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.banner-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.banner-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    135deg,
    rgba(0, 0, 0, 0.7) 0%,
    rgba(0, 0, 0, 0.3) 100%
  );
}

.banner-content {
  position: relative;
  z-index: 1;
  padding: 30rpx 40rpx;
  color: #fff;
}

.banner-badge {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.badge-icon {
  padding: 6rpx 16rpx;
  border-radius: 20rpx;
  font-size: 22rpx;
  font-weight: bold;
  margin-right: 16rpx;
}

.badge-icon.promotion,
.badge-icon.activity,
.badge-icon.news,
.badge-icon.notice,
.badge-icon.system {
  background: rgba(255, 255, 255, 0.3);
}

.badge-time {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
}

.banner-text-content {
  color: #fff;
}

.banner-title {
  display: block;
  font-size: 36rpx;
  font-weight: bold;
  line-height: 1.4;
  margin-bottom: 16rpx;
  text-shadow: 2rpx 2rpx 4rpx rgba(0, 0, 0, 0.2);
}

.banner-text {
  display: block;
  font-size: 26rpx;
  line-height: 1.6;
  opacity: 0.95;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

/* 不同公告类型的背景颜色 */
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

.banner-maintenance {
  background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
}

/* 无公告时的样式 */
.no-banners {
  text-align: center;
  padding: 80rpx 0;
  background: #f9f9f9;
  border-radius: 16rpx;
  color: #999;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.no-banners-icon {
  font-size: 80rpx;
  margin-bottom: 20rpx;
}

.no-banners-text {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 10rpx;
}

.no-banners-hint {
  font-size: 24rpx;
  color: #bbb;
}
</style>
