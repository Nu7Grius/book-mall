<template>
  <view class="category-container">
    <!-- 左侧一级分类列表 -->
    <scroll-view
      scroll-y
      class="left-panel"
      :style="{ height: windowHeight + 'px' }"
    >
      <view
        class="category-item"
        :class="{ active: currentCategory && currentCategory.id === item.id }"
        v-for="item in categoryList"
        :key="item.id"
        @click="selectCategory(item)"
      >
        <view class="category-indicator"></view>
        <text class="category-name">{{ item.categoryName }}</text>
      </view>
    </scroll-view>

    <!-- 右侧内容区域 -->
    <scroll-view
      scroll-y
      class="right-panel"
      :style="{ height: windowHeight + 'px' }"
    >
      <!-- 二级分类网格 -->
      <view class="subcategory-section" v-if="subCategories.length > 0">
        <view class="section-title">二级分类</view>
        <view class="subcategory-grid">
          <view
            class="subcategory-item"
            v-for="item in subCategories"
            :key="item.id"
            @click="goToBookList(item)"
          >
            <image
              class="subcategory-icon"
              :src="item.icon || '/static/icons/category.png'"
              mode="aspectFit"
            ></image>
            <text class="subcategory-name">{{ item.categoryName }}</text>
          </view>
        </view>
      </view>

      <!-- 该分类下的图书列表 -->
      <view class="books-section" v-if="books.length > 0">
        <view class="section-title">热门图书</view>
        <view class="books-grid">
          <view
            class="book-card"
            v-for="item in books"
            :key="item.id"
            @click="goToDetail(item.id)"
          >
            <image
              class="book-cover"
              :src="item.coverImage"
              mode="aspectFill"
              @error="onImageError"
            ></image>
            <view class="book-info">
              <text class="book-name">{{ item.bookName }}</text>
              <text class="book-author">{{ item.author || "未知作者" }}</text>
              <view class="book-bottom">
                <text class="book-price">¥{{ item.price }}</text>
                <text class="book-sales">已售 {{ item.sales || 0 }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view
        class="empty-state"
        v-if="!loading && books.length === 0 && subCategories.length === 0"
      >
        <text class="empty-icon">📚</text>
        <text class="empty-text">该分类下暂无图书</text>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import { getCategoryList } from "../../api/book.js";
import { getBookList } from "../../api/book.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      categoryList: [],
      currentCategory: null,
      subCategories: [],
      books: [],
      windowHeight: 0,
      loading: false,
    };
  },
  onLoad() {
    this.windowHeight = uni.getSystemInfoSync().windowHeight;
    this.loadCategories();
  },
  methods: {
    async loadCategories() {
      try {
        const res = await getCategoryList();
        if (res.code === 200) {
          this.categoryList = res.data || [];
          if (this.categoryList.length > 0) {
            this.selectCategory(this.categoryList[0]);
          }
        }
      } catch (error) {
        console.error("加载分类失败:", error);
      }
    },
    async selectCategory(item) {
      this.currentCategory = item;
      this.subCategories = [];
      this.books = [];

      if (item.children && item.children.length > 0) {
        this.subCategories = item.children;
      }

      await this.loadBooksByCategory(item.id);
    },
    async loadBooksByCategory(categoryId) {
      this.loading = true;
      try {
        const res = await getBookList({ categoryId, page: 1, pageSize: 20 });
        if (res.code === 200) {
          this.books = (res.data.records || res.data || []).map((item) => ({
            ...item,
            coverImage: item.coverImage
              ? getImageUrl(item.coverImage)
              : "/static/default-cover.png",
          }));
        }
      } catch (error) {
        console.error("加载图书失败:", error);
      } finally {
        this.loading = false;
      }
    },
    goToBookList(item) {
      uni.navigateTo({
        url: `/pages/book-list/book-list?categoryId=${item.id}&categoryName=${item.categoryName}`,
      });
    },
    goToDetail(bookId) {
      uni.navigateTo({
        url: `/pages/book-detail/book-detail?id=${bookId}`,
      });
    },
    onImageError(e) {
      e.target.src = "/static/default-cover.png";
    },
  },
};
</script>

<style scoped>
.category-container {
  display: flex;
  height: 100vh;
  background-color: #f5f5f5;
}

.left-panel {
  width: 180rpx;
  background-color: #f8f8f8;
  flex-shrink: 0;
}

.category-item {
  position: relative;
  padding: 30rpx 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.category-indicator {
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 6rpx;
  height: 0;
  background-color: transparent;
  transition: all 0.3s;
}

.category-item.active {
  background-color: #fff;
}

.category-item.active .category-indicator {
  height: 40rpx;
  background-color: #15803d;
}

.category-name {
  font-size: 26rpx;
  color: #666;
  text-align: center;
}

.category-item.active .category-name {
  color: #15803d;
  font-weight: bold;
}

.right-panel {
  flex: 1;
  background-color: #fff;
  padding: 20rpx;
}

.section-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
  padding-left: 10rpx;
  border-left: 6rpx solid #15803d;
}

.subcategory-section {
  margin-bottom: 30rpx;
}

.subcategory-grid {
  display: flex;
  flex-wrap: wrap;
}

.subcategory-item {
  width: 33.33%;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20rpx 0;
}

.subcategory-icon {
  width: 80rpx;
  height: 80rpx;
  background-color: #f5f5f5;
  border-radius: 16rpx;
  margin-bottom: 12rpx;
}

.subcategory-name {
  font-size: 24rpx;
  color: #666;
  text-align: center;
}

.books-grid {
  display: flex;
  flex-wrap: wrap;
  margin: 0 -10rpx;
}

.book-card {
  width: calc(50% - 20rpx);
  margin: 0 10rpx 20rpx;
  background-color: #fff;
  border-radius: 12rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.06);
}

.book-cover {
  width: 100%;
  height: 280rpx;
  background-color: #f5f5f5;
}

.book-info {
  padding: 16rpx;
}

.book-name {
  display: block;
  font-size: 26rpx;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 8rpx;
}

.book-author {
  display: block;
  font-size: 22rpx;
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 12rpx;
}

.book-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.book-price {
  font-size: 28rpx;
  color: #15803d;
  font-weight: bold;
}

.book-sales {
  font-size: 22rpx;
  color: #999;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 200rpx 0;
}

.empty-icon {
  font-size: 120rpx;
  margin-bottom: 30rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
}
</style>
