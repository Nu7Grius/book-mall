package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookmall.entity.Order;
import com.bookmall.entity.OrderItem;
import com.bookmall.entity.RefundRequest;
import com.bookmall.entity.User;
import com.bookmall.mapper.RefundRequestMapper;
import com.bookmall.service.OrderItemService;
import com.bookmall.service.OrderService;
import com.bookmall.service.RefundRequestService;
import com.bookmall.service.UserService;
import com.bookmall.common.OrderStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class RefundRequestServiceImpl extends ServiceImpl<RefundRequestMapper, RefundRequest>
        implements RefundRequestService {

    private static final Logger logger = LoggerFactory.getLogger(RefundRequestServiceImpl.class);

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderItemService orderItemService;

    @Autowired
    private UserService userService;

    @Override
    @Transactional
    public boolean applyForRefund(Long orderId, Long userId, String reason, String description) {
        Order order = orderService.getById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }

        if (!"待发货".equals(order.getOrderStatus()) && !"待收货".equals(order.getOrderStatus())) {
            throw new RuntimeException("当前订单状态不允许申请退款");
        }

        RefundRequest refundRequest = new RefundRequest();
        refundRequest.setOrderId(orderId);
        refundRequest.setUserId(userId);
        refundRequest.setRefundReason(reason);
        refundRequest.setRefundDescription(description);
        refundRequest.setRefundAmount(order.getTotalAmount());
        refundRequest.setRefundStatus(RefundRequest.STATUS_PENDING);
        refundRequest.setOriginalStatus(order.getOrderStatus());

        boolean saveResult = this.save(refundRequest);

        // 更新所有商品状态为"退款中"
        LambdaQueryWrapper<OrderItem> updateWrapper = new LambdaQueryWrapper<>();
        updateWrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> itemsToUpdate = orderItemService.list(updateWrapper);
        for (OrderItem item : itemsToUpdate) {
            item.setStatus(OrderStatus.REFUNDING);
            item.setRefundStatus(RefundRequest.STATUS_PENDING);
            orderItemService.updateById(item);
        }

        // 记录退款申请ID到订单
        order.setRefundId(refundRequest.getId());
        orderService.updateById(order);

        // 通过聚合方法计算订单状态
        orderService.updateOrderStatusFromItems(orderId);

        return true;
    }

    @Override
    @Transactional
    public boolean applyForRefundByItem(Long orderId, Long orderItemId, Long userId, String reason,
            String description) {
        Order order = orderService.getById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }

        OrderItem orderItem = orderItemService.getById(orderItemId);
        if (orderItem == null) {
            throw new RuntimeException("商品项不存在");
        }

        if (!orderId.equals(orderItem.getOrderId())) {
            throw new RuntimeException("商品项与订单不匹配");
        }

        // 检查该商品项的状态是否允许申请退款
        // 只要商品状态是"待发货"或"待收货"，就可以申请退款
        String itemStatus = orderItem.getStatus();
        if ("待发货".equals(itemStatus) || "待收货".equals(itemStatus)) {
        } else if ("退款中".equals(itemStatus)) {
            LambdaQueryWrapper<RefundRequest> statusCheckWrapper = new LambdaQueryWrapper<>();
            statusCheckWrapper.eq(RefundRequest::getOrderItemId, orderItemId)
                    .eq(RefundRequest::getRefundStatus, RefundRequest.STATUS_PENDING);
            RefundRequest pendingRequest = this.getOne(statusCheckWrapper);
            if (pendingRequest != null) {
                throw new RuntimeException("该商品已有待处理的退款申请");
            }
        } else {
            throw new RuntimeException("该商品当前状态不允许申请退款");
        }

        LambdaQueryWrapper<RefundRequest> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RefundRequest::getOrderItemId, orderItemId)
                .eq(RefundRequest::getRefundStatus, RefundRequest.STATUS_PENDING);
        RefundRequest existingRequest = this.getOne(wrapper);
        if (existingRequest != null) {
            throw new RuntimeException("该商品已有待处理的退款申请");
        }

        RefundRequest refundRequest = new RefundRequest();
        refundRequest.setOrderId(orderId);
        refundRequest.setUserId(userId);
        refundRequest.setOrderItemId(orderItemId);
        refundRequest.setMerchantId(orderItem.getMerchantId());
        refundRequest.setMerchantName(orderItem.getMerchantName());
        refundRequest.setRefundReason(reason);
        refundRequest.setRefundDescription(description);
        refundRequest.setRefundAmount(orderItem.getSubtotal());
        refundRequest.setRefundStatus(RefundRequest.STATUS_PENDING);
        refundRequest.setOriginalStatus(order.getOrderStatus());

        this.save(refundRequest);

        // 更新该商品项的状态为"退款中"，退款状态为"待处理"
        orderItem.setStatus(OrderStatus.REFUNDING);
        orderItem.setRefundStatus(RefundRequest.STATUS_PENDING);
        orderItemService.updateById(orderItem);

        // 记录退款申请ID到订单
        order.setRefundId(refundRequest.getId());
        orderService.updateById(order);

        // 通过聚合方法计算订单状态
        orderService.updateOrderStatusFromItems(orderId);

        return true;
    }

    @Override
    @Transactional
    public boolean processRefund(Long refundId, String status, String merchantReply) {
        RefundRequest refundRequest = this.getById(refundId);
        if (refundRequest == null) {
            throw new RuntimeException("退款申请不存在");
        }

        if ("approved".equals(status)) {
            status = RefundRequest.STATUS_APPROVED;
        } else if ("rejected".equals(status)) {
            status = RefundRequest.STATUS_REJECTED;
        }

        if (!RefundRequest.STATUS_PENDING.equals(refundRequest.getRefundStatus())) {
            throw new RuntimeException("该退款申请已处理");
        }

        Long orderId = refundRequest.getOrderId();
        Long orderItemId = refundRequest.getOrderItemId();

        Order order = orderService.getById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }

        refundRequest.setRefundStatus(status);
        refundRequest.setMerchantReply(merchantReply != null ? merchantReply : "");
        refundRequest.setProcessTime(LocalDateTime.now());

        if (RefundRequest.STATUS_APPROVED.equals(status)) {
            if (orderItemId != null) {
                OrderItem orderItem = orderItemService.getById(orderItemId);
                if (orderItem != null) {
                    orderItem.setStatus(OrderStatus.REFUNDED);
                    orderItem.setRefundStatus(RefundRequest.STATUS_APPROVED);
                    orderItemService.updateById(orderItem);
                }
            } else {
                LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(OrderItem::getOrderId, orderId);
                List<OrderItem> orderItems = orderItemService.list(wrapper);
                for (OrderItem item : orderItems) {
                    item.setStatus(OrderStatus.REFUNDED);
                    item.setRefundStatus(RefundRequest.STATUS_APPROVED);
                    orderItemService.updateById(item);
                }
            }
        } else if (RefundRequest.STATUS_REJECTED.equals(status)) {
            if (orderItemId != null) {
                OrderItem orderItem = orderItemService.getById(orderItemId);
                if (orderItem != null) {
                    orderItem.setRefundStatus(RefundRequest.STATUS_REJECTED);
                    orderItem.setStatus(OrderStatus.REFUNDING);
                    orderItemService.updateById(orderItem);
                }
            } else {
                LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(OrderItem::getOrderId, orderId);
                List<OrderItem> orderItems = orderItemService.list(wrapper);
                for (OrderItem item : orderItems) {
                    item.setRefundStatus(RefundRequest.STATUS_REJECTED);
                    item.setStatus(OrderStatus.REFUNDING);
                    orderItemService.updateById(item);
                }
            }
        }

        this.updateById(refundRequest);

        orderService.updateOrderStatusFromItems(orderId);

        return true;
    }
}
