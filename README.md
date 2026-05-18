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

## 快速启动

### 后端
```bash
cd book-mall/backend
mvn spring-boot:run
```

### 前端
```bash
cd book-mall/frontend
npm install
npm run dev
```

## 登录账号

| 角色 | 用户名 | 密码 |
|:----|:------|:----|
| 超级管理员 | `admin` | `123456` |
| 商家（蘑菇书店） | `merchant1` | `123456` |
| 商家（西西弗书店） | `merchant2` | `123456` |
| 商家（思南书局） | `merchant3` | `123456` |
| 普通用户 | `user1` / `user2` | `123456` |

## 小程序端

源码位于 `book-mall/mini-program/`，使用 HBuilderX 打开运行。

---

> 详细文档请查看 [`book-mall/README.md`](./book-mall/README.md)
