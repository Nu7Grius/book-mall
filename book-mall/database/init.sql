-- ============================================
-- 图书商城系统数据库初始化脚本
-- 数据库版本: MySQL 8.x
-- 创建时间: 2024年
-- ============================================

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS book_mall DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE book_mall;

-- ============================================
-- 1. 用户表 (sys_user)
-- 存储所有用户信息（管理员、商家、普通用户）
-- ============================================
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码（加密存储）',
    real_name VARCHAR(50) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号码',
    email VARCHAR(100) COMMENT '邮箱',
    avatar VARCHAR(255) COMMENT '头像URL',
    role VARCHAR(20) NOT NULL DEFAULT 'user' COMMENT '角色：admin管理员，merchant商家，user普通用户',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '用户状态：0禁用，1启用',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记：0未删除，1已删除',
    INDEX idx_username (username),
    INDEX idx_role (role),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ============================================
-- 2. 类别表 (category)
-- 存储图书分类信息
-- ============================================
DROP TABLE IF EXISTS category;
CREATE TABLE category (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '类别ID',
    category_name VARCHAR(100) NOT NULL COMMENT '类别名称',
    parent_id BIGINT DEFAULT 0 COMMENT '父类别ID（0表示顶级类别）',
    category_level INT NOT NULL DEFAULT 1 COMMENT '类别层级',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '排序号',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记',
    INDEX idx_parent_id (parent_id),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书类别表';

-- ============================================
-- 3. 图书表 (book)
-- 存储图书商品信息
-- ============================================
DROP TABLE IF EXISTS book;
CREATE TABLE book (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '图书ID',
    book_name VARCHAR(200) NOT NULL COMMENT '图书名称',
    author VARCHAR(100) COMMENT '作者',
    publisher VARCHAR(100) COMMENT '出版社',
    publish_date DATETIME COMMENT '出版日期',
    isbn VARCHAR(50) UNIQUE COMMENT 'ISBN号',
    description TEXT COMMENT '图书描述',
    price DECIMAL(10, 2) NOT NULL COMMENT '价格',
    stock INT NOT NULL DEFAULT 0 COMMENT '库存数量',
    sales INT NOT NULL DEFAULT 0 COMMENT '销量',
    cover_image VARCHAR(255) COMMENT '封面图片URL',
    category_id BIGINT COMMENT '类别ID（外键）',
    merchant_id BIGINT COMMENT '商家ID（外键）',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0下架，1上架',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记',
    INDEX idx_book_name (book_name),
    INDEX idx_author (author),
    INDEX idx_category_id (category_id),
    INDEX idx_merchant_id (merchant_id),
    INDEX idx_status (status),
    INDEX idx_sales (sales),
    CONSTRAINT fk_book_category FOREIGN KEY (category_id) REFERENCES category(id),
    CONSTRAINT fk_book_merchant FOREIGN KEY (merchant_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书表';

-- ============================================
-- 4. 地址表 (address)
-- 存储用户收货地址信息
-- ============================================
DROP TABLE IF EXISTS address;
CREATE TABLE address (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '地址ID',
    user_id BIGINT NOT NULL COMMENT '用户ID（外键）',
    receiver_name VARCHAR(50) NOT NULL COMMENT '收货人姓名',
    phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    province VARCHAR(50) NOT NULL COMMENT '省份',
    city VARCHAR(50) NOT NULL COMMENT '城市',
    district VARCHAR(50) NOT NULL COMMENT '区县',
    detail_address VARCHAR(255) NOT NULL COMMENT '详细地址',
    postal_code VARCHAR(20) COMMENT '邮政编码',
    is_default TINYINT NOT NULL DEFAULT 0 COMMENT '是否默认地址：0否，1是',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记',
    INDEX idx_user_id (user_id),
    INDEX idx_is_default (is_default),
    CONSTRAINT fk_address_user FOREIGN KEY (user_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收货地址表';

-- ============================================
-- 5. 购物车表 (cart)
-- 存储用户购物车中的商品
-- ============================================
DROP TABLE IF EXISTS cart;
CREATE TABLE cart (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '购物车ID',
    user_id BIGINT NOT NULL COMMENT '用户ID（外键）',
    book_id BIGINT NOT NULL COMMENT '图书ID（外键）',
    quantity INT NOT NULL DEFAULT 1 COMMENT '购买数量',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记',
    UNIQUE KEY uk_user_book (user_id, book_id, deleted),
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id),
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES sys_user(id),
    CONSTRAINT fk_cart_book FOREIGN KEY (book_id) REFERENCES book(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';

-- ============================================
-- 6. 订单表 (order_info)
-- 存储订单主信息
-- ============================================
DROP TABLE IF EXISTS order_info;
CREATE TABLE order_info (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    order_number VARCHAR(50) NOT NULL UNIQUE COMMENT '订单编号',
    user_id BIGINT NOT NULL COMMENT '用户ID（外键）',
    address_id BIGINT COMMENT '收货地址ID（外键）',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT '订单总金额',
    order_status VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '订单状态：pending待支付，paid已支付，shipped已发货，completed已完成，cancelled已取消',
    payment_method VARCHAR(20) COMMENT '支付方式：wechat微信，alipay支付宝，balance余额',
    payment_time DATETIME COMMENT '支付时间',
    shipping_time DATETIME COMMENT '发货时间',
    completion_time DATETIME COMMENT '完成时间',
    remark VARCHAR(500) COMMENT '订单备注',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记',
    INDEX idx_order_number (order_number),
    INDEX idx_user_id (user_id),
    INDEX idx_order_status (order_status),
    INDEX idx_create_time (create_time),
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES sys_user(id),
    CONSTRAINT fk_order_address FOREIGN KEY (address_id) REFERENCES address(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- ============================================
-- 7. 订单明细表 (order_item)
-- 存储订单中的商品明细（第三范式：避免数据冗余）
-- ============================================
DROP TABLE IF EXISTS order_item;
CREATE TABLE order_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '订单明细ID',
    order_id BIGINT NOT NULL COMMENT '订单ID（外键）',
    book_id BIGINT NOT NULL COMMENT '图书ID（外键）',
    book_name VARCHAR(200) NOT NULL COMMENT '图书名称（冗余字段，提高查询效率）',
    author VARCHAR(100) COMMENT '作者（冗余字段）',
    cover_image VARCHAR(255) COMMENT '封面图片（冗余字段）',
    price DECIMAL(10, 2) NOT NULL COMMENT '购买时的单价',
    quantity INT NOT NULL COMMENT '购买数量',
    subtotal DECIMAL(10, 2) NOT NULL COMMENT '小计金额',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记',
    INDEX idx_order_id (order_id),
    INDEX idx_book_id (book_id),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id) REFERENCES order_info(id),
    CONSTRAINT fk_orderitem_book FOREIGN KEY (book_id) REFERENCES book(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单明细表';

-- ============================================
-- 8. 公告表 (notice)
-- 存储系统公告信息
-- ============================================
DROP TABLE IF EXISTS notice;
CREATE TABLE notice (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '公告ID',
    title VARCHAR(200) NOT NULL COMMENT '公告标题',
    content TEXT NOT NULL COMMENT '公告内容',
    notice_type VARCHAR(20) DEFAULT 'system' COMMENT '公告类型：system系统公告，activity活动公告，maintenance维护公告',
    publisher_id BIGINT COMMENT '发布人ID（外键）',
    publish_time DATETIME COMMENT '发布时间',
    end_time DATETIME COMMENT '结束时间（可选）',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0下架，1上架',
    view_count INT NOT NULL DEFAULT 0 COMMENT '浏览次数',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记',
    INDEX idx_publish_time (publish_time),
    INDEX idx_status (status),
    INDEX idx_notice_type (notice_type),
    CONSTRAINT fk_notice_publisher FOREIGN KEY (publisher_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统公告表';

-- ============================================
-- 插入初始化数据
-- ============================================

-- 插入管理员账号（密码：123456，BCrypt加密）
INSERT INTO sys_user (username, password, real_name, phone, email, role, status) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', '13800138000', 'admin@bookmall.com', 'admin', 1),
('merchant1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '商家用户1', '13800138001', 'merchant1@bookmall.com', 'merchant', 1),
('user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '普通用户1', '13800138002', 'user1@bookmall.com', 'user', 1);

-- 插入图书类别
INSERT INTO category (category_name, parent_id, category_level, sort_order) VALUES
('文学', 0, 1, 1),
('小说', 1, 2, 1),
('诗歌', 1, 2, 2),
('计算机', 0, 1, 2),
('编程语言', 4, 2, 1),
('数据库', 4, 2, 2),
('历史', 0, 1, 3),
('中国历史', 7, 2, 1),
('世界历史', 7, 2, 2);

-- 插入图书（关联商家1）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status) VALUES
('深入理解计算机系统', 'Randal E. Bryant', '机械工业出版社', 139.00, 100, 50, 5, 2, 1),
('算法导论', 'Thomas H. Cormen', '电子工业出版社', 128.00, 80, 45, 5, 2, 1),
('Java核心技术', 'Cay S. Horstmann', '人民邮电出版社', 119.00, 120, 60, 5, 2, 1),
('三体', '刘慈欣', '重庆出版社', 68.00, 200, 150, 2, 2, 1),
('活着', '余华', '作家出版社', 28.00, 150, 80, 2, 2, 1);

-- 插入公告
INSERT INTO notice (title, content, notice_type, publisher_id, publish_time, status) VALUES
('系统升级通知', '系统将于本周日凌晨2:00-6:00进行升级维护，届时可能影响正常使用。', 'maintenance', 1, NOW(), 1),
('新功能上线', '图书评论功能已上线，欢迎大家使用并提出宝贵意见。', 'system', 1, NOW(), 1),
('春节优惠活动', '春节期间全场图书8折优惠，优惠码：SPRING2024', 'activity', 1, NOW(), 1);

-- ============================================
-- 数据验证查询
-- ============================================
-- SELECT '初始化数据完成！' AS message;
-- SELECT COUNT(*) AS user_count FROM sys_user;
-- SELECT COUNT(*) AS book_count FROM book;
-- SELECT COUNT(*) AS category_count FROM category;
