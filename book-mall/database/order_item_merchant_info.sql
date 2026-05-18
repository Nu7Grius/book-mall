-- 为订单商品表添加商家信息字段
ALTER TABLE order_item
ADD COLUMN IF NOT EXISTS merchant_id BIGINT COMMENT '商家ID' AFTER subtotal,
ADD COLUMN IF NOT EXISTS merchant_name VARCHAR(50) COMMENT '商家名称' AFTER merchant_id,
ADD COLUMN IF NOT EXISTS merchant_phone VARCHAR(20) COMMENT '商家联系电话' AFTER merchant_name;
