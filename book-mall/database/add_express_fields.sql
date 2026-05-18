-- 添加快递信息字段的SQL迁移脚本

-- 添加快递公司字段
ALTER TABLE order_info
ADD COLUMN IF NOT EXISTS express_company VARCHAR(100) COMMENT '快递公司' AFTER shipping_time;

-- 添加快递单号字段
ALTER TABLE order_info
ADD COLUMN IF NOT EXISTS express_no VARCHAR(50) COMMENT '快递单号' AFTER express_company;

-- ============================================
-- 如果MySQL版本不支持 IF NOT EXISTS，使用以下语句
-- ============================================

-- ALTER TABLE order_info ADD COLUMN express_company VARCHAR(100) COMMENT '快递公司' AFTER shipping_time;
-- ALTER TABLE order_info ADD COLUMN express_no VARCHAR(50) COMMENT '快递单号' AFTER express_company;

-- 验证字段是否添加成功
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'book_mall' AND TABLE_NAME = 'order_info'
AND COLUMN_NAME IN ('express_company', 'express_no');

SELECT '快递信息字段添加成功！' AS result;
