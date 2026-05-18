# 网上图书商城系统

基于 SpringBoot 2 + Vue 2 的前后端分离图书商城系统

## 项目结构

```
book-mall/
├── backend/          # SpringBoot 后端项目
├── frontend/         # Vue 2 前端项目
└── database/         # 数据库脚本
```

## 快速开始

### 1. 后端启动

```bash
cd backend

# 导入数据库
mysql -u root -p < ../database/init.sql

# 修改 application.yml 中的数据库配置

# 启动后端服务
mvn spring-boot:run
```

后端服务地址：`http://localhost:8080`

### 2. 前端启动

```bash
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

前端服务地址：`http://localhost:9527`

### 3. 登录测试

- 管理员账号：`admin` / `123456`

## 技术栈

### 后端
- Java 8
- SpringBoot 2.7.18
- MyBatis Plus 3.5.3.1
- MySQL 8.x

### 前端
- Vue 2.6.14
- Element UI 2.15.14
- Axios
- Vue Router 3.5.1

## 核心功能模块

- 用户管理（管理员、商家、普通用户）
- 图书管理（CRUD、上下架）
- 类别管理（树形结构）
- 订单管理
- 购物车
- 地址管理
- 公告管理

## 角色权限

- `admin`：系统管理员，拥有所有权限
- `merchant`：商家，可以管理自己的图书
- `user`：普通用户，可以浏览图书、下单购物

## 数据库表

- `sys_user`：用户表
- `category`：类别表
- `book`：图书表
- `address`：地址表
- `cart`：购物车表
- `order_info`：订单表
- `order_item`：订单明细表
- `notice`：公告表
