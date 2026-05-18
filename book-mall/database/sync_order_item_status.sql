-- 更新订单商品表的状态，使其与订单状态保持一致
-- 这个脚本会同步所有订单项的状态

-- 1. 将所有订单项的状态更新为对应订单的状态
UPDATE order_item oi
JOIN order_info o ON oi.order_id = o.id
SET oi.status = o.order_status
WHERE oi.status IS NULL OR oi.status = '' OR oi.status = '待付款';

-- 2. 确保所有可能的状态值都存在
-- 查看当前有哪些状态
-- SELECT DISTINCT status FROM order_item;

-- 查看订单有哪些状态
-- SELECT DISTINCT order_status FROM order_info;
