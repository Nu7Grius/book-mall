-- ============================================
-- 检查并修复订单表结构
-- ============================================

USE book_mall;

-- 1. 检查订单表结构
DESCRIBE order_info;

-- 2. 检查是否有 refund_id 字段
SELECT COUNT(*) AS has_refund_id
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'book_mall'
  AND TABLE_NAME = 'order_info'
  AND COLUMN_NAME = 'refund_id';

-- 3. 如果没有 refund_id 字段，则添加
-- ALTER TABLE order_info
-- ADD COLUMN refund_id BIGINT COMMENT '关联的退款申请ID' AFTER refund_time;

-- 4. 检查是否有 refund_time 字段
SELECT COUNT(*) AS has_refund_time
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'book_mall'
  AND TABLE_NAME = 'order_info'
  AND COLUMN_NAME = 'refund_time';

-- 5. 如果没有 refund_time 字段，则添加
-- ALTER TABLE order_info
-- ADD COLUMN refund_time DATETIME COMMENT '退款时间' AFTER completion_time;

-- 6. 查看所有退款申请
SELECT * FROM refund_request;

-- 7. 查看所有状态为"退款中"的订单
SELECT id, order_number, order_status, refund_id FROM order_info WHERE order_status = '退款中';
