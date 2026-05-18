-- ============================================================
-- 书魂商城系统 - Supabase 建表迁移脚本
-- 说明：与本地MySQL表结构完全一致，包含全部字段
-- ============================================================

-- 1. sys_user 用户表
CREATE TABLE sys_user (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    real_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    avatar VARCHAR(500),
    gender VARCHAR(10),
    age INTEGER,
    role VARCHAR(20) NOT NULL,
    shop_type VARCHAR(50),
    shop_name VARCHAR(200),
    logo VARCHAR(500),
    description TEXT,
    address VARCHAR(500),
    bank_name VARCHAR(100),
    bank_account VARCHAR(100),
    bank_account_name VARCHAR(100),
    status INTEGER DEFAULT 1,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0,
    CONSTRAINT uk_username_role UNIQUE (username, role)
);

-- 2. book 图书表
CREATE TABLE book (
    id BIGSERIAL PRIMARY KEY,
    book_name VARCHAR(200) NOT NULL,
    author VARCHAR(100),
    publisher VARCHAR(200),
    publish_date TIMESTAMP,
    isbn VARCHAR(20),
    description TEXT,
    price DECIMAL(10,2),
    stock INTEGER DEFAULT 0,
    sales INTEGER DEFAULT 0,
    cover_image VARCHAR(500),
    category_id BIGINT,
    merchant_id BIGINT,
    status INTEGER DEFAULT 0,
    audit_status INTEGER DEFAULT 0,
    audit_time TIMESTAMP,
    audit_remark VARCHAR(500),
    audit_user_id BIGINT,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0
);

-- 3. category 分类表
CREATE TABLE category (
    id BIGSERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_id BIGINT DEFAULT 0,
    category_level INTEGER,
    sort_order INTEGER DEFAULT 0,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0
);

-- 4. cart 购物车表
CREATE TABLE cart (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    book_id BIGINT NOT NULL,
    quantity INTEGER DEFAULT 1,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0
);

-- 5. order_info 订单表
CREATE TABLE order_info (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL,
    user_id BIGINT NOT NULL,
    address_id BIGINT,
    total_amount DECIMAL(10,2),
    order_status VARCHAR(20),
    payment_method VARCHAR(50),
    payment_time TIMESTAMP,
    shipping_time TIMESTAMP,
    express_company VARCHAR(100),
    express_no VARCHAR(50),
    completion_time TIMESTAMP,
    refund_time TIMESTAMP,
    refund_id BIGINT,
    remark VARCHAR(500),
    remind_ship INTEGER DEFAULT 0,
    remind_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0
);

-- 6. order_item 订单项表
CREATE TABLE order_item (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    book_id BIGINT,
    book_name VARCHAR(200),
    cover_image VARCHAR(500),
    price DECIMAL(10,2),
    quantity INTEGER,
    subtotal DECIMAL(10,2),
    merchant_id BIGINT,
    merchant_name VARCHAR(200),
    merchant_phone VARCHAR(20),
    author VARCHAR(100),
    status VARCHAR(20),
    refund_status VARCHAR(20),
    refund_id BIGINT,
    express_company VARCHAR(100),
    express_no VARCHAR(50)
);

-- 7. book_comment 图书评论表
CREATE TABLE book_comment (
    id BIGSERIAL PRIMARY KEY,
    book_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    order_id BIGINT,
    rating INTEGER,
    content TEXT,
    is_anonymous INTEGER DEFAULT 0,
    status INTEGER DEFAULT 1,
    reply_content TEXT,
    reply_time TIMESTAMP,
    reply_role VARCHAR(20),
    reply_user_id BIGINT,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0
);

-- 8. book_favorite 图书收藏表
CREATE TABLE book_favorite (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    book_id BIGINT NOT NULL,
    create_time TIMESTAMP DEFAULT NOW()
);

-- 9. address 收货地址表
CREATE TABLE address (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    receiver_name VARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    province VARCHAR(50),
    city VARCHAR(50),
    district VARCHAR(50),
    detail_address VARCHAR(500),
    postal_code VARCHAR(20),
    is_default INTEGER DEFAULT 0,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0
);

-- 10. refund_request 退款申请表
CREATE TABLE refund_request (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT,
    user_id BIGINT,
    merchant_id BIGINT,
    order_item_id BIGINT,
    refund_reason VARCHAR(500),
    refund_description TEXT,
    refund_amount DECIMAL(10,2),
    refund_status VARCHAR(20),
    merchant_reply TEXT,
    original_status VARCHAR(20),
    process_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0
);

-- 11. notice 公告通知表
CREATE TABLE notice (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    cover_image VARCHAR(500),
    notice_type VARCHAR(50),
    publisher_id BIGINT,
    publish_time TIMESTAMP,
    end_time TIMESTAMP,
    status INTEGER DEFAULT 1,
    view_count INTEGER DEFAULT 0,
    create_time TIMESTAMP DEFAULT NOW(),
    update_time TIMESTAMP DEFAULT NOW(),
    deleted INTEGER DEFAULT 0
);

-- 创建索引
CREATE INDEX idx_book_category_id ON book(category_id);
CREATE INDEX idx_book_merchant_id ON book(merchant_id);
CREATE INDEX idx_book_status ON book(status);
CREATE INDEX idx_cart_user_id ON cart(user_id);
CREATE INDEX idx_cart_book_id ON cart(book_id);
CREATE INDEX idx_order_info_user_id ON order_info(user_id);
CREATE INDEX idx_order_info_order_number ON order_info(order_number);
CREATE INDEX idx_order_item_order_id ON order_item(order_id);
CREATE INDEX idx_book_comment_book_id ON book_comment(book_id);
CREATE INDEX idx_book_comment_user_id ON book_comment(user_id);
CREATE INDEX idx_book_favorite_user_id ON book_favorite(user_id);
CREATE INDEX idx_book_favorite_book_id ON book_favorite(book_id);
CREATE INDEX idx_address_user_id ON address(user_id);
CREATE INDEX idx_refund_request_order_id ON refund_request(order_id);
CREATE INDEX idx_refund_request_order_item_id ON refund_request(order_item_id);
CREATE INDEX idx_notice_publisher_id ON notice(publisher_id);
CREATE INDEX idx_sys_user_role ON sys_user(role);
