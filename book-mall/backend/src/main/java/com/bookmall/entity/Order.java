package com.bookmall.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("order_info")
public class Order {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String orderNumber;

    private Long userId;

    private Long addressId;

    private BigDecimal totalAmount;

    private String orderStatus;

    private String paymentMethod;

    private LocalDateTime paymentTime;

    private LocalDateTime shippingTime;

    /**
     * 快递公司
     */
    private String expressCompany;

    /**
     * 快递单号
     */
    private String expressNo;

    private LocalDateTime completionTime;

    private LocalDateTime refundTime;

    private Long refundId;

    private String remark;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;

    @TableField(exist = false)
    private List<OrderItem> items;

    @TableField(exist = false)
    private List<OrderItem> orderItems;

    /**
     * 商家名称（仅用于前端展示，非数据库字段）
     * 单商家时显示商家名，多商家时显示"多商家(N)"
     */
    @TableField(exist = false)
    private String merchantNameDisplay;

    /**
     * 所有商家名称列表（仅用于前端展示，非数据库字段）
     * 用于多商家订单时展示所有商家名称
     */
    @TableField(exist = false)
    private List<String> merchantNames;

    /**
     * 商家头像（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String merchantLogo;

    /**
     * 下单人用户名（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String username;

    /**
     * 收货地址（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String address;

    /**
     * 收货人姓名（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String receiverName;

    /**
     * 收货人电话（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String receiverPhone;

    /**
     * 退款原因拼接（仅用于前端展示，非数据库字段）
     * 格式：商品1: 退款原因1; 商品2: 退款原因2
     */
    @TableField(exist = false)
    private String refundReason;

    /**
     * 退款详细说明拼接（仅用于前端展示，非数据库字段）
     * 格式：商品1: 详细说明1; 商品2: 详细说明2
     */
    @TableField(exist = false)
    private String refundDescription;

    /**
     * 商家视角的订单状态（仅用于前端展示，非数据库字段）
     * 根据该商家自己的商品状态计算得出
     */
    @TableField(exist = false)
    private String merchantOrderStatus;

    /**
     * 是否催促发货：0否，1是
     */
    private Integer remindShip;

    /**
     * 催促发货时间
     */
    private LocalDateTime remindTime;

    /**
     * 要删除的购物车商品ID列表（仅用于订单创建时，非数据库字段）
     */
    @TableField(exist = false)
    private List<Long> cartIds;
}
