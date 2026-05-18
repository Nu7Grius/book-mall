<template>
  <view class="book-list-container">
    <!-- 搜索栏 -->
    <view class="search-bar" v-if="isSearchMode">
      <view class="search-input">
        <text class="icon">🔍</text>
        <input
          v-model="searchKey"
          placeholder="搜索图书"
          @confirm="handleSearch"
        />
      </view>
      <text class="cancel-btn" @click="goBack">取消</text>
    </view>

    <!-- 筛选栏 -->
    <view class="filter-bar">
      <view
        class="filter-item"
        :class="{ active: filterType !== 'price' }"
        @click="toggleSort"
      >
        <text>{{ sortText }}</text>
        <text class="arrow" v-if="filterType !== 'price'">{{ sortArrow }}</text>
      </view>
      <view class="filter-item" @click="showCategoryPicker">
        <text :class="{ 'filter-active': selectedCategoryName }">{{
          selectedCategoryName || "分类"
        }}</text>
        <text class="arrow">▼</text>
      </view>
      <view class="filter-item" @click="showPricePicker">
        <text :class="{ 'filter-active': priceFilterText !== '价格' }">{{
          priceFilterText
        }}</text>
        <text class="arrow">▼</text>
      </view>
    </view>

    <!-- 图书列表 -->
    <scroll-view
      scroll-y
      class="book-list"
      @scrolltolower="loadMore"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
    >
      <view class="book-grid" v-if="bookList.length > 0">
        <view
          class="book-item"
          v-for="item in bookList"
          :key="item.id"
          @click="goToDetail(item.id)"
        >
          <image
            class="book-cover"
            :src="item.coverImage"
            mode="aspectFill"
          ></image>
          <view class="book-info">
            <text class="book-name">{{ item.bookName }}</text>
            <text class="book-author">{{ item.author }}</text>
            <view class="book-bottom">
              <text class="book-price">¥{{ item.price }}</text>
              <text class="book-sales">销量 {{ item.sales || 0 }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view class="empty-state" v-else>
        <text class="empty-text">暂无图书</text>
      </view>

      <!-- 加载状态 -->
      <view class="loading-more" v-if="loading">
        <text>加载中...</text>
      </view>
      <view class="no-more" v-if="noMore && bookList.length > 0">
        <text>没有更多了</text>
      </view>
    </scroll-view>

    <!-- 分类选择器遮罩 -->
    <view
      class="picker-mask"
      v-if="showCategory"
      @click="closeCategoryPicker"
    ></view>
    <view class="picker-popup" :class="{ show: showCategory }">
      <view class="picker-header">
        <text class="picker-cancel" @click="closeCategoryPicker">取消</text>
        <text class="picker-title">选择分类</text>
        <text class="picker-confirm" @click="confirmCategory">确定</text>
      </view>
      <picker-view
        class="picker-view"
        :value="pickerCategoryIndex"
        @change="onCategoryChange"
      >
        <picker-view-column>
          <view
            class="picker-item"
            v-for="(item, index) in categoryList"
            :key="index"
          >
            {{ item.categoryName }}
          </view>
        </picker-view-column>
      </picker-view>
    </view>

    <!-- 价格选择器遮罩 -->
    <view class="picker-mask" v-if="showPrice" @click="closePricePicker"></view>
    <view class="picker-popup" :class="{ show: showPrice }">
      <view class="picker-header">
        <text class="picker-cancel" @click="closePricePicker">取消</text>
        <text class="picker-title">选择价格</text>
        <text class="picker-confirm" @click="confirmPrice">确定</text>
      </view>
      <picker-view
        class="picker-view"
        :value="pickerPriceIndex"
        @change="onPriceChange"
      >
        <picker-view-column>
          <view
            class="picker-item"
            v-for="(item, index) in priceRanges"
            :key="index"
          >
            {{ item.label }}
          </view>
        </picker-view-column>
      </picker-view>
    </view>
  </view>
</template>

<script>
import { getBookList, getCategoryList, searchBooks } from "../../api/book.js";
import { getImageUrl } from "../../utils/image.js";

export default {
  data() {
    return {
      bookList: [],
      categoryList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      noMore: false,
      refreshing: false,
      searchKey: "",
      isSearchMode: false,
      categoryId: null,
      selectedCategoryName: "",
      categoryIndex: 0,
      filterType: "hot",
      priceMin: null,
      priceMax: null,
      priceOrder: "asc",
      priceRangeIndex: 0,
      showCategory: false,
      showPrice: false,
      pickerCategoryIndex: 0,
      pickerPriceIndex: 0,
      priceRanges: [
        { label: "全部", min: null, max: null },
        { label: "0-50元", min: 0, max: 50 },
        { label: "50-100元", min: 50, max: 100 },
        { label: "100-200元", min: 100, max: 200 },
        { label: "200元以上", min: 200, max: null },
      ],
    };
  },
  computed: {
    sortText() {
      const map = {
        hot: "销量",
        new: "新品",
        price: "价格",
      };
      return map[this.filterType] || "销量";
    },
    sortArrow() {
      if (this.filterType === "hot" || this.filterType === "new") {
        return "↓";
      }
      return this.priceOrder === "asc" ? "↑" : "↓";
    },
    priceFilterText() {
      const range = this.priceRanges[this.priceRangeIndex];
      return range ? range.label : "价格";
    },
  },
  onLoad(options) {
    if (options.categoryId) {
      this.categoryId = parseInt(options.categoryId);
    }
    if (options.categoryName) {
      this.selectedCategoryName = decodeURIComponent(options.categoryName);
    }
    if (options.search === "true") {
      this.isSearchMode = true;
    }
    this.loadCategories();
    this.loadBooks();
  },
  watch: {
    categoryList: {
      handler(newList) {
        if (
          newList &&
          newList.length > 0 &&
          this.categoryId !== null &&
          this.categoryId !== undefined
        ) {
          const targetId = String(this.categoryId);
          const index = newList.findIndex(
            (item) => String(item.id) === targetId
          );
          if (index !== -1 && index !== this.categoryIndex) {
            this.categoryIndex = index;
          }
        }
      },
      deep: true,
    },
  },
  methods: {
    async loadCategories() {
      try {
        const res = await getCategoryList();
        if (res.code === 200) {
          const treeData = res.data || [];
          const flatList = [{ id: null, categoryName: "全部" }];
          treeData.forEach((item) => {
            flatList.push({ id: item.id, categoryName: item.categoryName });
            if (item.children && item.children.length > 0) {
              item.children.forEach((child) => {
                flatList.push({
                  id: child.id,
                  categoryName: "  └ " + child.categoryName,
                });
              });
            }
          });
          this.categoryList = flatList;
          this.syncCategoryIndex();
        }
      } catch (error) {
        console.error("加载分类失败:", error);
      }
    },
    syncCategoryIndex() {
      if (
        this.categoryId !== null &&
        this.categoryId !== undefined &&
        this.categoryList.length > 0
      ) {
        const targetId = String(this.categoryId);
        const index = this.categoryList.findIndex(
          (item) => String(item.id) === targetId
        );
        if (index !== -1) {
          this.categoryIndex = index;
        }
      }
    },
    async loadBooks(reset = false) {
      if (this.loading) return;
      if (reset) {
        this.page = 1;
        this.noMore = false;
      }

      this.loading = true;
      try {
        let res;
        if (this.searchKey) {
          res = await searchBooks(this.searchKey);
        } else {
          const params = {
            page: this.page,
            size: this.size,
          };
          if (this.categoryId !== null && this.categoryId !== undefined) {
            params.categoryId = this.categoryId;
          }
          params.filterType = this.filterType;
          if (this.filterType === "price") {
            params.sort = "price";
            params.order = this.priceOrder || "asc";
          }
          if (this.priceMin !== null && this.priceMin !== undefined) {
            params.priceMin = this.priceMin;
          }
          if (this.priceMax !== null && this.priceMax !== undefined) {
            params.priceMax = this.priceMax;
          }
          res = await getBookList(params);
        }

        if (res.code === 200) {
          let data = [];
          if (Array.isArray(res.data)) {
            data = res.data;
          } else if (res.data && Array.isArray(res.data.records)) {
            data = res.data.records;
          } else if (res.data && typeof res.data === "object") {
            data = Object.values(res.data)[0] || [];
          }
          data = data.map((item) => ({
            ...item,
            coverImage: item.coverImage
              ? getImageUrl(item.coverImage)
              : "/static/default-cover.png",
          }));
          if (reset) {
            const total = (res.data && res.data.total) || data.length;
            if (
              this.priceMin !== null ||
              this.priceMax !== null ||
              this.categoryId
            ) {
              uni.showToast({
                title: `共${total}本图书`,
                icon: "none",
                duration: 1500,
              });
            }
            this.bookList = data;
          } else {
            this.bookList = [...this.bookList, ...data];
          }
          this.total = (res.data && res.data.total) || data.length;
          this.noMore = this.bookList.length >= this.total;
        }
      } catch (error) {
        console.error("加载图书失败:", error);
      } finally {
        this.loading = false;
        this.refreshing = false;
      }
    },
    loadMore() {
      if (!this.noMore && !this.loading) {
        this.page++;
        this.loadBooks();
      }
    },
    onRefresh() {
      this.refreshing = true;
      this.loadBooks(true);
    },
    handleSearch() {
      this.loadBooks(true);
    },
    toggleSort() {
      const sorts = ["hot", "new", "price"];
      const currentIndex = sorts.indexOf(this.filterType);
      const nextIndex = (currentIndex + 1) % sorts.length;
      this.filterType = sorts[nextIndex];
      if (this.filterType === "price") {
        this.priceOrder = this.priceOrder === "asc" ? "desc" : "asc";
      }
      this.loadBooks(true);
    },
    showCategoryPicker() {
      this.pickerCategoryIndex = [this.categoryIndex];
      this.showCategory = true;
    },
    closeCategoryPicker() {
      this.showCategory = false;
    },
    onCategoryChange(e) {
      const val = e.detail.value;
      this.pickerCategoryIndex = val;
    },
    confirmCategory() {
      const idx = this.pickerCategoryIndex[0];
      if (this.categoryList[idx]) {
        this.categoryIndex = idx;
        this.categoryId = this.categoryList[idx].id;
        this.selectedCategoryName = this.categoryList[idx].categoryName.trim();
        this.loadBooks(true);
      }
      this.showCategory = false;
    },
    showPricePicker() {
      this.pickerPriceIndex = [this.priceRangeIndex];
      this.showPrice = true;
    },
    closePricePicker() {
      this.showPrice = false;
    },
    onPriceChange(e) {
      const val = e.detail.value;
      this.pickerPriceIndex = val;
    },
    confirmPrice() {
      const idx = this.pickerPriceIndex[0];
      this.priceRangeIndex = idx;
      const range = this.priceRanges[idx];
      this.priceMin = range.min;
      this.priceMax = range.max;
      this.loadBooks(true);
      this.showPrice = false;
    },
    goToDetail(id) {
      uni.navigateTo({
        url: `/pages/book-detail/book-detail?id=${id}`,
      });
    },
    goBack() {
      uni.navigateBack();
    },
  },
};
</script>

<style scoped>
.book-list-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  position: relative;
}

