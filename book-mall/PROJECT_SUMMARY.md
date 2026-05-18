# 网上图书商城系统 - 项目进度总结

## 1. 技术栈

| 层级 | 技术 |
|------|------|
| 后端 | SpringBoot 2.7.18 + MyBatis Plus 3.5.3.1 |
| 前端 | Vue 2.6.14 + Element UI 2.15.14 |
| 数据库 | MySQL 8.x |
| 开发工具 | IDEA (后端) + Trae/Vue CLI (前端) |

---

## 2. 项目结构

```
book-mall/
├── backend/                    # SpringBoot 后端
│   └── src/main/java/com/bookmall/
│       ├── controller/        # 8个 Controller
│       ├── service/           # 8个 Service
│       ├── mapper/            # 8个 Mapper
│       ├── entity/            # 8个 Entity
│       └── config/            # 配置类
│
├── frontend/                  # Vue 前端
│   └── src/
│       ├── api/               # API 文件（user, book, category, order, cart, address, notice, upload）
│       ├── views/
│       │   ├── admin/         # 管理员页面（7个）
│       │   ├── home/
│       │   ├── layout/
│       │   └── login/
│       └── router/
│
├── database/
│   └── init.sql               # 8张表初始化脚本
│
└── uploads/                   # 图片上传目录
```

---

## 3. 数据库结构（8张表）

| 表名 | 主要字段 | 说明 |
|------|---------|------|
| users | id, username, password, role, phone, email... | 用户表 |
| book | id, book_name, author, price, stock, cover_image... | 图书表 |
| category | id, category_name, parent_id, category_level, sort_order... | 分类表 |
| order_info | id, order_number, user_id, total_amount, order_status... | 订单表 |
| order_item | id, order_id, book_id, quantity, price... | 订单明细表 |
| cart | id, user_id, book_id, quantity... | 购物车表 |
| address | id, user_id, receiver_name, phone, province, city... | 地址表 |
| notice | id, title, content, notice_type, status... | 公告表 |

---

## 4. 功能完成情况

### 已完成：管理员后台

| 功能 | 状态 | 说明 |
|------|------|------|
| 登录/退出 | ✅ | 完整 |
| 首页 | ✅ | 基础版本 |
| 用户管理 | ✅ | CRUD + 验证 |
| 图书管理 | ✅ | CRUD + 图片上传 |
| 分类管理 | ✅ | CRUD |
| 订单管理 | ✅ | 列表 + 发货 + 删除 |
| 购物车管理 | ✅ | 列表 + 删除 |
| 地址管理 | ✅ | 列表 + 删除 |
| 公告管理 | ✅ | CRUD |

### 待开发

| 功能 | 说明 |
|------|------|
| 用户商城页面 | 买家视角：浏览图书、购物车、下单、我的订单 |
| 商家后台 | 卖家视角：管理店铺、管理订单 |
| UI 优化 | 使用 UIUX Pro Max 美化界面 |

---

## 5. 关键配置

| 配置项 | 路径/值 |
|--------|--------|
| 后端端口 | 8080 |
| 数据库密码 | wangadmin |
| 文件上传路径 | `项目文件夹/book-mall/uploads` |
| 图片访问URL | `http://localhost:8080/uploads/...` |
| 静态资源映射 | WebMvcConfig.java 配置 |

---

## 6. 三种角色说明

| 角色 | 职责 | 订单视角 |
|------|------|---------|
| 用户 | 买书、看自己的订单 | 看到自己买过的订单 |
| 商家 | 卖书、管理店铺 | 只看到买自家书的订单 |
| 管理员 | 管整个平台 | 看到所有订单 |

---

## 7. 下一步计划

### 第一阶段：用户商城页面
- [ ] 首页（图书展示、分类筛选、搜索）
- [ ] 图书详情页
- [ ] 购物车功能
- [ ] 下单流程
- [ ] 我的订单

### 第二阶段：商家后台
- [ ] 商家登录
- [ ] 我的商品管理
- [ ] 我的订单处理

### 第三阶段：UI 优化
- [ ] 使用 UIUX Pro Max 美化界面

---

## 8. 数据库连接信息

- 地址：localhost:3306
- 用户名：root
- 密码：wangadmin
- 数据库名：book_mall

---

## 9. 项目启动方法

### 准备工作

1. 确保 MySQL 8.x 已启动（服务名称：MySQL80）
2. 确保数据库已初始化（执行 database/init.sql）

### 启动后端（SpringBoot）

**方式一：IDEA（推荐）**
1. 用 IDEA 打开 `book-mall/backend` 文件夹
2. 等待 Maven 依赖下载完成
3. 右键点击 `BookMallApplication.java`
4. 选择 "Run 'BookMallApplication'"
5. 控制台显示 `Started BookMallApplication` 即启动成功

**方式二：命令行**
```bash
cd book-mall/backend
mvn spring-boot:run
```

### 启动前端（Vue）

**方式一：Trae/Vue CLI**
1. 打开 Trae IDE 终端（快捷键 Ctrl + `）
2. 进入前端目录
```bash
cd book-mall/frontend
```
3. 启动开发服务器
```bash
npm run dev
```
4. 看到 `App running at:` 即启动成功
5. 浏览器访问 `http://localhost:9527`

**可用命令**
```bash
npm run dev    # 启动开发服务器
npm run build  # 生产环境打包
npm run        # 查看所有可用命令
```

### 访问地址

| 服务 | 地址 |
|------|------|
| 后端 API | http://localhost:8080 |
| 前端页面 | http://localhost:9527 |
| 数据库 | localhost:3306 |

### 登录账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | admin123 |

---

## 10. 常见问题

### 后端启动失败
- 检查 MySQL 是否启动
- 检查数据库密码是否正确（wangadmin）
- 检查端口 8080 是否被占用

### 前端启动失败
- 检查是否已执行 `npm install`
- 检查端口 9527 是否被占用
- 尝试清除缓存：`npm cache clean --force`

### 图片不显示
- 重启后端服务（配置文件更新需要重启）
- 检查 D:/uploads/ 目录是否有图片文件
