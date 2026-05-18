package com.bookmall.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.bookmall.entity.OrderItem;

import java.util.List;

public interface OrderItemService extends IService<OrderItem> {
    List<OrderItem> getOrderItems(Long orderId);
    void updateStatusByOrderId(Long orderId, String status);
}
