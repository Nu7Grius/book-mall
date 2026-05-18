package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookmall.entity.Order;
import com.bookmall.entity.OrderItem;
import com.bookmall.entity.Book;
import com.bookmall.entity.User;
import com.bookmall.entity.Address;
import com.bookmall.entity.RefundRequest;
import com.bookmall.entity.Cart;
import com.bookmall.mapper.OrderMapper;
import com.bookmall.mapper.RefundRequestMapper;
import com.bookmall.service.OrderService;
import com.bookmall.service.OrderItemService;
import com.bookmall.service.BookService;
import com.bookmall.service.UserService;
import com.bookmall.service.AddressService;
import com.bookmall.service.CartService;
import com.bookmall.common.OrderStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class OrderServiceImpl extends ServiceImpl<OrderMapper, Order> implements OrderService {

  private static final Logger logger = LoggerFactory.getLogger(OrderServiceImpl.class);

  @Autowired
  private OrderItemService orderItemService;

  @Autowired
  private BookService bookService;

  @Autowired
  private UserService userService;

  @Autowired
  private AddressService addressService;

  @Autowired
  private RefundRequestMapper refundRequestMapper;

  @Autowired
  private CartService cartService;

  /**
   * 计算商家视角的订单状态
   * 根据该商家自己的商品状态来计算
   *
   * @param merchantItems 商家自己的商品项列表
   * @return 商家视角的订单状态
   */
  @Override
  public String calculateMerchantOrderStatus(List<OrderItem> merchantItems) {
    if (merchantItems == null || merchantItems.isEmpty()) {
      return "未知";
    }

    int totalItems = merchantItems.size();
    int pendingPaymentCount = 0;
    int pendingShipCount = 0;
    int shippingCount = 0;
    int pendingReviewCount = 0;
    int completedCount = 0;
    int refundedCount = 0;
    int cancelledCount = 0;
    boolean hasRefunding = false;

    for (OrderItem item : merchantItems) {
      String status = item.getStatus();
      switch (status) {
        case "待付款":
          pendingPaymentCount++;
          break;
        case "待发货":
          pendingShipCount++;
          break;
        case "待收货":
          shippingCount++;
          break;
        case "待评价":
          pendingReviewCount++;
          break;
        case "已完成":
          completedCount++;
          break;
        case "已退款":
          refundedCount++;
          break;
        case "已取消":
          cancelledCount++;
          break;
        case "退款中":
          hasRefunding = true;
          break;
      }
    }

    // 商家视角的状态判断逻辑：
    // 1. 如果有商品在退款中，商家看到的就是"退款中"
    // 2. 如果所有商品都是已退款，商家看到的就是"已退款"
    // 3. 如果所有商品都是已取消，商家看到的就是"已取消"
    // 4. 如果有待付款，商家看到的就是"待付款"
    // 5. 如果有待发货，商家看到的就是"待发货"
    // 6. 如果有待收货，商家看到的就是"待收货"
    // 7. 如果所有商品都是待评价，商家看到的就是"待评价"
    // 8. 如果所有商品都已完成，商家看到的就是"已完成"

    if (hasRefunding) {
      return "退款中";
    } else if (refundedCount == totalItems) {
      return "已退款";
    } else if (cancelledCount == totalItems) {
      return "已取消";
    } else if (pendingPaymentCount > 0) {
      return "待付款";
    } else if (pendingShipCount > 0) {
      return "待发货";
    } else if (shippingCount > 0) {
      return "待收货";
    } else if (pendingReviewCount == totalItems) {
      return "待评价";
    } else if (completedCount == totalItems) {
      return "已完成";
    } else {
      return "待付款";
    }
  }

  @Override
  public String calculateOrderStatusFromItems(List<OrderItem> items) {
    if (items == null || items.isEmpty()) {
      return "未知";
    }

    int totalItems = items.size();
    int pendingPaymentCount = 0;
    int pendingShipCount = 0;
    int shippingCount = 0;
    int pendingReviewCount = 0;
    int completedCount = 0;
    int refundedCount = 0;
    int cancelledCount = 0;
    boolean hasRefunding = false;

    for (OrderItem item : items) {
      String status = item.getStatus();
      switch (status) {
        case "待付款":
          pendingPaymentCount++;
          break;
        case "待发货":
          pendingShipCount++;
          break;
        case "待收货":
          shippingCount++;
          break;
        case "待评价":
          pendingReviewCount++;
          break;
        case "已完成":
          completedCount++;
          break;
        case "已退款":
          refundedCount++;
          break;
        case "已取消":
          cancelledCount++;
          break;
        case "退款中":
          hasRefunding = true;
          break;
      }
    }

    if (hasRefunding) {
      return "退款中";
    } else if (pendingPaymentCount > 0) {
      return "待付款";
    } else if (pendingShipCount > 0) {
      return "待发货";
    } else if (shippingCount > 0) {
      return "待收货";
    } else if (pendingReviewCount > 0) {
      return "待评价";
    } else if (completedCount == totalItems) {
      return "已完成";
    } else if (refundedCount > 0) {
      return "已退款";
    } else if (cancelledCount == totalItems) {
      return "已取消";
    } else {
      return "已完成";
    }
  }

  public void updateOrderStatusFromItems(Long orderId) {
    List<OrderItem> items = orderItemService.getOrderItems(orderId);
    if (items == null || items.isEmpty()) {
      logger.warn("订单 {} 没有商品项，无法更新状态", orderId);
      return;
    }

    int pendingPaymentCount = 0;
    int pendingShipCount = 0;
    int shippingCount = 0;
    int pendingReviewCount = 0;
    int completedCount = 0;
    int refundedCount = 0;
    int cancelledCount = 0;
    boolean hasRefunding = false;

    for (OrderItem item : items) {
      String status = item.getStatus();

      switch (status) {
        case "待付款":
          pendingPaymentCount++;
          break;
        case "待发货":
          pendingShipCount++;
          break;
        case "待收货":
          shippingCount++;
          break;
        case "待评价":
          pendingReviewCount++;
          break;
        case "已完成":
          completedCount++;
          break;
        case "已退款":
          refundedCount++;
          break;
        case "已取消":
          cancelledCount++;
          break;
        case "退款中":
          hasRefunding = true;
          break;
      }
    }

    String newStatus;

    if (hasRefunding) {
      newStatus = OrderStatus.REFUNDING;
    } else if (pendingPaymentCount > 0) {
      newStatus = OrderStatus.PENDING_PAYMENT;
    } else if (pendingShipCount > 0) {
      newStatus = OrderStatus.PENDING_SHIP;
    } else if (shippingCount > 0) {
      newStatus = OrderStatus.SHIPPING;
    } else if (pendingReviewCount > 0) {
      newStatus = OrderStatus.PENDING_REVIEW;
    } else if (completedCount > 0 && completedCount == items.size()) {
      newStatus = OrderStatus.COMPLETED;
    } else if (refundedCount > 0) {
      newStatus = OrderStatus.REFUNDED;
    } else if (cancelledCount == items.size()) {
      newStatus = OrderStatus.CANCELLED;
    } else {
      newStatus = OrderStatus.COMPLETED;
    }

    Order order = this.getById(orderId);
    if (order != null) {
      String oldStatus = order.getOrderStatus();

      if (!newStatus.equals(oldStatus)) {
        order.setOrderStatus(newStatus);
        this.updateById(order);
      }
    }
  }

  @Override
  public List<Order> getUserOrders(Long userId) {
    LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
    wrapper.eq(Order::getUserId, userId)
        .orderByDesc(Order::getCreateTime)
        .orderByDesc(Order::getId);
    return this.list(wrapper);
  }

  @Override
  public List<Order> getMerchantOrders(Long merchantId) {
    LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
    itemWrapper.eq(OrderItem::getMerchantId, merchantId);
    List<OrderItem> merchantItems = orderItemService.list(itemWrapper);

    if (merchantItems == null || merchantItems.isEmpty()) {
      return new java.util.ArrayList<>();
    }

    Set<Long> orderIds = merchantItems.stream()
        .map(OrderItem::getOrderId)
        .collect(Collectors.toSet());

    if (orderIds.isEmpty()) {
      return new java.util.ArrayList<>();
    }

    LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
    orderWrapper.in(Order::getId, orderIds)
        .orderByDesc(Order::getCreateTime)
        .orderByDesc(Order::getId);

    List<Order> orders = this.list(orderWrapper);

    // 加载收货地址信息
    for (Order order : orders) {
      // 设置订单项
      List<OrderItem> items = orderItemService.getOrderItems(order.getId());
      List<OrderItem> merchantSpecificItems = items.stream()
          .filter(item -> merchantId.equals(item.getMerchantId()))
          .collect(Collectors.toList());

      for (OrderItem item : merchantSpecificItems) {
        LambdaQueryWrapper<RefundRequest> refundWrapper = new LambdaQueryWrapper<>();
        refundWrapper.eq(RefundRequest::getOrderItemId, item.getId())
            .orderByDesc(RefundRequest::getCreateTime)
            .last("LIMIT 1");
        RefundRequest refundRequest = refundRequestMapper.selectOne(refundWrapper);
        if (refundRequest != null) {
          item.setRefundReason(refundRequest.getRefundReason());
          item.setRefundDescription(refundRequest.getRefundDescription());
          item.setRefundStatus(refundRequest.getRefundStatus());
          item.setRefundId(refundRequest.getId());
        }
      }

      StringBuilder refundReasonBuilder = new StringBuilder();
      StringBuilder refundDescBuilder = new StringBuilder();
      int reasonIndex = 1;
      int descIndex = 1;
      for (OrderItem item : merchantSpecificItems) {
        if (item.getRefundReason() != null && !item.getRefundReason().isEmpty()) {
          if (refundReasonBuilder.length() > 0) {
            refundReasonBuilder.append("\n");
          }
          refundReasonBuilder.append(reasonIndex++).append(". ")
              .append(item.getBookName())
              .append(": ")
              .append(convertReasonCodeToText(item.getRefundReason()));
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

      order.setItems(merchantSpecificItems);

      // 计算商家视角的订单状态
      String merchantOrderStatus = calculateMerchantOrderStatus(merchantSpecificItems);
      order.setMerchantOrderStatus(merchantOrderStatus);

      // 重新计算商家商品的总金额
      BigDecimal merchantTotalAmount = merchantSpecificItems.stream()
          .map(OrderItem::getSubtotal)
          .reduce(BigDecimal.ZERO, BigDecimal::add);
      order.setTotalAmount(merchantTotalAmount);

      // 设置用户名（现在显示realName）
      if (order.getUserId() != null) {
        User user = userService.getById(order.getUserId());
        if (user != null) {
          order.setUsername(user.getRealName() != null && !user.getRealName().isEmpty()
              ? user.getRealName()
              : user.getUsername());
        }
      }

      // 设置收货人信息
      if (order.getAddressId() != null) {
        Address address = addressService.getById(order.getAddressId());
        if (address != null) {
          order.setReceiverName(address.getReceiverName());
          order.setReceiverPhone(address.getReceiverPhone());
          order.setAddress(
              address.getProvince() + address.getCity() + address.getDistrict() + address.getDetailAddress());
        }
      }
    }

    return orders;
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public Order createOrder(Order order) throws Exception {
    if (order.getUserId() == null) {
      throw new Exception("用户ID不能为空");
    }

    if (order.getItems() == null || order.getItems().isEmpty()) {
      throw new Exception("订单商品不能为空");
    }

    String orderNumber = "ORD" + System.currentTimeMillis() +
        String.format("%04d", (int) (Math.random() * 10000));

    BigDecimal totalAmount = BigDecimal.ZERO;
    List<OrderItem> orderItems = new ArrayList<>();

    for (OrderItem item : order.getItems()) {
      Book book = bookService.getById(item.getBookId());
      if (book == null) {
        throw new Exception("图书不存在: " + item.getBookId());
      }

      if (book.getStock() < item.getQuantity()) {
        throw new Exception("图书库存不足: " + book.getBookName());
      }

      BigDecimal subtotal = book.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
      totalAmount = totalAmount.add(subtotal);

      OrderItem orderItem = new OrderItem();
      orderItem.setBookId(book.getId());
      orderItem.setBookName(book.getBookName());
      orderItem.setCoverImage(book.getCoverImage());
      orderItem.setPrice(book.getPrice());
      orderItem.setQuantity(item.getQuantity());
      orderItem.setSubtotal(subtotal);

      if (book.getMerchantId() != null) {
        orderItem.setMerchantId(book.getMerchantId());
        User merchant = userService.getById(book.getMerchantId());
        if (merchant != null) {
          orderItem.setMerchantName(merchant.getShopName() != null ? merchant.getShopName() : merchant.getUsername());
          orderItem.setMerchantPhone(merchant.getPhone());
        }
      }

      orderItems.add(orderItem);

      book.setStock(book.getStock() - item.getQuantity());
      bookService.updateById(book);

      book.setSales(book.getSales() + item.getQuantity());
      bookService.updateById(book);
    }

    order.setOrderNumber(orderNumber);
    order.setTotalAmount(totalAmount);
    order.setOrderStatus(OrderStatus.PENDING_PAYMENT);
    order.setCreateTime(LocalDateTime.now());
    this.save(order);

    for (OrderItem item : orderItems) {
      item.setOrderId(order.getId());
      orderItemService.save(item);
    }

    if (order.getCartIds() != null && !order.getCartIds().isEmpty()) {
      for (Long cartId : order.getCartIds()) {
        try {
          cartService.removeById(cartId);
        } catch (Exception e) {
          logger.warn("删除购物车商品失败: cartId={}", cartId, e);
        }
      }
    }

    return order;
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public void updateOrderStatus(Long orderId, String status) throws Exception {
    Order order = this.getById(orderId);
    if (order == null) {
      throw new Exception("订单不存在");
    }

    if (!validateStatusTransition(order.getOrderStatus(), status)) {
      throw new Exception("不允许的状态转换: " + order.getOrderStatus() + " -> " + status);
    }

    Order updateOrder = new Order();
    updateOrder.setId(orderId);
    updateOrder.setOrderStatus(status);

    // 设置对应的时间戳（统一使用中文状态）
    if ("待发货".equals(status)) {
      updateOrder.setPaymentTime(LocalDateTime.now());
    } else if ("待收货".equals(status)) {
      updateOrder.setShippingTime(LocalDateTime.now());
    } else if ("已完成".equals(status)) {
      updateOrder.setCompletionTime(LocalDateTime.now());
    } else if ("已取消".equals(status) || "已退款".equals(status)) {
      restoreStock(orderId);
    }

    this.updateById(updateOrder);
  }

  @Override
  public boolean validateStatusTransition(String currentStatus, String targetStatus) {
    // 待付款状态可以转换为：待发货、已取消
    if ("待付款".equals(currentStatus)) {
      return "待发货".equals(targetStatus) || "已取消".equals(targetStatus);
    }

    // 待发货状态可以转换为：待收货、已取消
    if ("待发货".equals(currentStatus)) {
      return "待收货".equals(targetStatus) || "已取消".equals(targetStatus);
    }

    // 待收货状态可以转换为：已完成
    if ("待收货".equals(currentStatus)) {
      return "已完成".equals(targetStatus);
    }

    // 已完成、已取消状态不能转换
    if ("已完成".equals(currentStatus) || "已取消".equals(currentStatus) || "已退款".equals(currentStatus)) {
      return false;
    }

    return false;
  }

  @Transactional(rollbackFor = Exception.class)
  private void restoreStock(Long orderId) throws Exception {
    List<OrderItem> items = orderItemService.getOrderItems(orderId);

    for (OrderItem item : items) {
      Book book = bookService.getById(item.getBookId());
      if (book != null) {
        book.setStock(book.getStock() + item.getQuantity());
        bookService.updateById(book);

        book.setSales(Math.max(0, book.getSales() - item.getQuantity()));
        bookService.updateById(book);
      }
    }
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
}
