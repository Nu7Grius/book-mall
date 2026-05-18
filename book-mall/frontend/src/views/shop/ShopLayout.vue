<template>
  <div class="user-layout">
    <div class="header">
      <div class="header-wrapper">
        <div class="header-left">
          <div class="logo" @click="goToHome">📚 OpenBook</div>
        </div>
        <div class="header-center">
          <div class="search-box">
            <el-input
              v-model="keyword"
              placeholder="搜索图书..."
              @keyup.enter.native="handleSearch"
              @input="handleKeywordChange"
            >
              <el-button
                slot="append"
                icon="el-icon-search"
                @click="handleSearch"
              ></el-button>
            </el-input>
          </div>
        </div>
        <div class="header-right">
          <div class="user-info">
            <span v-if="!userInfo">您好，请</span>
            <router-link v-if="!userInfo" to="/login">登录</router-link>
            <span v-if="userInfo" class="welcome-text">
              <el-avatar :size="36" :src="avatarUrl" class="user-avatar">
                {{
                  (userInfo.nickname || userInfo.realName || "U")
                    .charAt(0)
                    .toUpperCase()
                }}
              </el-avatar>
              <span class="username-text"
                >欢迎，{{ userInfo.nickname || userInfo.realName }}</span
              >
            </span>
            <el-dropdown v-if="userInfo" @command="handleCommand">
              <span class="el-dropdown-link">
                我的<i class="el-icon-arrow-down el-icon--right"></i>
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="favorites"
                  >❤️ 我的收藏</el-dropdown-item
                >
                <el-dropdown-item command="cart">🛒 购物车</el-dropdown-item>
                <el-dropdown-item command="orders"
                  >📋 我的订单</el-dropdown-item
                >
                <el-dropdown-item command="address"
                  >📍 收货地址</el-dropdown-item
                >
                <el-dropdown-item command="profile" divided
                  >⚙️ 账户设置</el-dropdown-item
                >
                <el-dropdown-item command="customerService"
                  >📞 联系客服</el-dropdown-item
                >
                <el-dropdown-item command="logout"
                  >🚪 退出登录</el-dropdown-item
                >
              </el-dropdown-menu>
            </el-dropdown>
          </div>
        </div>
      </div>
      <div class="nav">
        <div class="nav-content">
          <span
            class="nav-item"
            :class="{ active: $route.path === '/home' || $route.path === '/' }"
            @click="goToHome"
          >
            首页
          </span>
          <span
            class="nav-item"
            :class="{
              active:
                $route.path === '/home/books' || $route.path === '/home/search',
            }"
            @click="goToBooks"
          >
            全部图书
          </span>
          <span
            class="nav-item"
            :class="{ active: $route.path === '/home/notice' }"
            @click="goToNotice"
          >
            📢 系统公告
          </span>
        </div>
      </div>
    </div>

    <div class="container-wrapper">
      <div class="main-content">
        <router-view></router-view>
      </div>
    </div>

    <div class="footer">
      <p>📚 OpenBook - 让阅读成为一种习惯</p>
    </div>
  </div>
</template>

<script>
export default {
  name: "UserLayout",
  data() {
    return {
      userInfo: null,
      keyword: "",
      avatarUrl: "",
    };
  },
  mounted() {
    this.loadUserInfo();

    // 监听头像更新事件
    window.addEventListener("avatar-updated", this.handleAvatarUpdate);
  },
  beforeDestroy() {
    // 移除头像更新事件监听
    window.removeEventListener("avatar-updated", this.handleAvatarUpdate);
  },
  methods: {
    goToHome() {
      this.$router.push("/home").catch(() => {});
    },
    goToBooks() {
      this.$router.push("/home/books").catch(() => {});
    },
    goToNotice() {
      this.$router.push("/home/notice").catch(() => {});
    },
    loadUserInfo() {
      const user = localStorage.getItem("user");
      if (user) {
        this.userInfo = JSON.parse(user);
        this.loadAvatar();
      }
    },
    loadAvatar() {
      const userId = localStorage.getItem("userId");
      if (!userId) {
        return;
      }

      this.$http
        .get(`/user/${userId}`)
        .then((res) => {
          if (res.code === 200) {
            this.userInfo = {
              ...this.userInfo,
              ...res.data,
            };
            this.avatarUrl = this.getImageUrl(res.data.avatar);
            localStorage.setItem("user", JSON.stringify(this.userInfo));
          }
        })
        .catch(() => {});
    },
    handleAvatarUpdate() {
      // 头像更新时，重新加载用户信息
      this.loadAvatar();
    },
    getImageUrl(path) {
      if (!path) return "";
      if (path.startsWith("http")) return path;
      return "http://localhost:8080" + path;
    },
    handleKeywordChange() {
      if (this.keyword === "" && this.$route.path === "/home/books") {
        this.$router.replace({ path: "/home/books" }).catch(() => {});
      }
    },
    handleSearch() {
      if (!this.keyword.trim()) {
        this.$message.warning("请输入搜索关键词");
        return;
      }
      if (this.$route.path === "/home/books") {
        this.$router
          .replace({
            path: "/home/books",
            query: { keyword: this.keyword.trim() },
          })
          .catch(() => {});
      } else {
        this.$router
          .push({
            path: "/home/books",
            query: { keyword: this.keyword.trim() },
          })
          .catch(() => {});
      }
    },
    handleCommand(command) {
      const routerPush = (path) => {
        this.$router.push(path).catch(() => {});
      };

      if (command === "cart") {
        routerPush("/home/cart");
      } else if (command === "orders") {
        routerPush("/home/my-orders");
      } else if (command === "address") {
        routerPush("/home/my-address");
      } else if (command === "favorites") {
        routerPush("/home/my-favorites");
      } else if (command === "profile") {
        routerPush("/home/my-profile");
      } else if (command === "customerService") {
        routerPush("/home/customer-service");
      } else if (command === "logout") {
        // 清理所有相关的localStorage
        localStorage.removeItem("token");
        localStorage.removeItem("user");
        localStorage.removeItem("userId");
        localStorage.removeItem("merchantInfo");
        localStorage.removeItem("merchantId");
        localStorage.removeItem("userInfo");
        this.userInfo = null;
        this.$message.success("已退出登录");
        routerPush("/login");
      }
    },
  },
};
</script>

