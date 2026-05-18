package com.bookmall.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("refund_request")
public class RefundRequest {

    public static final String STATUS_PENDING = "待处理";
    public static final String STATUS_APPROVED = "已通过";
    public static final String STATUS_REJECTED = "已拒绝";
    public static final String STATUS_CANCELLED = "已取消";

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Long userId;

    private Long merchantId;

    private Long orderItemId;

    private String refundReason;

    private String refundDescription;

    private BigDecimal refundAmount;

    private String refundStatus;

    private String merchantReply;

    private String originalStatus;

    private LocalDateTime processTime;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;

    @TableField(exist = false)
    private Order order;

    @TableField(exist = false)
    private OrderItem orderItem;

    @TableField(exist = false)
    private String merchantName;
}
