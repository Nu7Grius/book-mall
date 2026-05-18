package com.bookmall.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookmall.common.Result;
import com.bookmall.entity.Order;
import com.bookmall.entity.OrderItem;
import com.bookmall.entity.RefundRequest;
import com.bookmall.service.OrderItemService;
import com.bookmall.service.OrderService;
import com.bookmall.service.RefundRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/refund")
public class RefundRequestController {

    @Autowired
    private RefundRequestService refundRequestService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderItemService orderItemService;

    @PostMapping("/apply")
    public Result applyForRefund(@RequestBody Map<String, Object> params) {
        try {
            Long orderId = Long.parseLong(params.get("orderId").toString());
            Long userId = Long.parseLong(params.get("userId").toString());
            String reason = params.get("reason").toString();
            String description = params.getOrDefault("description", "").toString();

            boolean success = refundRequestService.applyForRefund(orderId, userId, reason, description);
            if (success) {
                return Result.success("退款申请已提交");
            }
            return Result.error("提交失败");
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping("/apply-by-item")
    public Result applyRefundByItem(@RequestBody Map<String, Object> params) {
        try {
            // 验证必要参数
            if (!params.containsKey("orderId") || !params.containsKey("orderItemId")) {
                return Result.error("缺少必要参数，请刷新页面后重试");
            }

            Long orderId = Long.parseLong(params.get("orderId").toString());
            Long orderItemId = Long.parseLong(params.get("orderItemId").toString());
            Long userId = Long.parseLong(params.get("userId").toString());
            String reason = params.getOrDefault("reason", "").toString();
            String description = params.getOrDefault("description", "").toString();

            // 验证orderItemId
            if (orderItemId == null || orderItemId <= 0) {
                return Result.error("商品项ID无效，请刷新页面后重试");
            }

            boolean success = refundRequestService.applyForRefundByItem(
                    orderId, orderItemId, userId, reason, description);

            if (success) {
                return Result.success("退款申请已提交");
            }
            return Result.error("提交失败");
        } catch (NumberFormatException e) {
            return Result.error("参数格式错误，请刷新页面后重试");
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @GetMapping("/user/list")
    public Result getUserRefundList(@RequestParam Long userId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        LambdaQueryWrapper<RefundRequest> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RefundRequest::getUserId, userId)
                .orderByDesc(RefundRequest::getCreateTime)
                .orderByDesc(RefundRequest::getId);

        Page<RefundRequest> refundPage = refundRequestService.page(new Page<>(page, pageSize), wrapper);

        for (RefundRequest refund : refundPage.getRecords()) {
            Order order = orderService.getById(refund.getOrderId());
            refund.setOrder(order);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", refundPage.getRecords());
        result.put("total", refundPage.getTotal());
        result.put("page", refundPage.getCurrent());
        result.put("pageSize", refundPage.getSize());

        return Result.success(result);
    }

    @GetMapping("/merchant/list")
    public Result getMerchantRefundList(@RequestParam Long merchantId,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        LambdaQueryWrapper<RefundRequest> wrapper = new LambdaQueryWrapper<>();

        wrapper.eq(RefundRequest::getMerchantId, merchantId);

        if (status != null && !status.trim().isEmpty()) {
            wrapper.eq(RefundRequest::getRefundStatus, status);
        }

        wrapper.orderByDesc(RefundRequest::getCreateTime)
                .orderByDesc(RefundRequest::getId);

        Page<RefundRequest> refundPage = refundRequestService.page(new Page<>(page, pageSize), wrapper);

        for (RefundRequest refund : refundPage.getRecords()) {
            Order order = orderService.getById(refund.getOrderId());
            refund.setOrder(order);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", refundPage.getRecords());
        result.put("total", refundPage.getTotal());
        result.put("page", refundPage.getCurrent());
        result.put("pageSize", refundPage.getSize());

        return Result.success(result);
    }

    @PostMapping("/process")
    public Result processRefund(@RequestBody Map<String, Object> params) {
        try {
            Long refundId = Long.parseLong(params.get("refundId").toString());
            String status = params.get("status").toString();
            String merchantReply = params.getOrDefault("merchantReply", "").toString();

            boolean success = refundRequestService.processRefund(refundId, status, merchantReply);
            if (success) {
                return Result.success("处理成功");
            }
            return Result.error("处理失败");
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @GetMapping("/detail/{id}")
    public Result getRefundDetail(@PathVariable Long id) {
        RefundRequest refund = refundRequestService.getById(id);
        if (refund != null) {
            Order order = orderService.getById(refund.getOrderId());
            refund.setOrder(order);
        }
        return Result.success(refund);
    }

    @GetMapping("/order-item/{orderItemId}")
    public Result getRefundByOrderItem(@PathVariable Long orderItemId) {
        LambdaQueryWrapper<RefundRequest> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RefundRequest::getOrderItemId, orderItemId)
                .orderByDesc(RefundRequest::getCreateTime)
                .last("LIMIT 1");

        RefundRequest refund = refundRequestService.getOne(wrapper);
        if (refund != null) {
            Order order = orderService.getById(refund.getOrderId());
            refund.setOrder(order);
        }
        return Result.success(refund);
    }

    @GetMapping("/pending/{orderItemId}")
    public Result getPendingRefundByOrderItem(@PathVariable Long orderItemId) {
        LambdaQueryWrapper<RefundRequest> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RefundRequest::getOrderItemId, orderItemId)
                .eq(RefundRequest::getRefundStatus, RefundRequest.STATUS_PENDING)
                .orderByDesc(RefundRequest::getCreateTime)
                .last("LIMIT 1");

        RefundRequest refund = refundRequestService.getOne(wrapper);
        if (refund != null) {
            Order order = orderService.getById(refund.getOrderId());
            refund.setOrder(order);
        }
        return Result.success(refund);
    }

    @GetMapping("/latest/{orderItemId}")
    public Result getLatestRefundByOrderItem(@PathVariable Long orderItemId) {
        LambdaQueryWrapper<RefundRequest> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RefundRequest::getOrderItemId, orderItemId)
                .orderByDesc(RefundRequest::getCreateTime)
                .last("LIMIT 1");

        RefundRequest refund = refundRequestService.getOne(wrapper);
        if (refund != null) {
            Order order = orderService.getById(refund.getOrderId());
            refund.setOrder(order);
            OrderItem orderItem = orderItemService.getById(refund.getOrderItemId());
            refund.setOrderItem(orderItem);
        }
        return Result.success(refund);
    }
}