<style scoped>
.user-layout {
  height: 100vh;
  background: linear-gradient(180deg, #f0fdf4 0%, #dcfce7 100%);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.header {
  width: 100%;
  flex-shrink: 0;
  background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%);
  box-shadow: 0 4px 20px rgba(21, 128, 61, 0.08);
  border-bottom: 1px solid rgba(21, 128, 61, 0.1);
}

.header-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 16px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}

.header-left {
  flex: 0 0 auto;
}

.logo {
  font-size: 26px;
  font-weight: 700;
  background: linear-gradient(135deg, #15803d 0%, #22c55e 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  cursor: pointer;
  transition: all 0.3s ease;
  letter-spacing: -0.5px;
}

.logo:hover {
  transform: translateY(-1px);
  filter: brightness(1.1);
}

.header-center {
  flex: 1;
  max-width: 520px;
  margin: 0;
}

.search-box {
  width: 100%;
}

.search-box ::v-deep .el-input__inner {
  border-radius: 24px 0 0 24px;
  border-color: #22c55e;
  background: #ffffff;
  padding-left: 20px;
  transition: all 0.3s ease;
}

.search-box ::v-deep .el-input__inner:focus {
  border-color: #15803d;
  background: #ffffff;
  box-shadow: 0 0 0 3px rgba(21, 128, 61, 0.1);
}

.search-box ::v-deep .el-input-group__append {
  border-radius: 0 24px 24px 0;
  background: linear-gradient(135deg, #15803d 0%, #22c55e 100%);
  border-color: #15803d;
  color: #fff;
  padding: 0 20px;
  transition: all 0.3s ease;
}

.search-box ::v-deep .el-input-group__append:hover {
  filter: brightness(1.1);
  transform: scale(1.02);
}

.header-right {
  flex: 0 0 auto;
}

.user-info {
  font-size: 14px;
  color: #666;
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-info a {
  color: #15803d;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s ease;
  padding: 6px 14px;
  border-radius: 20px;
  background: rgba(21, 128, 61, 0.08);
}

.user-info a:hover {
  background: #15803d;
  color: #fff;
  transform: translateY(-1px);
}

.welcome-text {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-avatar {
  vertical-align: middle;
  background: linear-gradient(135deg, #15803d 0%, #22c55e 100%);
  color: #fff;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(21, 128, 61, 0.3);
}

.user-avatar:hover {
  transform: scale(1.08);
  box-shadow: 0 4px 12px rgba(21, 128, 61, 0.4);
}

.username-text {
  font-weight: 500;
  color: #14532d;
  font-size: 14px;
}

.el-dropdown-link {
  cursor: pointer;
  color: #15803d;
  font-weight: 500;
  padding: 8px 16px;
  border-radius: 20px;
  background: rgba(21, 128, 61, 0.08);
  transition: all 0.3s ease;
}

.el-dropdown-link:hover {
  background: #15803d;
  color: #fff;
  transform: translateY(-1px);
}

.nav {
  background: linear-gradient(135deg, #15803d 0%, #166534 100%);
  box-shadow: 0 4px 12px rgba(21, 128, 61, 0.2);
}

.nav-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
  display: flex;
  gap: 32px;
}

.nav-item {
  padding: 14px 0;
  color: rgba(255, 255, 255, 0.85);
  cursor: pointer;
  font-size: 15px;
  font-weight: 500;
  border-bottom: 3px solid transparent;
  transition: all 0.3s ease;
  position: relative;
}

.nav-item::before {
  content: "";
  position: absolute;
  bottom: 0;
  left: 50%;
  width: 0;
  height: 3px;
  background: #ffffff;
  transition: all 0.3s ease;
  transform: translateX(-50%);
}

.nav-item:hover {
  color: #ffffff;
  background: rgba(255, 255, 255, 0.1);
}

.nav-item:hover::before {
  width: 100%;
}

.nav-item.active {
  color: #ffffff;
  font-weight: 600;
}

.nav-item.active::before {
  width: 100%;
}

.container-wrapper {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
}

.main-content {
  max-width: 1200px;
  width: 100%;
  margin: 24px auto;
  padding: 0 24px;
}

.footer {
  width: 100%;
  flex-shrink: 0;
  background: linear-gradient(135deg, #14532d 0%, #166534 100%);
  color: #ffffff;
  text-align: center;
  padding: 24px;
  box-shadow: 0 -4px 20px rgba(21, 128, 61, 0.15);
}

.footer p {
  margin: 0;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.5px;
}
</style>
