-- 统一订单状态为中文
-- 执行前请备份数据

-- 更新所有英文状态为中文
UPDATE order_info SET order_status = '待付款' WHERE order_status = 'pending';
UPDATE order_info SET order_status = '待发货' WHERE order_status = 'paid';
UPDATE order_info SET order_status = '待收货' WHERE order_status = 'shipped';
UPDATE order_info SET order_status = '已完成' WHERE order_status = 'completed';
UPDATE order_info SET order_status = '已取消' WHERE order_status = 'cancelled';
UPDATE order_info SET order_status = '已退款' WHERE order_status = 'refunded';

-- 验证更新结果
SELECT order_status, COUNT(*) as count FROM order_info GROUP BY order_status;
