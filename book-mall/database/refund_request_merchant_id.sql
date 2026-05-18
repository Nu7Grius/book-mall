-- 为退款申请表添加商家ID和订单项ID字段，支持多商家退款
-- 时间: 2026-05-09
-- 说明: 当一个订单包含多个商家的商品时，用户可以针对每个商家的商品单独申请退款

-- 添加商家ID字段
ALTER TABLE refund_request
ADD COLUMN IF NOT EXISTS merchant_id BIGINT COMMENT '商家ID，对应订单项所属商家' AFTER user_id;

-- 添加订单项ID字段
ALTER TABLE refund_request
ADD COLUMN IF NOT EXISTS order_item_id BIGINT COMMENT '订单项ID，对应退款商品' AFTER merchant_id;

-- 添加商家名称字段（方便展示）
ALTER TABLE refund_request
ADD COLUMN IF NOT EXISTS merchant_name VARCHAR(100) COMMENT '商家名称' AFTER order_item_id;

-- 创建索引以提高按商家查询的效率
CREATE INDEX IF NOT EXISTS idx_refund_merchant_id ON refund_request(merchant_id);
CREATE INDEX IF NOT EXISTS idx_refund_order_item_id ON refund_request(order_item_id);

-- 添加备注说明
-- 1. merchant_id: 用于区分不同商家的退款申请，方便商家端筛选只属于自己的退款请求
-- 2. order_item_id: 用于标识具体哪个商品需要退款，退款金额以该订单项的小计为准
-- 3. merchant_name: 冗余字段，方便前端展示商家名称，避免额外查询
