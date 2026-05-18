UPDATE order_info SET order_status = '已取消' WHERE order_status IN ('cancelled', 'cancel', 'Cancel', 'CANCEL');
UPDATE order_info SET order_status = '待付款' WHERE order_status IN ('pending', 'Pending', 'PENDING');
UPDATE order_info SET order_status = '待发货' WHERE order_status IN ('paid', 'Paid', 'PAID');
UPDATE order_info SET order_status = '待收货' WHERE order_status IN ('shipped', 'Shipped', 'SHIPPED');
UPDATE order_info SET order_status = '已完成' WHERE order_status IN ('completed', 'Completed', 'COMPLETED');
UPDATE order_info SET order_status = '已退款' WHERE order_status IN ('refunded', 'Refunded', 'REFUNDED');
