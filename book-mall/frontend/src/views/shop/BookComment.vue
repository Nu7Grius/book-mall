<template>
  <div class="book-comments">
    <div class="comment-stats">
      <div class="stats-left">
        <div class="avg-rating">
          <span class="rating-num">{{ stats.avgRating || 0 }}</span>
          <span class="rating-label">分</span>
        </div>
        <div class="rating-stars">
          <el-rate
            :value="parseFloat(stats.avgRating) || 0"
            disabled
            text-color="#ff9900"
          />
          <span class="total-count">{{ stats.total || 0 }}条评价</span>
        </div>
      </div>
      <div class="stats-right">
        <div v-for="star in [5, 4, 3, 2, 1]" :key="star" class="rating-bar">
          <span class="star-label">{{ star }}星</span>
          <div class="bar-container">
            <div
              class="bar-fill"
              :style="{ width: getBarWidth(star) + '%' }"
            ></div>
          </div>
          <span class="star-count">{{
            stats[
              star === 5
                ? "fiveStar"
                : star === 4
                ? "fourStar"
                : star === 3
                ? "threeStar"
                : star === 2
                ? "twoStar"
                : "oneStar"
            ] || 0
          }}</span>
        </div>
      </div>
    </div>

    <div class="comment-list">
      <div v-if="loading" class="loading-container">
        <i class="el-icon-loading"></i> 加载中...
      </div>
      <div v-else-if="comments.length === 0" class="empty-comments">
        暂无评价，快来抢沙发吧~
      </div>
      <div v-else class="comment-items">
        <div v-for="comment in comments" :key="comment.id" class="comment-item">
          <div class="comment-header">
            <div class="user-info">
              <el-avatar :size="40" class="user-avatar">
                {{ getAvatarText(comment.userName) }}
              </el-avatar>
              <div class="user-detail">
                <span class="user-name">{{
                  comment.isAnonymous === 1 ? "匿名用户" : comment.userName
                }}</span>
                <el-rate v-model="comment.rating" disabled size="small" />
              </div>
            </div>
            <span class="comment-time">{{
              formatTime(comment.createTime)
            }}</span>
          </div>
          <div class="comment-content" v-html="comment.content || ''"></div>
          <div class="comment-footer" v-if="comment.replyContent">
            <div class="merchant-reply" v-if="comment.replyRole === 'admin'">
              <span class="reply-label">官方回复：</span>
              <span class="reply-content" v-html="comment.replyContent"></span>
            </div>
            <div
              class="merchant-reply"
              v-else-if="comment.replyRole === 'merchant'"
            >
              <span class="reply-label">商家回复：</span>
              <span class="reply-content" v-html="comment.replyContent"></span>
            </div>
          </div>
        </div>
      </div>
      <div class="load-more" v-if="comments.length > 0 && hasMore">
        <el-button size="small" @click="loadMore" :loading="loadingMore"
          >加载更多</el-button
        >
      </div>
    </div>
  </div>
</template>

<script>
import axios from "@/api/request";

