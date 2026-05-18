-- 为 order_item 表添加快递信息字段
-- 这个脚本用于添加商品级别的物流信息

-- 添加 express_company 列（快递公司）
ALTER TABLE order_item ADD COLUMN express_company VARCHAR(100) DEFAULT NULL COMMENT '快递公司';

-- 添加 express_no 列（快递单号）
ALTER TABLE order_item ADD COLUMN express_no VARCHAR(100) DEFAULT NULL COMMENT '快递单号';

-- 添加索引以提高查询性能（可选）
-- ALTER TABLE order_item ADD INDEX idx_express_no (express_no);
