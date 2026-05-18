-- 图书收藏表
-- 用于存储用户收藏的图书信息

DROP TABLE IF EXISTS book_favorite;

CREATE TABLE book_favorite (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '收藏ID',
    user_id BIGINT NOT NULL COMMENT '用户ID（外键）',
    book_id BIGINT NOT NULL COMMENT '图书ID（外键）',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id),
    UNIQUE KEY uk_user_book (user_id, book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书收藏表';
