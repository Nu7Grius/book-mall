# 书魂商城系统

基于 SpringBoot 2 + Vue 2 + uni-app **三端一体化**的图书商城系统，涵盖管理员后台、商家端、商城前台和微信小程序。

## 项目架构

```
book-mall/
├── backend/                    # SpringBoot 后端项目
│   ├── src/main/java/.../
│   │   ├── controller/         # API 控制器
│   │   ├── service/            # 业务逻辑层
│   │   ├── entity/             # 实体模型
│   │   ├── mapper/             # MyBatis Plus Mapper
│   │   ├── config/             # 配置类（跨域、安全、Swagger等）
│   │   └── common/             # 公共工具（全局异常处理、Result等）
│   └── src/main/resources/
│       ├── application.yml             # 本地 MySQL 配置（默认）
│       └── application-supabase.yml    # 云端 Supabase 配置
├── frontend/                   # 前端项目（Vue 2 + Element UI）
│   └── src/
│       ├── views/
│       │   ├── admin/          # 管理员后台（用户/图书/订单/分类管理）
│       │   ├── merchant/       # 商家端（店铺/商品/订单/统计）
│       │   ├── shop/           # 商城前台（首页/详情/购物车/订单）
│       │   ├── user/           # 登录注册
│       │   └── layout/         # 布局组件
│       └── api/                # API 接口封装
├── mini-program/               # 微信小程序端（uni-app）
│   ├── pages/                  # 首页、分类、购物车、个人中心等
│   └── subpkg/                 # 子包（评论、退款、客服等）
└── supabase/migrations/        # Supabase 数据库迁移脚本
```

## 技术栈

### 后端
- **Java 8+**（兼容 Java 21）
- **SpringBoot 2.7.18**
- **MyBatis Plus 3.5.3.1**
- **MySQL 8.x** / **PostgreSQL**（双数据库支持）
- **Redis**（验证码缓存）
- **Spring Security**（密码加密）
- **Swagger 3.0**（API 文档）

### 前端（Vue Admin）
- **Vue 2.6.14**
- **Element UI 2.15.14**
- **Axios** / **Vue Router 3**
- **富文本编辑器**（图书描述）

### 微信小程序
- **uni-app** 框架
- 支持微信支付流程

## 核心功能

### 三种角色
| 角色 | 功能范围 |
|:----|:--------|
| **管理员** | 用户管理、图书审核、分类管理、订单管理、公告管理、数据统计 |
| **商家** | 店铺管理、商品发布/编辑、订单处理（发货/退款）、评论回复、销售统计 |
| **普通用户** | 浏览图书、购物车、下单、评论、收藏、地址管理、退款申请 |

### 业务模块
- 图书管理（CRUD、上下架、审核、图片上传）
- 分类管理（树形结构，两级分类）
- 购物车（增删改查、多商家商品合并下单）
- 订单管理（8种状态流转：待付款→待发货→待收货→待评价→已完成 / 取消 / 退款）
- 退款系统（用户申请 → 商家审核 → 退款处理）
- 图书评论（评分、商家回复、匿名评价）
- 收藏管理
- 公告通知
- 数据统计（商家销售统计、管理员全局统计）
- 快递物流（商家发货录入快递单号）

## 前置依赖

| 依赖 | 用途 |
|:----|:----|
| **JDK 8+** | 运行后端 |
| **Node.js 14+** | 运行前端 |
| **Maven** | 构建后端 |
| **MySQL 8.x** | 本地数据库 |
| **Redis** | 验证码缓存 |

> 如果不需要验证码功能，也可以不装 Redis。

## 快速开始

### 方式一：使用本地 MySQL

**1. 创建数据库并导入演示数据**

```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS book_mall CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p book_mall < ../supabase/migrations/create_tables.sql
mysql -u root -p book_mall < ../supabase/migrations/import_data.sql
mysql -u root -p book_mall < ../supabase/migrations/import_simple.sql
mysql -u root -p book_mall < ../supabase/migrations/import_orders.sql
```

**2. 修改数据库密码**

打开 `src/main/resources/application.yml`，将 `spring.datasource.password` 改为你的 MySQL 密码。

**3. 启动后端**

```bash
cd backend
mvn spring-boot:run
```

后端地址：`http://localhost:8080`

**4. 启动前端**

```bash
cd frontend
npm install
npm run dev
```

前端地址：`http://localhost:9527`

### 方式二：使用 Supabase 云端数据库

**1. 修改后端配置**

IDEA 启动配置中添加：
- Program arguments: `--spring.profiles.active=supabase`
- Environment variables: `SUPABASE_DB_PASSWORD=你的数据库密码`

**2. 启动后端和前端**（同上）

## 登录账号

| 角色 | 用户名 | 密码 |
|:----|:------|:----|
| 超级管理员 | `admin` | `123456` |
| 普通管理员 | `admincommon` | `123456` |
| 商家（茑屋书店） | `merchant1` | `123456` |
| 商家（西西弗书店） | `merchant2` | `123456` |
| 商家（思南书局） | `merchant3` | `123456` |
| 普通用户 | `user1` | `123456` |
| 普通用户 | `user2` | `123456` |

## 小程序端

微信小程序源码位于 `mini-program/` 目录。

### 快速使用（推荐）

直接用微信开发者工具打开已编译的文件夹：

```
mini-program/unpackage/dist/dev/mp-weixin
```

### 从源码重新编译

如需修改代码后重新编译（如修改页面样式、接口地址等）：

1. 使用 **HBuilderX** 打开 `mini-program/` 目录
2. 在 HBuilderX 中修改代码后，点击顶部菜单"运行"→"运行到小程序模拟器"→"微信开发者工具"
3. 编译完成后，项目根目录会出现 `fix-lazyCodeLoading.bat` 文件，双击运行（因 uni-app 编译后默认开启懒加载，需要此脚本修复才能使小程序稳定运行）
4. 回到微信开发者工具，点击工具栏"编译"按钮刷新预览

## 演示数据

项目包含完整的演示数据：
- 50+ 本图书（涵盖编程、文学、历史、心理等分类）
- 51 个分类（两级树形结构）
- 多个状态的订单（待发货、待收货、已完成、退款中等）
- 图书评论和商家回复
- 收藏记录

## 部署说明

### 上传到 GitHub

```bash
git add .
git commit -m "提交说明"
git push
```