.search-bar {
  display: flex;
  align-items: center;
  padding: 20rpx 30rpx;
  background-color: #fff;
}

.search-input {
  flex: 1;
  display: flex;
  align-items: center;
  height: 64rpx;
  background-color: #f5f5f5;
  border-radius: 32rpx;
  padding: 0 24rpx;
  margin-right: 20rpx;
}

.search-input .icon {
  font-size: 26rpx;
  margin-right: 12rpx;
}

.search-input input {
  flex: 1;
  font-size: 26rpx;
}

.cancel-btn {
  font-size: 28rpx;
  color: #666;
}

.filter-bar {
  display: flex;
  justify-content: space-around;
  align-items: center;
  height: 88rpx;
  background-color: #fff;
  border-bottom: 1px solid #f0f0f0;
}

.filter-item {
  display: flex;
  align-items: center;
  font-size: 28rpx;
  color: #333;
}

.filter-item.active {
  color: #15803d;
  font-weight: bold;
}

.filter-active {
  color: #15803d;
}

.arrow {
  margin-left: 8rpx;
  font-size: 20rpx;
  color: #999;
}

.book-list {
  height: calc(100vh - 188rpx);
}

.book-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding: 20rpx;
}

.book-item {
  width: 48%;
  background-color: #fff;
  border-radius: 16rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
}

