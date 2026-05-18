-- 为订单商品表添加商品状态字段，实现按商品维度筛选订单
ALTER TABLE order_item
ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT '待付款' COMMENT '商品状态：待付款/待发货/待收货/已完成/已取消/退款中/已退款';

-- 更新现有订单项的状态，与订单状态保持一致
UPDATE order_item oi
JOIN order_info o ON oi.order_id = o.id
SET oi.status = o.order_status
WHERE oi.status = '待付款' OR oi.status IS NULL;
