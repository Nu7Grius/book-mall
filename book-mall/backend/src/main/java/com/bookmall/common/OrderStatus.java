package com.bookmall.common;

public class OrderStatus {

    public static final String PENDING_PAYMENT = "待付款";
    public static final String PENDING_SHIP = "待发货";
    public static final String SHIPPING = "待收货";
    public static final String PENDING_REVIEW = "待评价";
    public static final String COMPLETED = "已完成";
    public static final String CANCELLED = "已取消";
    public static final String REFUNDING = "退款中";
    public static final String REFUNDED = "已退款";

    public static int getPriority(String status) {
        if (status == null) {
            return 0;
        }
        switch (status) {
            case REFUNDING:
                return 100;
            case PENDING_SHIP:
                return 80;
            case SHIPPING:
                return 60;
            case PENDING_REVIEW:
                return 50;
            case COMPLETED:
                return 40;
            case REFUNDED:
                return 30;
            case CANCELLED:
                return 20;
            case PENDING_PAYMENT:
                return 10;
            default:
                return 0;
        }
    }

    public static boolean isValidOrderStatus(String status) {
        return PENDING_PAYMENT.equals(status) ||
                PENDING_SHIP.equals(status) ||
                SHIPPING.equals(status) ||
                PENDING_REVIEW.equals(status) ||
                COMPLETED.equals(status) ||
                CANCELLED.equals(status) ||
                REFUNDING.equals(status) ||
                REFUNDED.equals(status);
    }

    public static boolean isFinalStatus(String status) {
        return COMPLETED.equals(status) ||
                CANCELLED.equals(status) ||
                REFUNDED.equals(status);
    }
}
