-- 统一订单状态为中文
-- 此脚本将所有英文订单状态更新为中文

-- 检查当前所有订单状态
SELECT order_status, COUNT(*) as count FROM order_info GROUP BY order_status;

-- 更新所有英文状态为中文
UPDATE order_info SET order_status = '待付款' WHERE order_status = 'pending';
UPDATE order_info SET order_status = '待发货' WHERE order_status = 'paid';
UPDATE order_info SET order_status = '待收货' WHERE order_status = 'shipped';
UPDATE order_info SET order_status = '已完成' WHERE order_status = 'completed';
UPDATE order_info SET order_status = '已取消' WHERE order_status = 'cancelled';
UPDATE order_info SET order_status = '已退款' WHERE order_status = 'refunded';

-- 同时更新退款申请表中的状态
UPDATE refund_request SET refund_status = 'pending' WHERE refund_status = 'pending';
UPDATE refund_request SET refund_status = 'approved' WHERE refund_status = 'approved';
UPDATE refund_request SET refund_status = 'rejected' WHERE refund_status = 'rejected';

-- 再次检查更新后的状态
SELECT order_status, COUNT(*) as count FROM order_info GROUP BY order_status;
