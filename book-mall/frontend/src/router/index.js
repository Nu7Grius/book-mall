import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/Login.vue')
  },
  {
    path: '/admin',
    redirect: '/login'
  },
  {
    path: '/user-login',
    name: 'UserLogin',
    component: () => import('@/views/user/UserLogin.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/user/UserRegister.vue')
  },
  {
    path: '/merchant-register',
    name: 'MerchantRegister',
    component: () => import('@/views/user/MerchantRegister.vue')
  },
  {
    path: '/home',
    component: () => import('@/views/shop/ShopLayout.vue'),
    children: [
      {
        path: '',
        name: 'HomeIndex',
        component: () => import('@/views/shop/HomeIndex.vue')
      },
      {
        path: 'books',
        name: 'BookListPage',
        component: () => import('@/views/shop/BookListPage.vue')
      },
      {
        path: 'books/hot',
        name: 'HotBooks',
        component: () => import('@/views/shop/BookListPage.vue'),
        props: { filterType: 'hot' }
      },
      {
        path: 'books/new',
        name: 'NewBooks',
        component: () => import('@/views/shop/BookListPage.vue'),
        props: { filterType: 'new' }
      },
      {
        path: 'search',
        name: 'SearchResults',
        component: () => import('@/views/shop/BookListPage.vue')
      },
      {
        path: 'cart',
        name: 'Cart',
        component: () => import('@/views/shop/Cart.vue')
      },
      {
        path: 'confirm-order',
        name: 'ConfirmOrder',
        component: () => import('@/views/shop/ConfirmOrder.vue')
      },
      {
        path: 'my-orders',
        name: 'MyOrders',
        component: () => import('@/views/shop/MyOrders.vue')
      },
      {
        path: 'order-detail/:id',
        name: 'OrderDetail',
        component: () => import('@/views/shop/OrderDetail.vue')
      },
      {
        path: 'my-address',
        name: 'MyAddress',
        component: () => import('@/views/shop/MyAddress.vue')
      },
      {
        path: 'my-favorites',
        name: 'MyFavorites',
        component: () => import('@/views/shop/MyFavorites.vue')
      },
      {
        path: 'my-profile',
        name: 'MyProfile',
        component: () => import('@/views/shop/MyProfile.vue')
      },
      {
        path: 'customer-service',
        name: 'CustomerService',
        component: () => import('@/views/shop/CustomerService.vue')
      },
      {
        path: 'notice',
        name: 'UserNotice',
        component: () => import('@/views/shop/UserNotice.vue')
      },
      {
        path: 'book-detail/:id',
        name: 'BookDetail',
        component: () => import('@/views/shop/BookDetail.vue')
      }
    ]
  },
  {
    path: '/layout',
    name: 'Layout',
    component: () => import('@/views/layout/Layout.vue'),
    children: [
      {
        path: 'home',
        name: 'Home',
        component: () => import('@/views/home/Home.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'customer-list',
        name: 'CustomerList',
        component: () => import('@/views/admin/CustomerList.vue'),
        meta: { title: '用户信息' }
      },
      {
        path: 'merchant-list',
        name: 'MerchantList',
        component: () => import('@/views/admin/MerchantList.vue'),
        meta: { title: '商家信息' }
      },
      {
        path: 'admin-list',
        name: 'AdminList',
        component: () => import('@/views/admin/AdminList.vue'),
        meta: { title: '管理员信息' }
      },
      {
        path: 'user-list',
        name: 'UserList',
        component: () => import('@/views/admin/UserList.vue'),
        meta: { title: '用户信息管理' }
      },
      {
        path: 'book-list',
        name: 'BookList',
        component: () => import('@/views/admin/BookList.vue'),
        meta: { title: '图书管理' }
      },
      {
        path: 'category-list',
        name: 'CategoryList',
        component: () => import('@/views/admin/CategoryList.vue'),
        meta: { title: '分类管理' }
      },
      {
        path: 'order-list',
        name: 'OrderList',
        component: () => import('@/views/admin/OrderList.vue'),
        meta: { title: '订单管理' }
      },
      {
        path: 'notice-list',
        name: 'NoticeList',
        component: () => import('@/views/admin/NoticeList.vue'),
        meta: { title: '公告管理' }
      },
      {
        path: 'comment-list',
        name: 'CommentList',
        component: () => import('@/views/admin/CommentList.vue'),
        meta: { title: '评论管理' }
      },
      {
        path: 'admin-profile',
        name: 'AdminProfile',
        component: () => import('@/views/admin/AdminProfile.vue'),
        meta: { title: '个人中心' }
      }
    ]
  },
  {
    path: '/merchant',
    name: 'Merchant',
    component: () => import('@/views/merchant/MerchantLayout.vue'),
    children: [
      {
        path: 'home',
        name: 'MerchantHome',
        component: () => import('@/views/merchant/MerchantHome.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'book-list',
        name: 'MerchantBookList',
        component: () => import('@/views/merchant/MerchantBookList.vue'),
        meta: { title: '图书管理' }
      },
      {
        path: 'book-add',
        name: 'MerchantBookAdd',
        component: () => import('@/views/merchant/MerchantBookAdd.vue'),
        meta: { title: '添加图书' }
      },
      {
        path: 'book-edit/:id',
        name: 'MerchantBookEdit',
        component: () => import('@/views/merchant/MerchantBookEdit.vue'),
        meta: { title: '编辑图书' }
      },
      {
        path: 'order-list',
        name: 'MerchantOrderList',
        component: () => import('@/views/merchant/MerchantOrderList.vue'),
        meta: { title: '订单管理' }
      },
      {
        path: 'statistics',
        name: 'MerchantStatistics',
        component: () => import('@/views/merchant/MerchantStatistics.vue'),
        meta: { title: '数据统计' }
      },
      {
        path: 'comment-list',
        name: 'MerchantCommentList',
        component: () => import('@/views/merchant/MerchantComment.vue'),
        meta: { title: '评论管理' }
      },
      {
        path: 'shop-info',
        name: 'MerchantShopInfo',
        component: () => import('@/views/merchant/MerchantShopInfo.vue'),
        meta: { title: '店铺设置' }
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  const publicPaths = ['/login', '/user-login', '/register', '/merchant-register', '/home', '/book-detail']
  if (publicPaths.includes(to.path) || to.path.startsWith('/book-detail')) {
    next()
  } else {
    const token = localStorage.getItem('token')
    if (!token) {
      next('/login')
    } else {
      next()
    }
  }
})

export default router
