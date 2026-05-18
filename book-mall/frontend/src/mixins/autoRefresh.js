/**
 * 自动刷新混入 - 提供通用的自动刷新功能
 *
 * 使用方法：
 * 1. 在组件中导入并混入：
 *    import autoRefresh from '@/mixins/autoRefresh'
 *    mixins: [autoRefresh]
 *
 * 2. 在组件中配置：
 *    data() {
 *      return {
 *        refreshInterval: null,
 *        lastUpdateTime: null,
 *      }
 *    },
 *
 * 3. 调用方法：
 *    this.startAutoRefresh(10000, this.loadData) // 10秒刷新一次
 *    this.stopAutoRefresh() // 停止刷新
 *
 * 4. 在beforeDestroy中：
 *    beforeDestroy() {
 *      this.stopAutoRefresh()
 *    }
 */

export default {
  data() {
    return {
      refreshInterval: null,
      lastUpdateTime: null,
      isAutoRefreshing: false,
    };
  },
  methods: {
    startAutoRefresh(interval = 10000, refreshCallback) {
      if (this.refreshInterval) {
        console.warn('自动刷新已在运行中，请先停止');
        return;
      }

      if (typeof refreshCallback !== 'function') {
        console.error('refreshCallback必须是函数');
        return;
      }

      console.log(`启动自动刷新，间隔：${interval}ms`);
      this.refreshInterval = setInterval(() => {
        if (refreshCallback) {
          refreshCallback();
        }
      }, interval);

      this.isAutoRefreshing = true;
    },

    stopAutoRefresh() {
      if (this.refreshInterval) {
        console.log('停止自动刷新');
        clearInterval(this.refreshInterval);
        this.refreshInterval = null;
        this.isAutoRefreshing = false;
      }
    },

    updateLastTime() {
      this.lastUpdateTime = new Date();
    },

    getLastUpdateText() {
      if (!this.lastUpdateTime) return '';
      const now = new Date();
      const diff = Math.floor((now - this.lastUpdateTime) / 1000);

      if (diff < 60) return `${diff}秒前`;
      if (diff < 3600) return `${Math.floor(diff / 60)}分钟前`;
      return this.lastUpdateTime.toLocaleTimeString();
    },

    manualRefresh(refreshCallback) {
      if (typeof refreshCallback === 'function') {
        console.log('手动刷新数据');
        refreshCallback();
        this.updateLastTime();
      }
    },

    onWindowFocus(callback) {
      window.addEventListener('focus', callback);
    },

    offWindowFocus(callback) {
      window.removeEventListener('focus', callback);
    },

    startSmartRefresh(interval = 10000, refreshCallback, options = {}) {
      const {
        stopOnHidden = true,    // 页面隐藏时停止刷新
        resumeOnVisible = true, // 页面重新显示时刷新
        updateOnFocus = true,   // 页面获得焦点时刷新
      } = options;

      this.startAutoRefresh(interval, refreshCallback);

      if (stopOnHidden) {
        document.addEventListener('visibilitychange', () => {
          if (document.hidden) {
            console.log('页面隐藏，停止自动刷新');
            this.stopAutoRefresh();
          } else if (resumeOnVisible) {
            console.log('页面显示，恢复自动刷新');
            this.startAutoRefresh(interval, refreshCallback);
            if (updateOnFocus && refreshCallback) {
              refreshCallback();
            }
          }
        });
      }

      if (updateOnFocus) {
        const handleFocus = () => {
          console.log('窗口获得焦点，刷新数据');
          if (refreshCallback) {
            refreshCallback();
          }
          this.updateLastTime();
        };
        this.onWindowFocus(handleFocus);
      }
    },
  },

  beforeDestroy() {
    this.stopAutoRefresh();
  },
};
