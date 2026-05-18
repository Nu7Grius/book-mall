# 书魂商城系统

基于 SpringBoot 2 + Vue 2 + uni-app **三端一体化**的图书商城系统，涵盖管理员后台、商家端、商城前台和微信小程序。

> 项目源码位于 [`book-mall/`](./book-mall) 目录下

---

## 项目结构

```
book-mall/
├── backend/                    # SpringBoot 后端项目
│   ├── controller/             # API 控制器
│   ├── service/                # 业务逻辑层
│   ├── entity/                 # 实体模型
│   └── config/                 # 配置类
├── frontend/                   # Vue 2 前端（三端合一）
│   └── src/views/
│       ├── admin/              # 管理员后台
│       ├── merchant/           # 商家端
│       ├── shop/               # 商城前台（用户端）
│       └── user/               # 登录注册
├── mini-program/               # 微信小程序（uni-app）
└── supabase/migrations/        # 数据库迁移脚本
```

## 技术栈

| 端 | 技术 |
|:---|:----|
| 后端 | Java 8+ / SpringBoot 2.7 / MyBatis Plus / MySQL + PostgreSQL / Redis |
| 前端（PC） | Vue 2.6 + Element UI 2.15 |
| 小程序 | uni-app |

## 核心功能

- **三种角色**：管理员、商家、普通用户
- **图书管理**：CRUD、上下架、审核、图片上传
- **分类管理**：两级树形结构
- **购物车**：多商家商品合并下单
- **订单管理**：8种状态流转（待付款→待发货→待收货→待评价→已完成 / 取消 / 退款）
- **退款系统**：用户申请 → 商家审核 → 退款处理
- **图书评论**：评分、商家回复、匿名评价（仅订单中可评价）
- **数据统计**：商家销售统计、管理员全局统计

## ⚠️ 前置依赖

| 依赖 | 用途 | 获取方式 |
|:----|:----|:--------|
| **JDK 8+** | 运行后端 | https://www.oracle.com/java/ |
| **Node.js 14+** | 运行前端 | https://nodejs.org/ |
| **Maven** | 构建后端 | IDEA 自带 或 https://maven.apache.org/ |
| **MySQL 8.x** | 本地数据库 | https://dev.mysql.com/downloads/ |
| **Redis** | 验证码缓存 | https://redis.io/download/ |

> 如果不需要验证码功能，也可以不装 Redis，启动时忽略 Redis 连接错误即可。

## 快速开始

### 第1步：创建数据库并导入演示数据

```bash
# 登录 MySQL
mysql -u root -p

# 创建数据库
CREATE DATABASE book_mall CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit;

# 建表
mysql -u root -p book_mall < supabase/migrations/create_tables.sql

# 导入演示数据（用户、图书、订单等完整数据）
mysql -u root -p book_mall < supabase/migrations/import_data.sql
mysql -u root -p book_mall < supabase/migrations/import_simple.sql
mysql -u root -p book_mall < supabase/migrations/import_orders.sql
```

### 第2步：修改数据库密码

打开 `book-mall/backend/src/main/resources/application.yml`，将密码改为你自己的 MySQL 密码：

```yaml
spring:
  datasource:
    password: 你的MySQL密码
```

> 上传路径已配置为相对路径（`../uploads`），无需手动修改。

### 第3步：启动后端

```bash
cd book-mall/backend
mvn spring-boot:run
```

后端地址：`http://localhost:8080`

### 第4步：启动前端

```bash
cd book-mall/frontend
npm install
npm run dev
```

前端地址：`http://localhost:9527`

## 登录账号

| 角色 | 用户名 | 密码 |
|:----|:------|:----|
| 超级管理员 | `admin` | `admin123` |
| 普通管理员 | `admincommon` | `123456` |
| 商家（茑屋书店） | `merchant1` | `123456` |
| 商家（西西弗书店） | `merchant2` | `123456` |
| 商家（思南书局） | `merchant3` | `123456` |
| 普通用户 | `user1` | `123456` |
| 普通用户 | `user2` | `admin123` |

## 小程序端

微信小程序源码位于 `book-mall/mini-program/` 目录。

### 快速使用（推荐）

直接用微信开发者工具打开已编译的文件夹：

```
book-mall/mini-program/unpackage/dist/dev/mp-weixin
```

### 从源码重新编译

如需修改代码后重新编译（如修改页面样式、接口地址等）：

1. 使用 **HBuilderX** 打开 `book-mall/mini-program/` 目录
2. 在 HBuilderX 中修改代码后，点击顶部菜单"运行"→"运行到小程序模拟器"→"微信开发者工具"
3. 编译完成后，项目根目录会出现 `fix-lazyCodeLoading.bat` 文件，双击运行（因 uni-app 编译后默认开启懒加载，需要此脚本修复才能使小程序稳定运行）
4. 回到微信开发者工具，点击工具栏"编译"按钮刷新预览

## 演示数据

- **7个账号**（管理员、商家、用户全角色）
- **50+本图书**（编程、文学、历史、心理等分类）
- **51个分类**（两级树形结构）
- **多个状态的订单**（待发货、待收货、已完成、退款中等）
- **图书评论和商家回复**
- **收藏记录、购物车数据**

---

> 详细文档请查看 [`book-mall/README.md`](./book-mall/README.md)