.book-cover {
  width: 100%;
  height: 360rpx;
  background-color: #f5f5f5;
}

.book-info {
  padding: 20rpx;
}

.book-name {
  display: block;
  font-size: 28rpx;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.book-author {
  display: block;
  font-size: 24rpx;
  color: #999;
  margin-top: 8rpx;
}

.book-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 16rpx;
}

.book-price {
  font-size: 30rpx;
  color: #15803d;
  font-weight: bold;
}

.book-sales {
  font-size: 22rpx;
  color: #999;
}

.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 400rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
}

.loading-more,
.no-more {
  text-align: center;
  padding: 30rpx;
  font-size: 26rpx;
  color: #999;
}

.picker-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 100;
}

.picker-popup {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;
  border-radius: 24rpx 24rpx 0 0;
  z-index: 101;
  transform: translateY(100%);
  transition: transform 0.3s ease;
}

.picker-popup.show {
  transform: translateY(0);
}

.picker-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1px solid #f0f0f0;
}

.picker-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.picker-cancel {
  font-size: 28rpx;
  color: #999;
}

.picker-confirm {
  font-size: 28rpx;
  color: #15803d;
  font-weight: bold;
}

.picker-view {
  height: 400rpx;
}

.picker-item {
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 28rpx;
  color: #333;
}
</style>
