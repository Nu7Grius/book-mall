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
- **订单管理**：8种状态流转（含退款流程）
- **评论系统**：评分、商家回复、匿名评价
- **数据统计**：商家销售统计、管理员全局统计

## ⚠️ 前置依赖（必须安装）

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

# 建表（执行迁移脚本）
mysql -u root -p book_mall < supabase/migrations/create_tables.sql

# 导入演示数据（包含用户、图书、订单等完整演示数据）
mysql -u root -p book_mall < supabase/migrations/import_data.sql
mysql -u root -p book_mall < supabase/migrations/import_simple.sql
mysql -u root -p book_mall < supabase/migrations/import_orders.sql
```

### 第2步：修改后端数据库配置

打开 `book-mall/backend/src/main/resources/application.yml`，将数据库密码改为你自己的 MySQL 密码：

```yaml
spring:
  datasource:
    password: 你的MySQL密码  # 改为你自己的密码
```

### 第3步：启动后端

```bash
cd book-mall/backend
mvn spring-boot:run
```

后端默认启动在 `http://localhost:8080`

### 第4步：启动前端

```bash
cd book-mall/frontend
npm install
npm run dev
```

前端默认启动在 `http://localhost:9527`

## 登录账号

| 角色 | 用户名 | 密码 |
|:----|:------|:----|
| 超级管理员 | `admin` | `123456` |
| 商家（蘑菇书店） | `merchant1` | `123456` |
| 商家（西西弗书店） | `merchant2` | `123456` |
| 商家（思南书局） | `merchant3` | `123456` |
| 普通用户 | `user1` / `user2` | `123456` |

## 小程序端

源码位于 `book-mall/mini-program/`，使用 **HBuilderX** 打开并运行到微信开发者工具。

**注意：** 小程序需要配置 `mini-program/config/index.js` 中的后端接口地址为你的电脑局域网 IP。

## 演示数据说明

项目已包含完整的演示数据，导入后即可体验所有功能：

- **7个账号**（管理员、商家、用户全角色）
- **50+本图书**（编程、文学、历史、心理等分类）
- **51个分类**（两级树形结构）
- **多个状态的订单**（待发货、待收货、已完成、退款中等）
- **图书评论和商家回复**
- **收藏记录、购物车数据**

---

> 详细文档请查看 [`book-mall/README.md`](./book-mall/README.md)