export default {
  name: "BookComment",
  props: {
    bookId: {
      type: [Number, String],
      required: false,
    },
  },
  data() {
    return {
      comments: [],
      stats: {},
      loading: false,
      loadingMore: false,
      page: 1,
      pageSize: 10,
      hasMore: false,
    };
  },
  computed: {
    effectiveBookId() {
      return this.bookId || this.$route.params.id;
    },
  },
  mounted() {
    this.loadComments();
    this.loadStats();
  },
  watch: {
    effectiveBookId: {
      handler(newVal) {
        if (newVal) {
          this.loadComments();
          this.loadStats();
        }
      },
      immediate: true,
    },
  },
  methods: {
    async loadComments() {
      const bookId = this.effectiveBookId;
      if (!bookId) {
        return;
      }
      this.loading = true;
      try {
        const res = await axios.get(`/comment/book/${bookId}`);
        if (res.code === 200) {
          this.comments = res.data || [];
        }
      } catch (error) {
        this.$message.error("加载评论失败");
      } finally {
        this.loading = false;
      }
    },
    async loadStats() {
      const bookId = this.effectiveBookId;
      if (!bookId) {
        return;
      }
      try {
        const res = await axios.get(`/comment/stats/${bookId}`);
        if (res.code === 200) {
          this.stats = res.data || {};
        }
      } catch (error) {
        this.$message.error("加载统计失败");
      }
    },
    loadMore() {
      this.page++;
      this.loadComments();
    },
    getBarWidth(star) {
      if (!this.stats.total || this.stats.total === 0) return 0;
      const count =
        this.stats[
          star === 5
            ? "fiveStar"
            : star === 4
            ? "fourStar"
            : star === 3
            ? "threeStar"
            : star === 2
            ? "twoStar"
            : "oneStar"
        ] || 0;
      return Math.round((count / this.stats.total) * 100);
    },
    getAvatarText(name) {
      if (!name) return "?";
      return name.charAt(0).toUpperCase();
    },
    formatTime(time) {
      if (!time) return "";
      const date = new Date(time);
      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(
        2,
        "0"
      )}-${String(date.getDate()).padStart(2, "0")} ${String(
        date.getHours()
      ).padStart(2, "0")}:${String(date.getMinutes()).padStart(2, "0")}`;
    },
  },
};
</script>

<style scoped>
.book-comments {
  margin-top: 30px;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  max-width: 1200px;
  margin-left: auto;
  margin-right: auto;
}

.comment-stats {
  display: flex;
  padding-bottom: 20px;
  border-bottom: 1px solid #eee;
  margin-bottom: 20px;
}

.stats-left {
  width: 200px;
  text-align: center;
  padding-right: 30px;
  border-right: 1px solid #eee;
}

.avg-rating {
  font-size: 48px;
  color: #ff6b00;
  line-height: 1;
}

.avg-rating .rating-label {
  font-size: 16px;
  color: #999;
  margin-left: 5px;
}

.rating-stars {
  margin-top: 10px;
}

.rating-stars .total-count {
  display: block;
  margin-top: 5px;
  color: #999;
  font-size: 14px;
}

.stats-right {
  flex: 1;
  padding-left: 30px;
}

.rating-bar {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}

.star-label {
  width: 50px;
  color: #666;
  font-size: 13px;
}

.bar-container {
  flex: 1;
  height: 10px;
  background: #eee;
  border-radius: 5px;
  margin: 0 10px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #ff9800, #ff6b00);
  border-radius: 5px;
  transition: width 0.3s;
}

.star-count {
  width: 40px;
  text-align: right;
  color: #999;
  font-size: 13px;
}

.comment-list {
  min-height: 100px;
}

.loading-container {
  text-align: center;
  padding: 40px;
  color: #999;
}

.empty-comments {
  text-align: center;
  padding: 40px;
  color: #999;
}

.comment-items {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.comment-item {
  padding: 15px;
  background: #fafafa;
  border-radius: 8px;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
}

.user-info {
  display: flex;
  align-items: center;
}

.user-avatar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  margin-right: 12px;
}

.user-detail {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.user-name {
  font-weight: 500;
  color: #333;
}

.comment-time {
  color: #999;
  font-size: 13px;
}

.comment-content {
  color: #444;
  line-height: 1.8;
  padding-left: 52px;
}

.comment-footer {
  margin-top: 12px;
  padding-left: 52px;
}

.merchant-reply {
  background: #fff3e0;
  padding: 10px 15px;
  border-radius: 6px;
  border-left: 3px solid #ff9800;
}

.reply-label {
  color: #ff9800;
  font-weight: 500;
}

.reply-content {
  color: #666;
  line-height: 1.6;
}

.load-more {
  text-align: center;
  margin-top: 20px;
}
</style>
