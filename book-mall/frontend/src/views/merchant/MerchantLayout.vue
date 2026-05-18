<template>
  <el-container class="merchant-layout">
    <el-aside width="200px">
      <div class="logo">
        <h3>🏪 商家中心</h3>
      </div>
      <el-menu
        :default-active="activeMenu"
        class="el-menu-vertical"
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
        router
      >
        <el-menu-item index="/merchant/home">
          <i class="el-icon-s-home"></i>
          <span slot="title">首页</span>
        </el-menu-item>

        <el-menu-item index="/merchant/book-list">
          <i class="el-icon-reading"></i>
          <span slot="title">图书管理</span>
        </el-menu-item>

        <el-menu-item index="/merchant/order-list">
          <i class="el-icon-document"></i>
          <span slot="title">订单管理</span>
        </el-menu-item>

        <el-menu-item index="/merchant/statistics">
          <i class="el-icon-data-analysis"></i>
          <span slot="title">数据统计</span>
        </el-menu-item>

        <el-menu-item index="/merchant/comment-list">
          <i class="el-icon-chat-line-round"></i>
          <span slot="title">评论管理</span>
        </el-menu-item>

        <el-menu-item index="/merchant/shop-info">
          <i class="el-icon-setting"></i>
          <span slot="title">店铺设置</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header class="merchant-header">
        <div class="header-left">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/merchant/home' }"
              >首页</el-breadcrumb-item
            >
            <el-breadcrumb-item v-if="$route.meta.title">{{
              $route.meta.title
            }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <div class="user-info">
              <el-avatar :size="36" :src="shopAvatar" class="shop-avatar">
                <i class="el-icon-s-shop"></i>
              </el-avatar>
              <div class="shop-info">
                <span class="shop-name">{{ shopName }}</span>
                <span
                  class="shop-status"
                  :class="shopStatus === 1 ? 'status-open' : 'status-closed'"
                >
                  {{ shopStatus === 1 ? "营业中" : "休息中" }}
                </span>
              </div>
              <i class="el-icon-arrow-down el-icon--right dropdown-arrow"></i>
            </div>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="shop">
                <i class="el-icon-s-shop" style="margin-right: 8px"></i>店铺中心
              </el-dropdown-item>
              <el-dropdown-item command="logout" divided>
                <i class="el-icon-switch-button" style="margin-right: 8px"></i
                >退出登录
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </el-header>

      <el-main>
        <router-view />
      </el-main>

      <el-footer class="merchant-footer" height="60px">
        <div class="footer-content">
          <p>© 2026 OpenBook - 商家管理中心</p>
        </div>
      </el-footer>
    </el-container>
  </el-container>
</template>

<script>
export default {
  name: "MerchantLayout",
  data() {
    return {
      shopName: "",
      shopAvatar: "",
      shopStatus: 1,
    };
  },
  computed: {
    activeMenu() {
      return this.$route.path;
    },
  },
  mounted() {
    this.loadShopInfo();
    window.addEventListener("merchant-info-updated", this.handleInfoUpdate);
  },
  beforeDestroy() {
    window.removeEventListener("merchant-info-updated", this.handleInfoUpdate);
  },
  methods: {
    handleInfoUpdate() {
      this.loadShopInfo();
    },
    loadShopInfo() {
      const merchantInfo = localStorage.getItem("merchantInfo");
      if (merchantInfo) {
        try {
          const info = JSON.parse(merchantInfo);
          this.shopName = info.shopName || "我的店铺";
          this.shopAvatar =
            info.logo ||
            info.avatar ||
            "https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg";
          this.shopStatus = info.status === 1 || info.status === true ? 1 : 0;
        } catch (e) {
          this.shopName = "我的店铺";
          this.shopAvatar =
            "https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg";
          this.shopStatus = 1;
        }
      } else {
        this.shopName = "我的店铺";
        this.shopAvatar =
          "https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg";
        this.shopStatus = 1;
      }
    },
    handleCommand(command) {
      if (command === "logout") {
        this.$confirm("确定要退出登录吗？", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        })
          .then(() => {
            // 清理所有相关的localStorage
            localStorage.removeItem("token");
            localStorage.removeItem("merchantInfo");
            localStorage.removeItem("merchantId");
            localStorage.removeItem("user");
            localStorage.removeItem("userId");
            localStorage.removeItem("userInfo");
            this.$message.success("退出登录成功");
            this.$router.push("/login");
          })
          .catch(() => Promise.resolve());
      } else if (command === "shop") {
        if (this.$route.path !== "/merchant/home") {
          this.$router.push("/merchant/home");
        } else {
          this.$message.info("已经在店铺首页");
        }
      }
    },
  },
};
</script>

<style scoped>
.merchant-layout {
  height: 100vh;
}

.el-aside {
  background-color: #304156;
  overflow-x: hidden;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #2b3a4a;
}

.logo h3 {
  color: #fff;
  font-size: 16px;
  font-weight: bold;
  margin: 0;
}

.el-menu-vertical {
  border-right: none;
}

.merchant-header {
  background: linear-gradient(135deg, #1e4d7b 0%, #2c5282 100%);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  box-shadow: 0 2px 8px rgba(0, 21, 41, 0.15);
}

.merchant-header .header-left /deep/ .el-breadcrumb__item {
  color: #fff;
}

.merchant-header .header-left /deep/ .el-breadcrumb__inner {
  color: rgba(255, 255, 255, 0.8);
}

.merchant-header .header-left /deep/ .el-breadcrumb__inner:hover {
  color: #fff;
}

.merchant-header .header-left /deep/ .el-breadcrumb__separator {
  color: rgba(255, 255, 255, 0.6);
}

.header-left {
  display: flex;
  align-items: center;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  padding: 10px 16px;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
  gap: 16px;
}

.merchant-header .header-right .user-info:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.merchant-header .header-right .shop-avatar {
  border: 2px solid rgba(255, 255, 255, 0.3);
  margin-right: 4px;
}

.shop-info {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-right: 12px;
  gap: 6px;
}

.shop-name {
  font-size: 14px;
  font-weight: 500;
  color: #fff;
  line-height: 1.4;
}

.shop-status {
  font-size: 12px;
  line-height: 1.4;
}

.merchant-header .header-right .dropdown-arrow {
  color: #fff;
}

.merchant-header .header-right .status-open {
  color: #7dff7d;
}

.merchant-header .header-right .status-closed {
  color: #ffcccc;
}

.merchant-header .header-right .el-dropdown-link {
  color: #fff;
}

.merchant-header .header-right .el-dropdown-link:hover {
  color: #fff;
}

.merchant-footer {
  background: linear-gradient(135deg, #1a365d 0%, #234876 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}

.merchant-footer .footer-content {
  text-align: center;
  color: #fff;
  font-size: 12px;
}

.el-main {
  background-color: #f0f2f5;
  padding: 20px;
  overflow-y: auto;
}
</style>
