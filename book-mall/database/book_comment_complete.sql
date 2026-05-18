-- 完整重建评论表，确保所有字段都正确
DROP TABLE IF EXISTS book_comment;

CREATE TABLE book_comment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评论ID',
    book_id BIGINT NOT NULL COMMENT '图书ID（外键）',
    user_id BIGINT NOT NULL COMMENT '用户ID（外键）',
    order_id BIGINT COMMENT '关联订单ID（可选）',
    rating INT NOT NULL DEFAULT 5 COMMENT '评分：1-5星',
    content TEXT NOT NULL COMMENT '评价内容',
    is_anonymous TINYINT NOT NULL DEFAULT 0 COMMENT '是否匿名：0否，1是',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0隐藏，1显示',
    reply_content TEXT COMMENT '商家回复内容',
    reply_time DATETIME COMMENT '商家回复时间',
    reply_role VARCHAR(20) DEFAULT NULL COMMENT '回复人角色：admin管理员，merchant商家',
    reply_user_id BIGINT DEFAULT NULL COMMENT '回复人ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记：0未删除，1已删除',
    INDEX idx_book_id (book_id),
    INDEX idx_user_id (user_id),
    INDEX idx_order_id (order_id),
    INDEX idx_rating (rating),
    INDEX idx_status (status),
    INDEX idx_create_time (create_time),
    CONSTRAINT fk_comment_book FOREIGN KEY (book_id) REFERENCES book(id),
    CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES sys_user(id),
    CONSTRAINT fk_comment_order FOREIGN KEY (order_id) REFERENCES order_info(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书评论表';

-- 插入测试评论数据
INSERT INTO book_comment (book_id, user_id, rating, content, status, create_time) VALUES
(1, 3, 5, '<p>这本书非常棒！讲解深入浅出，值得一读。</p>', 1, NOW()),
(1, 3, 4, '<p>内容很充实，但是排版可以再改进一下。</p>', 1, NOW()),
(4, 3, 5, '<p>三体太震撼了！刘慈欣的想象力简直无穷无尽，期待续作！</p>', 1, NOW()),
(5, 3, 5, '<p>余华的文字朴实无华，但直击人心。读完久久不能平静。</p>', 1, NOW());
