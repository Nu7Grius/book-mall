package com.bookmall.controller;

import com.bookmall.common.Result;
import com.bookmall.common.OrderStatus;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookmall.entity.Order;
import com.bookmall.entity.OrderItem;
import com.bookmall.entity.User;
import com.bookmall.entity.Address;
import com.bookmall.entity.RefundRequest;
import com.bookmall.entity.BookComment;
import com.bookmall.service.OrderService;
import com.bookmall.service.OrderItemService;
import com.bookmall.service.UserService;
import com.bookmall.service.AddressService;
import com.bookmall.service.RefundRequestService;
import com.bookmall.service.BookCommentService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/order")
@CrossOrigin
public class OrderController {

    private static final Logger logger = LoggerFactory.getLogger(OrderController.class);

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderItemService orderItemService;

    @Autowired
    private AddressService addressService;

    @Autowired
    private UserService userService;

    @Autowired
    private RefundRequestService refundRequestService;

    @Autowired
    private BookCommentService bookCommentService;

    @GetMapping("/list")
    public Result<List<Order>> list() {
        List<Order> list = orderService.list();
        return Result.success(list);
    }

    @GetMapping("/page")
    public Result<Map<String, Object>> page(
            @RequestParam(defaultValue = "1") Long page,
            @RequestParam(defaultValue = "10") Long pageSize,
            @RequestParam(required = false) String orderNumber,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String orderStatus,
            @RequestParam(required = false) String merchantName,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(orderNumber != null && !orderNumber.trim().isEmpty(), Order::getOrderNumber, orderNumber);
        wrapper.eq(orderStatus != null && !orderStatus.trim().isEmpty(), Order::getOrderStatus, orderStatus);

        // 日期范围筛选
        if (startDate != null && !startDate.trim().isEmpty()) {
            wrapper.ge(Order::getCreateTime, startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            wrapper.le(Order::getCreateTime, endDate + " 23:59:59");
        }

        wrapper.orderByDesc(Order::getCreateTime)
                .orderByDesc(Order::getId);

        Page<Order> orderPage = orderService.page(new Page<>(page, pageSize), wrapper);

        // 查询每个订单关联的商家名称和下单人用户名
        for (Order order : orderPage.getRecords()) {
            // 查询下单人用户名（使用真实姓名）
            if (order.getUserId() != null) {
                User user = userService.getById(order.getUserId());
                if (user != null) {
                    order.setUsername(user.getRealName() != null && !user.getRealName().isEmpty()
                            ? user.getRealName()
                            : user.getUsername());
                }
            }

            // 查询商家名称
            List<OrderItem> items = orderItemService.getOrderItems(order.getId());
            if (items != null && !items.isEmpty()) {
                order.setItems(items);

                Map<Long, String> merchantMap = new java.util.LinkedHashMap<>();
                for (OrderItem item : items) {
                    if (item.getMerchantName() != null && !item.getMerchantName().trim().isEmpty()) {
                        merchantMap.put(item.getMerchantId(), item.getMerchantName());
                    }
                }
                if (!merchantMap.isEmpty()) {
                    if (merchantMap.size() == 1) {
                        order.setMerchantNameDisplay(merchantMap.values().iterator().next());
                    } else {
                        order.setMerchantNameDisplay("多个商家");
                    }
                    // 设置所有商家名称列表
                    order.setMerchantNames(new java.util.ArrayList<>(merchantMap.values()));
                } else {
                    order.setMerchantNameDisplay("平台自营");
                    order.setMerchantNames(new java.util.ArrayList<>());
                }
            } else {
                order.setMerchantNameDisplay("平台自营");
                order.setMerchantNames(new java.util.ArrayList<>());
            }
        }

        // 如果有下单人名称筛选条件，在内存中过滤
        if (username != null && !username.trim().isEmpty()) {
            final String search = username.trim();
            List<Order> filtered = new java.util.ArrayList<>();
            for (Order o : orderPage.getRecords()) {
                if (o.getUsername() != null && o.getUsername().contains(search)) {
                    filtered.add(o);
                }
            }
            Page<Order> filteredPage = new Page<>(orderPage.getCurrent(), orderPage.getSize(), filtered.size());
            filteredPage.setRecords(filtered);
            orderPage = filteredPage;
        }

        // 如果有商家名称筛选条件，在内存中过滤
        if (merchantName != null && !merchantName.trim().isEmpty()) {
            final String search = merchantName.trim();
            List<Order> filtered = new java.util.ArrayList<>();
            for (Order o : orderPage.getRecords()) {
                if (o.getMerchantNameDisplay() != null && o.getMerchantNameDisplay().contains(search)) {
                    filtered.add(o);
                }
            }
            Page<Order> filteredPage = new Page<>(orderPage.getCurrent(), orderPage.getSize(), filtered.size());
            filteredPage.setRecords(filtered);
            orderPage = filteredPage;
        }

        Map<String, Object> data = new HashMap<>();
        data.put("records", orderPage.getRecords());
        data.put("total", orderPage.getTotal());
        data.put("page", orderPage.getCurrent());
        data.put("pageSize", orderPage.getSize());
        return Result.success(data);
    }

    @GetMapping("/user/{userId}")
    public Result<Map<String, Object>> getUserOrders(
            @PathVariable Long userId,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        List<Order> allOrders = orderService.getUserOrders(userId);

        if (allOrders == null || allOrders.isEmpty()) {
            Map<String, Object> emptyData = new HashMap<>();
            emptyData.put("records", new java.util.ArrayList<>());
            emptyData.put("total", 0);
            emptyData.put("page", page);
            emptyData.put("pageSize", pageSize);
            return Result.success(emptyData);
        }

        for (Order order : allOrders) {
            List<OrderItem> items = orderItemService.getOrderItems(order.getId());
            order.setItems(items);

            // 设置用户名（现在显示realName）
            if (order.getUserId() != null) {
                User user = userService.getById(order.getUserId());
                if (user != null) {
                    order.setUsername(user.getRealName());
                }
            }

            if (order.getAddressId() != null) {
                Address address = addressService.getById(order.getAddressId());
                if (address != null) {
                    order.setReceiverName(address.getReceiverName());
                    order.setReceiverPhone(address.getReceiverPhone());
                    order.setAddress(address.getProvince() + address.getCity() + address.getDistrict()
                            + address.getDetailAddress());
                }
            }

            if (items != null && !items.isEmpty() && items.get(0).getMerchantId() != null) {
                User merchant = userService.getById(items.get(0).getMerchantId());
                if (merchant != null) {
                    order.setMerchantNameDisplay(merchant.getShopName());
                    order.setMerchantLogo(merchant.getLogo());
                }
            }
        }

        if (status != null) {
            final String filterStatus = convertStatus(status);
            allOrders.removeIf(o -> o.getOrderStatus() == null || !o.getOrderStatus().equals(filterStatus));
        }

        int total = allOrders.size();
        int fromIndex = (int) ((page - 1) * pageSize);
        int toIndex = (int) Math.min(fromIndex + pageSize, total);

        List<Order> pagedOrders;
        if (fromIndex < total) {
            pagedOrders = allOrders.subList(fromIndex, toIndex);
        } else {
            pagedOrders = new java.util.ArrayList<>();
        }

        Map<String, Object> data = new HashMap<>();
        data.put("records", pagedOrders);
        data.put("total", total);
        data.put("page", page);
        data.put("pageSize", pageSize);
        return Result.success(data);
    }

    private String convertStatus(Integer status) {
        switch (status) {
            case 0:
                return "待付款";
            case 1:
                return "待发货";
            case 2:
                return "待收货";
            case 3:
                return "已完成";
            case 4:
                return "已取消";
            case 5:
                return "退款中";
            case 6:
                return "已退款";
            default:
                return null;
        }
    }

    @GetMapping("/merchant/{merchantId}")
    public Result<List<Order>> getMerchantOrders(@PathVariable Long merchantId) {
        List<Order> list = orderService.getMerchantOrders(merchantId);
        return Result.success(list);
    }

    @GetMapping("/merchant/page")
    public Result<Map<String, Object>> getMerchantOrderPage(
            @RequestParam Long merchantId,
            @RequestParam(defaultValue = "1") Long page,
            @RequestParam(defaultValue = "10") Long pageSize,
            @RequestParam(required = false) String orderNumber,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String orderStatus,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        List<Order> allOrders = orderService.getMerchantOrders(merchantId);

        if (allOrders == null || allOrders.isEmpty()) {
            Map<String, Object> emptyData = new HashMap<>();
            emptyData.put("records", new java.util.ArrayList<>());
            emptyData.put("total", 0);
            emptyData.put("page", page);
            emptyData.put("pageSize", pageSize);
            return Result.success(emptyData);
        }

        if (orderNumber != null && !orderNumber.trim().isEmpty()) {
            final String search = orderNumber.trim();
            allOrders.removeIf(o -> o.getOrderNumber() == null || !o.getOrderNumber().contains(search));
        }

        if (username != null && !username.trim().isEmpty()) {
            final String search = username.trim();
            allOrders.removeIf(o -> o.getUsername() == null || !o.getUsername().contains(search));
        }

        if (orderStatus != null && !orderStatus.trim().isEmpty()) {
            final String status = orderStatus.trim();
            // 商家视角：使用商家订单状态进行筛选
            allOrders.removeIf(o -> !status.equals(o.getMerchantOrderStatus()));
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            final String start = startDate + " 00:00:00";
            allOrders.removeIf(o -> o.getCreateTime() == null
                    || o.getCreateTime().isBefore(java.time.LocalDateTime.parse(start.replace(" ", "T"))));
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            final String end = endDate + " 23:59:59";
            allOrders.removeIf(o -> o.getCreateTime() == null
                    || o.getCreateTime().isAfter(java.time.LocalDateTime.parse(end.replace(" ", "T"))));
        }

        int total = allOrders.size();
        int fromIndex = (int) ((page - 1) * pageSize);
        int toIndex = (int) Math.min(fromIndex + pageSize, total);

        List<Order> pagedOrders = allOrders;
        if (fromIndex < total) {
            pagedOrders = allOrders.subList(fromIndex, toIndex);
        } else {
            pagedOrders = new java.util.ArrayList<>();
        }

        Map<String, Object> data = new HashMap<>();
        data.put("records", pagedOrders);
        data.put("total", total);
        data.put("page", page);
        data.put("pageSize", pageSize);
        return Result.success(data);
    }

    @GetMapping("/{id}")
    public Result<Map<String, Object>> getById(@PathVariable Long id,
            @RequestParam(required = false) Long merchantId) {
        Map<String, Object> result = new HashMap<>();
        Order order = orderService.getById(id);

        if (order != null) {
            // 查询下单人用户名（使用真实姓名）
            if (order.getUserId() != null) {
                User user = userService.getById(order.getUserId());
                if (user != null) {
                    order.setUsername(user.getRealName());
                }
            }

            // 查询收货地址信息
            if (order.getAddressId() != null) {
                Address address = addressService.getById(order.getAddressId());
                if (address != null) {
                    order.setAddress(
                            address.getProvince() + address.getCity() + address.getDistrict()
                                    + address.getDetailAddress());
                    order.setReceiverName(address.getReceiverName());
                    order.setReceiverPhone(address.getReceiverPhone());
                }
            }

            // 添加订单商品列表（只返回该商家的商品）
            List<OrderItem> items = orderItemService.getOrderItems(id);
            if (merchantId != null) {
                items = items.stream()
                        .filter(item -> merchantId.equals(item.getMerchantId()))
                        .collect(Collectors.toList());
            }

            for (OrderItem item : items) {
                LambdaQueryWrapper<RefundRequest> refundWrapper = new LambdaQueryWrapper<>();
                refundWrapper.eq(RefundRequest::getOrderItemId, item.getId())
                        .orderByDesc(RefundRequest::getCreateTime)
                        .last("LIMIT 1");
                RefundRequest refundRequest = refundRequestService.getOne(refundWrapper);
                if (refundRequest != null) {
                    item.setRefundReason(refundRequest.getRefundReason());
                    item.setRefundDescription(refundRequest.getRefundDescription());
                    item.setRefundStatus(refundRequest.getRefundStatus());
                    item.setRefundId(refundRequest.getId());
                }

                LambdaQueryWrapper<BookComment> commentWrapper = new LambdaQueryWrapper<>();
                commentWrapper.eq(BookComment::getBookId, item.getBookId())
                        .eq(BookComment::getOrderId, id)
                        .eq(BookComment::getUserId, order.getUserId())
                        .eq(BookComment::getStatus, 1)
                        .last("LIMIT 1");
                BookComment comment = bookCommentService.getOne(commentWrapper);
                if (comment != null) {
                    item.setCommented(true);
                }
            }

            // 根据商品状态重新计算展示状态（不写库）
            String calculatedStatus = orderService.calculateOrderStatusFromItems(items);
            order.setOrderStatus(calculatedStatus);

            StringBuilder refundReasonBuilder = new StringBuilder();
            StringBuilder refundDescBuilder = new StringBuilder();
            int reasonIndex = 1;
            int descIndex = 1;
            for (int i = 0; i < items.size(); i++) {
                OrderItem item = items.get(i);
                if (item.getRefundReason() != null && !item.getRefundReason().isEmpty()) {
                    if (refundReasonBuilder.length() > 0) {
                        refundReasonBuilder.append("\n");
                    }
                    String reasonText = convertReasonCodeToText(item.getRefundReason());
                    refundReasonBuilder.append(reasonIndex++).append(". ")
                            .append(item.getBookName())
                            .append(": ")
                            .append(reasonText);
                }
                if (item.getRefundDescription() != null && !item.getRefundDescription().isEmpty()) {
                    if (refundDescBuilder.length() > 0) {
                        refundDescBuilder.append("\n");
                    }
                    refundDescBuilder.append(descIndex++).append(". ")
                            .append(item.getBookName())
                            .append(": ")
                            .append(item.getRefundDescription());
                }
            }
            if (refundReasonBuilder.length() > 0) {
                order.setRefundReason("\n" + refundReasonBuilder.toString());
            }
            if (refundDescBuilder.length() > 0) {
                order.setRefundDescription("\n" + refundDescBuilder.toString());
            }

            result.put("items", items);

            // 计算商家视角的订单状态
            if (merchantId != null) {
                String merchantOrderStatus = orderService.calculateMerchantOrderStatus(items);
                order.setMerchantOrderStatus(merchantOrderStatus);
            }
        }

        result.put("order", order);

        if (order != null && order.getRefundId() != null) {
            RefundRequest refund = refundRequestService.getById(order.getRefundId());
            result.put("refund", refund);
        }

        return Result.success(result);
    }

    private String convertReasonCodeToText(String reasonCode) {
        if (reasonCode == null || reasonCode.isEmpty()) {
            return reasonCode;
        }
        switch (reasonCode) {
            case "1":
                return "商品损坏";
            case "2":
                return "商品错发";
            case "3":
                return "不想买了";
            case "4":
                return "其他";
            default:
                return reasonCode;
        }
    }

    @GetMapping("/items/{orderId}")
    public Result<List<OrderItem>> getOrderItems(@PathVariable Long orderId) {
        List<OrderItem> items = orderItemService.getOrderItems(orderId);
        Order order = orderService.getById(orderId);
        if (order != null) {
            for (OrderItem item : items) {
                LambdaQueryWrapper<BookComment> commentWrapper = new LambdaQueryWrapper<>();
                commentWrapper.eq(BookComment::getBookId, item.getBookId())
                        .eq(BookComment::getOrderId, orderId)
                        .eq(BookComment::getUserId, order.getUserId())
                        .eq(BookComment::getStatus, 1)
                        .last("LIMIT 1");
                BookComment comment = bookCommentService.getOne(commentWrapper);
                if (comment != null) {
                    item.setCommented(true);
                }
            }
        }
        return Result.success(items);
    }

    @PostMapping("/create")
    public Result<Order> createOrder(@RequestBody Order order) {
        try {
            Order createdOrder = orderService.createOrder(order);
            return Result.success(createdOrder);
        } catch (Exception e) {
            return Result.error(400, e.getMessage());
        }
    }

    @PutMapping("/status")
    public Result<?> updateStatus(@RequestBody Order order) {
        Order existOrder = new Order();
        existOrder.setId(order.getId());
        existOrder.setOrderStatus(order.getOrderStatus());
        existOrder.setUpdateTime(null);
        orderService.updateById(existOrder);
        return Result.success("状态更新成功");
    }

    @PutMapping("/pay")
    public Result<?> payOrder(@RequestBody Map<String, Object> params) {
        try {
            Long orderId = Long.valueOf(params.get("id").toString());
            Order order = orderService.getById(orderId);
            if (order == null) {
                return Result.error(404, "订单不存在");
            }

            // 更新所有商品状态为待发货
            orderItemService.updateStatusByOrderId(orderId, OrderStatus.PENDING_SHIP);

            // 更新订单支付信息
            Order updateOrder = new Order();
            updateOrder.setId(orderId);
            updateOrder.setPaymentTime(LocalDateTime.now());
            if (params.containsKey("paymentMethod") && params.get("paymentMethod") != null) {
                updateOrder.setPaymentMethod(params.get("paymentMethod").toString());
            } else {
                updateOrder.setPaymentMethod("在线支付");
            }
            orderService.updateById(updateOrder);

            // 重新计算订单状态（所有商品都是待发货，所以订单状态应该是待发货）
            orderService.updateOrderStatusFromItems(orderId);

            return Result.success("支付成功");
        } catch (Exception e) {
            return Result.error(500, "支付失败: " + e.getMessage());
        }
    }

    @PutMapping("/cancel")
    public Result<?> cancelOrder(@RequestBody Map<String, Object> params) {
        try {
            Long orderId = Long.valueOf(params.get("id").toString());
            Order order = orderService.getById(orderId);
            if (order == null) {
                return Result.error(404, "订单不存在");
            }

            // 取消订单时，需要检查订单状态
            // 只有"待付款"状态的订单才能被用户取消
            // 其他状态需要通过退款流程处理
            if (!OrderStatus.PENDING_PAYMENT.equals(order.getOrderStatus())) {
                return Result.error(400, "该订单状态不支持取消，请申请退款");
            }

            // 更新所有商品状态为已取消
            orderItemService.updateStatusByOrderId(orderId, OrderStatus.CANCELLED);

            // 更新订单状态
            orderService.updateOrderStatus(orderId, OrderStatus.CANCELLED);

            return Result.success("订单已取消");
        } catch (Exception e) {
            return Result.error(500, "取消订单失败: " + e.getMessage());
        }
    }

    @PutMapping("/confirm")
    public Result<?> confirmReceive(@RequestBody Map<String, Object> params) {
        try {
            Long orderId = Long.valueOf(params.get("id").toString());
            Order order = orderService.getById(orderId);
            if (order == null) {
                return Result.error(404, "订单不存在");
            }

            if (params.containsKey("orderItemId") && params.get("orderItemId") != null) {
                Long orderItemId = Long.valueOf(params.get("orderItemId").toString());
                OrderItem orderItem = orderItemService.getById(orderItemId);
                if (orderItem != null) {
                    orderItem.setStatus(OrderStatus.PENDING_REVIEW);
                    orderItemService.updateById(orderItem);
                }
            } else {
                List<OrderItem> orderItems = orderItemService.getOrderItems(orderId);
                for (OrderItem item : orderItems) {
                    if (OrderStatus.SHIPPING.equals(item.getStatus())) {
                        item.setStatus(OrderStatus.PENDING_REVIEW);
                        orderItemService.updateById(item);
                    }
                }
            }

            orderService.updateOrderStatusFromItems(orderId);

            // 更新确认收货时间
            Order updateOrder = new Order();
            updateOrder.setId(orderId);
            updateOrder.setCompletionTime(LocalDateTime.now());
            orderService.updateById(updateOrder);

            return Result.success("确认收货成功");
        } catch (Exception e) {
            return Result.error(500, "确认收货失败: " + e.getMessage());
        }
    }

    @PutMapping("/{orderId}/complete")
    public Result<?> completeOrder(@PathVariable Long orderId) {
        try {
            Order order = orderService.getById(orderId);
            if (order == null) {
                return Result.error(404, "订单不存在");
            }

            // 获取该订单的所有商品
            List<OrderItem> orderItems = orderItemService.getOrderItems(orderId);

            // 更新所有待评价的商品状态为已完成
            for (OrderItem item : orderItems) {
                if ("待评价".equals(item.getStatus())) {
                    item.setStatus(OrderStatus.COMPLETED);
                    orderItemService.updateById(item);
                }
            }

            // 由商品状态聚合计算订单状态
            orderService.updateOrderStatusFromItems(orderId);

            return Result.success("订单已完成");
        } catch (Exception e) {
            logger.error("更新订单状态失败: " + e.getMessage(), e);
            return Result.error(500, "订单完成失败: " + e.getMessage());
        }
    }

    @PutMapping("/ship")
    public Result<?> shipOrder(@RequestBody Map<String, Object> params) {
        try {
            Long orderId = Long.valueOf(params.get("id").toString());
            Order order = orderService.getById(orderId);
            if (order == null) {
                return Result.error(404, "订单不存在");
            }

            String expressCompany = null;
            String expressNo = null;
            String remark = null;
            if (params.containsKey("expressCompany") && params.get("expressCompany") != null) {
                expressCompany = params.get("expressCompany").toString();
            }
            if (params.containsKey("expressNo") && params.get("expressNo") != null) {
                expressNo = params.get("expressNo").toString();
            }
            if (params.containsKey("remark") && params.get("remark") != null) {
                remark = params.get("remark").toString();
            }

            Order updateOrder = new Order();
            updateOrder.setId(orderId);
            updateOrder.setShippingTime(LocalDateTime.now());
            updateOrder.setRemindShip(0);
            if (expressCompany != null) {
                updateOrder.setExpressCompany(expressCompany);
            }
            if (expressNo != null) {
                updateOrder.setExpressNo(expressNo);
            }
            if (remark != null) {
                updateOrder.setRemark(remark);
            }

            orderService.updateById(updateOrder);

            if (params.containsKey("orderItemId") && params.get("orderItemId") != null) {
                Long orderItemId = Long.valueOf(params.get("orderItemId").toString());
                OrderItem orderItem = orderItemService.getById(orderItemId);
                if (orderItem != null) {
                    orderItem.setStatus(OrderStatus.SHIPPING);
                    if (expressCompany != null) {
                        orderItem.setExpressCompany(expressCompany);
                    }
                    if (expressNo != null) {
                        orderItem.setExpressNo(expressNo);
                    }
                    orderItemService.updateById(orderItem);
                }
            } else if (params.containsKey("merchantId") && params.get("merchantId") != null) {
                Long merchantId = Long.valueOf(params.get("merchantId").toString());
                List<OrderItem> orderItems = orderItemService.getOrderItems(orderId);
                for (OrderItem item : orderItems) {
                    if (OrderStatus.PENDING_SHIP.equals(item.getStatus()) &&
                            merchantId.equals(item.getMerchantId())) {
                        item.setStatus(OrderStatus.SHIPPING);
                        if (expressCompany != null) {
                            item.setExpressCompany(expressCompany);
                        }
                        if (expressNo != null) {
                            item.setExpressNo(expressNo);
                        }
                        orderItemService.updateById(item);
                    }
                }
            } else {
                List<OrderItem> orderItems = orderItemService.getOrderItems(orderId);
                for (OrderItem item : orderItems) {
                    if (OrderStatus.PENDING_SHIP.equals(item.getStatus())) {
                        item.setStatus(OrderStatus.SHIPPING);
                        if (expressCompany != null) {
                            item.setExpressCompany(expressCompany);
                        }
                        if (expressNo != null) {
                            item.setExpressNo(expressNo);
                        }
                        orderItemService.updateById(item);
                    }
                }
            }

            orderService.updateOrderStatusFromItems(orderId);

            return Result.success("发货成功");
        } catch (Exception e) {
            return Result.error(500, "发货失败: " + e.getMessage());
        }
    }

    @PutMapping("/remind-ship")
    public Result<?> remindShip(@RequestBody Map<String, Object> params) {
        try {
            Long orderId = Long.valueOf(params.get("id").toString());
            Order order = orderService.getById(orderId);
            if (order == null) {
                return Result.error(404, "订单不存在");
            }

            // 标记为已催促
            Order updateOrder = new Order();
            updateOrder.setId(orderId);
            updateOrder.setRemindShip(1);
            updateOrder.setRemindTime(LocalDateTime.now());
            orderService.updateById(updateOrder);

            return Result.success("已提醒商家发货");
        } catch (Exception e) {
            return Result.error(500, "提醒发货失败: " + e.getMessage());
        }
    }

    @PostMapping("/force-ship-item")
    public Result<?> forceShipItem(@RequestBody Map<String, Object> params) {
        try {
            Long orderId = Long.valueOf(params.get("orderId").toString());
            Long orderItemId = Long.valueOf(params.get("orderItemId").toString());

            Order order = orderService.getById(orderId);
            if (order == null) {
                return Result.error(404, "订单不存在");
            }

            OrderItem orderItem = orderItemService.getById(orderItemId);
            if (orderItem == null) {
                return Result.error(404, "订单商品不存在");
            }

            if (!"退款中".equals(orderItem.getStatus())) {
                return Result.error(400, "只有退款中的商品才能强制发货");
            }

            // 1. 查询并取消退款申请
            LambdaQueryWrapper<RefundRequest> refundWrapper = new LambdaQueryWrapper<>();
            refundWrapper.eq(RefundRequest::getOrderItemId, orderItemId)
                    .eq(RefundRequest::getRefundStatus, RefundRequest.STATUS_PENDING);
            RefundRequest refundRequest = refundRequestService.getOne(refundWrapper);
            if (refundRequest != null) {
                // 将退款申请状态设置为"已取消"
                refundRequest.setRefundStatus(RefundRequest.STATUS_CANCELLED);
                refundRequest.setMerchantReply("商家选择强制发货，已取消退款申请");
                refundRequest.setProcessTime(LocalDateTime.now());
                refundRequestService.updateById(refundRequest);
            }

            // 2. 将商品状态从"退款中"改为"待收货"，并保存物流信息
            orderItem.setStatus(OrderStatus.SHIPPING);
            orderItem.setRefundStatus(null);

            // 保存物流信息到商品
            // 如果前端传递了新的快递信息，使用新的；否则保留原有的
            String expressCompany = null;
            String expressNo = null;
            if (params.containsKey("expressCompany") && params.get("expressCompany") != null) {
                expressCompany = params.get("expressCompany").toString();
                orderItem.setExpressCompany(expressCompany);
            }
            if (params.containsKey("expressNo") && params.get("expressNo") != null) {
                expressNo = params.get("expressNo").toString();
                orderItem.setExpressNo(expressNo);
            }
            // 如果没有传递新的快递信息，保留原有的物流信息
            if (expressCompany == null && orderItem.getExpressCompany() != null) {
                expressCompany = orderItem.getExpressCompany();
            }
            if (expressNo == null && orderItem.getExpressNo() != null) {
                expressNo = orderItem.getExpressNo();
            }

            orderItemService.updateById(orderItem);

            // 3. 更新订单发货信息
            Order updateOrder = new Order();
            updateOrder.setId(orderId);
            updateOrder.setShippingTime(LocalDateTime.now());

            // 保存物流信息到订单
            if (params.containsKey("expressCompany") && params.get("expressCompany") != null) {
                updateOrder.setExpressCompany(params.get("expressCompany").toString());
            }
            if (params.containsKey("expressNo") && params.get("expressNo") != null) {
                updateOrder.setExpressNo(params.get("expressNo").toString());
            }
            if (params.containsKey("remark") && params.get("remark") != null) {
                updateOrder.setRemark(params.get("remark").toString());
            }

            orderService.updateById(updateOrder);

            // 4. 重新计算订单状态
            orderService.updateOrderStatusFromItems(orderId);

            return Result.success("强制发货成功");
        } catch (Exception e) {
            return Result.error(500, "强制发货失败: " + e.getMessage());
        }
    }

    @PutMapping("/refund")
    public Result<?> refundOrder(@RequestBody Map<String, Object> params) {
        try {
            Long orderId = Long.valueOf(params.get("id").toString());
            orderService.updateOrderStatus(orderId, OrderStatus.REFUNDED);
            return Result.success("退款成功");
        } catch (Exception e) {
            return Result.error(500, "退款失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        orderService.removeById(id);
        return Result.success("删除成功");
    }
}
