package com.bookmall.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;

@Data
@TableName("order_item")
public class OrderItem {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Long bookId;

    private String bookName;

    private String coverImage;

    private BigDecimal price;

    private Integer quantity;

    private BigDecimal subtotal;

    private Long merchantId;

    private String merchantName;

    private String merchantPhone;

    private String author;

    private String status = "待付款";

    private String refundStatus;

    private Long refundId;

    private String expressCompany;

    private String expressNo;

    @TableField(exist = false)
    private String refundReason;

    @TableField(exist = false)
    private String refundDescription;

    @TableField(exist = false)
    private Book book;

    @TableField(exist = false)
    private RefundRequest refundRequest;

    @TableField(exist = false)
    private Boolean commented = false;
}
