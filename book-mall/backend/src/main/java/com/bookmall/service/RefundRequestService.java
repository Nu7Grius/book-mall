package com.bookmall.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.bookmall.entity.RefundRequest;

public interface RefundRequestService extends IService<RefundRequest> {

    boolean applyForRefund(Long orderId, Long userId, String reason, String description);

    boolean applyForRefundByItem(Long orderId, Long userId, Long orderItemId, String reason, String description);

    boolean processRefund(Long refundId, String status, String merchantReply);
}
