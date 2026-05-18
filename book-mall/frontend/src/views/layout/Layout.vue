<template>
  <el-container class="layout-container">
    <!-- 左侧导航菜单 -->
    <el-aside width="200px">
      <div class="logo">
        <h3>图书商城</h3>
      </div>
      <el-menu
        :default-active="activeMenu"
        class="el-menu-vertical"
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
        router
      >
        <el-menu-item index="/layout/home">
          <i class="el-icon-s-home"></i>
          <span slot="title">首页</span>
        </el-menu-item>

        <el-menu-item index="/layout/notice-list">
          <i class="el-icon-bell"></i>
          <span slot="title">公告管理</span>
        </el-menu-item>

        <el-menu-item index="/layout/book-list">
          <i class="el-icon-reading"></i>
          <span slot="title">图书管理</span>
        </el-menu-item>

        <el-menu-item index="/layout/category-list">
          <i class="el-icon-collection"></i>
          <span slot="title">分类管理</span>
        </el-menu-item>

        <el-menu-item index="/layout/order-list">
          <i class="el-icon-document"></i>
          <span slot="title">订单管理</span>
        </el-menu-item>

        <el-menu-item index="/layout/comment-list">
          <i class="el-icon-chat-line-round"></i>
          <span slot="title">评论管理</span>
        </el-menu-item>

        <el-submenu index="user">
          <template slot="title">
            <i class="el-icon-user"></i>
            <span>人员管理</span>
          </template>
          <el-menu-item
            index="/layout/admin-list"
            v-if="currentUserRole === 'super_admin'"
            ><i class="el-icon-s-tools"></i>管理员信息</el-menu-item
          >
          <el-menu-item index="/layout/merchant-list">
            <i class="el-icon-s-shop"></i>商家信息
          </el-menu-item>
          <el-menu-item index="/layout/user-list">
            <i class="el-icon-user-solid"></i>用户信息
          </el-menu-item>
        </el-submenu>
      </el-menu>
    </el-aside>

    <!-- 右侧主内容区 -->
    <el-container>
      <!-- 顶部导航栏 -->
      <el-header>
        <div class="header-left">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/layout/home' }"
              >首页</el-breadcrumb-item
            >
            <el-breadcrumb-item v-if="$route.meta.title">{{
              $route.meta.title
            }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="el-dropdown-link">
              <el-avatar :size="32" :src="avatarUrl" class="user-avatar">
                {{ username.charAt(0).toUpperCase() }}
              </el-avatar>
              <span class="username">{{ username }}</span>
              <i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile">个人中心</el-dropdown-item>
              <el-dropdown-item command="logout" divided
                >退出登录</el-dropdown-item
              >
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </el-header>

      <!-- 主内容区域 -->
      <el-main>
        <router-view />
      </el-main>

      <!-- 底部 -->
      <el-footer height="60px">
        <div class="footer-content">
          <p>&copy; 2026 图书商城管理系统 - All Rights Reserved</p>
        </div>
      </el-footer>
    </el-container>
  </el-container>
</template>

<script>
export default {
  name: "Layout",
  data() {
    return {
      username: "",
      avatarUrl: "",
      currentUserRole: "",
    };
  },
  computed: {
    activeMenu() {
      return this.$route.path;
    },
  },
  mounted() {
    this.loadUserInfo();
  },
  methods: {
    loadUserInfo() {
      const userInfo = localStorage.getItem("userInfo");
      if (userInfo) {
        const user = JSON.parse(userInfo);
        this.username = user.username || "Admin";
        this.avatarUrl = this.getImageUrl(user.avatar);
        this.currentUserRole = user.role || "";
      }

      const userId = localStorage.getItem("userId");
      if (!userId) {
        return;
      }

      this.$http
        .get(`/user/${userId}`)
        .then((res) => {
          if (res.code === 200) {
            this.username = res.data.username || "Admin";
            this.avatarUrl = this.getImageUrl(res.data.avatar);
            this.currentUserRole = res.data.role || "";
          }
        })
        .catch(() => {});
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
            localStorage.removeItem("userInfo");
            localStorage.removeItem("user");
            localStorage.removeItem("userId");
            localStorage.removeItem("merchantInfo");
            localStorage.removeItem("merchantId");
            this.$message.success("退出登录成功");
            this.$router.push("/login");
          })
          .catch(() => Promise.resolve());
      } else if (command === "profile") {
        this.$router.push("/layout/admin-profile");
      }
    },
  },
};
</script>

<style scoped>
.layout-container {
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
  font-size: 18px;
  font-weight: bold;
  margin: 0;
}

.el-menu-vertical {
  border-right: none;
}

.el-header {
  background-color: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
}

.header-left {
  display: flex;
  align-items: center;
}

.header-right {
  display: flex;
  align-items: center;
}

.el-dropdown-link {
  cursor: pointer;
  color: #333;
  font-size: 14px;
}

.el-dropdown-link:hover {
  color: #409eff;
}

.user-avatar {
  vertical-align: middle;
  margin-right: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s;
}

.user-avatar:hover {
  transform: scale(1.1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.username {
  margin-right: 8px;
  font-weight: 500;
}

.el-main {
  background-color: #f0f2f5;
  padding: 20px;
  overflow-y: auto;
}

.el-footer {
  background-color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  border-top: 1px solid #e6e6e6;
}

.footer-content {
  text-align: center;
  color: #666;
  font-size: 12px;
}
</style>
