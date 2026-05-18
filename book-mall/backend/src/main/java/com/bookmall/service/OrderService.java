package com.bookmall.service;

import com.bookmall.entity.Order;
import com.bookmall.entity.OrderItem;
import com.baomidou.mybatisplus.extension.service.IService;
import java.util.List;

public interface OrderService extends IService<Order> {
  List<Order> getUserOrders(Long userId);

  List<Order> getMerchantOrders(Long merchantId);

  Order createOrder(Order order) throws Exception;

  void updateOrderStatus(Long orderId, String status) throws Exception;

  void updateOrderStatusFromItems(Long orderId);

  boolean validateStatusTransition(String currentStatus, String targetStatus);

  String calculateMerchantOrderStatus(List<OrderItem> merchantItems);

  String calculateOrderStatusFromItems(List<OrderItem> items);
}
