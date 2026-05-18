-- ============================================
-- 执行退款功能数据库更新脚本
-- 直接在MySQL中执行以下语句即可
-- ============================================

USE book_mall;

-- 1. 创建退款申请表
DROP TABLE IF EXISTS refund_request;
CREATE TABLE refund_request (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '退款申请ID',
    order_id BIGINT NOT NULL COMMENT '订单ID（外键）',
    user_id BIGINT NOT NULL COMMENT '用户ID（外键）',
    refund_reason VARCHAR(50) NOT NULL COMMENT '退款原因：1商品损坏，2商品错发，3不想买了，4其他',
    refund_description VARCHAR(500) COMMENT '退款详细说明',
    refund_amount DECIMAL(10, 2) NOT NULL COMMENT '退款金额',
    refund_status VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '退款状态：pending待处理，approved已同意，rejected已拒绝',
    merchant_reply VARCHAR(500) COMMENT '商家回复',
    process_time DATETIME COMMENT '处理时间',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标记',
    INDEX idx_order_id (order_id),
    INDEX idx_user_id (user_id),
    INDEX idx_refund_status (refund_status),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='退款申请表';

-- 2. 修改订单表，添加退款相关字段
ALTER TABLE order_info
ADD COLUMN refund_time DATETIME COMMENT '退款时间' AFTER completion_time;

ALTER TABLE order_info
ADD COLUMN refund_id BIGINT COMMENT '关联的退款申请ID' AFTER refund_time;

-- 3. 验证更新
SELECT '退款申请表创建成功' AS result;
SELECT '订单表更新成功' AS result;

-- 显示更新后的订单表结构
DESCRIBE order_info;
