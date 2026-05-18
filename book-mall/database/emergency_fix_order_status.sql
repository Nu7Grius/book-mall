-- 紧急修复：将所有英文订单状态更新为中文
-- 执行前请备份数据

-- 显示更新前的状态
SELECT '更新前订单状态分布：' as info;
SELECT order_status, COUNT(*) as count FROM order_info GROUP BY order_status;

-- 立即更新所有英文状态为中文
UPDATE order_info SET order_status = '待付款' WHERE order_status = 'pending';
UPDATE order_info SET order_status = '待发货' WHERE order_status = 'paid';
UPDATE order_info SET order_status = '待收货' WHERE order_status = 'shipped';
UPDATE order_info SET order_status = '已完成' WHERE order_status = 'completed';
UPDATE order_info SET order_status = '已取消' WHERE order_status = 'cancelled';
UPDATE order_info SET order_status = '已退款' WHERE order_status = 'refunded';

-- 同时处理其他可能的英文变体
UPDATE order_info SET order_status = '已取消' WHERE order_status = 'cancel';
UPDATE order_info SET order_status = '已取消' WHERE order_status = 'Cancel';
UPDATE order_info SET order_status = '已取消' WHERE order_status = 'CANCEL';
UPDATE order_info SET order_status = '待付款' WHERE order_status = 'Pending';
UPDATE order_info SET order_status = '待发货' WHERE order_status = 'Paid';
UPDATE order_info SET order_status = '待收货' WHERE order_status = 'Shipped';
UPDATE order_info SET order_status = '已完成' WHERE order_status = 'Completed';

-- 显示更新后的状态
SELECT '更新后订单状态分布：' as info;
SELECT order_status, COUNT(*) as count FROM order_info GROUP BY order_status;
