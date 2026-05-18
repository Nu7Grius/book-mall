package com.bookmall.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.bookmall.common.Result;
import com.bookmall.common.OrderStatus;
import com.bookmall.entity.Book;
import com.bookmall.entity.BookComment;
import com.bookmall.entity.Order;
import com.bookmall.entity.OrderItem;
import com.bookmall.entity.User;
import com.bookmall.service.BookCommentService;
import com.bookmall.service.BookService;
import com.bookmall.service.OrderItemService;
import com.bookmall.service.OrderService;
import com.bookmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.*;

/**
 * 商家管理控制器
 */
@RestController
@RequestMapping("/merchant")
@CrossOrigin
public class MerchantController {

    @Autowired
    private UserService userService;

    @Autowired
    private BookService bookService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderItemService orderItemService;

    @Autowired
    private BookCommentService bookCommentService;

    /**
     * 获取当前商家店铺信息
     */
    @GetMapping("/shop/info")
    public Result<User> getShopInfo() {
        // 从请求头或session获取当前商家ID，这里假设通过参数传递
        // 实际项目中应该从登录信息中获取
        return Result.success(null);
    }

    /**
     * 更新商家店铺信息
     */
    @PostMapping("/shop/update")
    public Result<String> updateShopInfo(@RequestBody User user) {
        if (user.getId() == null) {
            return Result.error("商家ID不能为空");
        }

        try {
            // 更新商家信息
            User existUser = userService.getById(user.getId());
            if (existUser == null) {
                return Result.error("商家不存在");
            }

            // 更新店铺信息
            existUser.setShopName(user.getShopName());
            existUser.setLogo(user.getLogo());
            existUser.setDescription(user.getDescription());
            existUser.setRealName(user.getRealName());
            existUser.setPhone(user.getPhone());
            existUser.setAddress(user.getAddress());
            existUser.setBankName(user.getBankName());
            existUser.setBankAccount(user.getBankAccount());
            existUser.setBankAccountName(user.getBankAccountName());
            existUser.setStatus(user.getStatus());

            userService.updateById(existUser);
            return Result.success("店铺信息更新成功");
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }

    /**
     * 获取热门店铺 TOP 5（按图书总销量排序）
     */
    @GetMapping("/hot")
    public Result<List<Map<String, Object>>> getHotMerchants(@RequestParam(defaultValue = "5") Integer limit) {
        // 查询所有商家
        List<User> merchants = userService.lambdaQuery()
                .eq(User::getRole, "merchant")
                .list();

        // 统计每个商家的图书销量
        List<Map<String, Object>> merchantStats = new ArrayList<>();
        for (User merchant : merchants) {
            // 查询该商家的所有图书销量总和
            Integer totalSales = bookService.lambdaQuery()
                    .eq(Book::getMerchantId, merchant.getId())
                    .eq(Book::getStatus, 1)
                    .select(Book::getSales)
                    .list()
                    .stream()
                    .filter(book -> book.getSales() != null)
                    .mapToInt(Book::getSales)
                    .sum();

            // 查询该商家的图书数量
            Long bookCount = bookService.lambdaQuery()
                    .eq(Book::getMerchantId, merchant.getId())
                    .eq(Book::getStatus, 1)
                    .count();

            Map<String, Object> stats = new HashMap<>();
            stats.put("id", merchant.getId());

            // 店铺名称：优先使用shopName，如果没有则使用username
            String shopName = merchant.getShopName();
            if (shopName == null || shopName.trim().isEmpty()) {
                shopName = merchant.getUsername();
            }
            stats.put("shopName", shopName);

            // 店铺类型：使用shopType，如果没有则显示"自营"
            String shopType = merchant.getShopType();
            if (shopType == null || shopType.trim().isEmpty()) {
                shopType = "自营";
            }
            stats.put("shopType", shopType);

            stats.put("avatar", merchant.getAvatar());
            stats.put("totalSales", totalSales);
            stats.put("bookCount", bookCount);
            stats.put("registerTime", merchant.getCreateTime());

            merchantStats.add(stats);
        }

        // 按总销量降序排序
        merchantStats.sort((a, b) -> {
            Integer salesA = (Integer) a.get("totalSales");
            Integer salesB = (Integer) b.get("totalSales");
            return salesB.compareTo(salesA);
        });

        // 返回前N个
        if (merchantStats.size() > limit) {
            return Result.success(merchantStats.subList(0, limit));
        }
        return Result.success(merchantStats);
    }

    /**
     * 获取商家统计数据（评分、真实销售额、退款、实际成交额等）
     * 按照真实电商项目的统计方式：
     * - 销售额：只统计"已完成"的订单
     * - 退款总额：只统计"已退款"的订单
     * - 实际成交额：销售额 - 退款总额
     * - 有效订单数：只统计"已完成"的订单数量
     *
     * @param merchantId 商家ID
     */
    @GetMapping("/statistics")
    public Result<Map<String, Object>> getMerchantStatistics(@RequestParam Long merchantId) {
        Map<String, Object> result = new HashMap<>();

        // 1. 统计该商家的图书数量（仅上架）
        long totalBooks = bookService.lambdaQuery()
                .eq(Book::getMerchantId, merchantId)
                .eq(Book::getStatus, 1)
                .count();
        result.put("totalBooks", totalBooks);

        // 2. 统计该商家的订单相关数据
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getMerchantId, merchantId);
        List<OrderItem> merchantItems = orderItemService.list(itemWrapper);

        Set<Long> orderIds = new HashSet<>();
        for (OrderItem item : merchantItems) {
            orderIds.add(item.getOrderId());
        }

        List<Order> orders = new ArrayList<>();
        if (!orderIds.isEmpty()) {
            LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
            orderWrapper.in(Order::getId, orderIds);
            orders = orderService.list(orderWrapper);
        }

        Set<Long> customerIds = new HashSet<>();

        // 销售额：只统计"已完成"的订单
        BigDecimal totalSalesAmount = BigDecimal.ZERO;
        // 退款总额：只统计"已退款"的订单
        BigDecimal refundAmount = BigDecimal.ZERO;
        // 有效订单数（已完成）
        int completedOrderCount = 0;
        // 待处理订单数（待发货、待收货）
        int pendingOrderCount = 0;
        // 全部有效订单数（不含已取消的）
        int totalOrderCount = 0;

        for (Order order : orders) {
            // 跳过已取消的订单
            if ("已取消".equals(order.getOrderStatus())) {
                continue;
            }

            // 获取该订单中属于当前商家的商品
            List<OrderItem> orderMerchantItems = new ArrayList<>();
            for (OrderItem item : merchantItems) {
                if (item.getOrderId().equals(order.getId()) && merchantId.equals(item.getMerchantId())) {
                    orderMerchantItems.add(item);
                }
            }

            if (orderMerchantItems.isEmpty())
                continue;

            totalOrderCount++;

            if (order.getUserId() != null) {
                customerIds.add(order.getUserId());
            }

            // 按每个商品自己的状态分别统计（不依赖整单状态）
            boolean hasCompleted = false;
            boolean hasPending = false;
            for (OrderItem item : orderMerchantItems) {
                if (item.getSubtotal() == null)
                    continue;
                String itemStatus = item.getStatus();

                if (OrderStatus.COMPLETED.equals(itemStatus)) {
                    totalSalesAmount = totalSalesAmount.add(item.getSubtotal());
                    hasCompleted = true;
                } else if (OrderStatus.REFUNDED.equals(itemStatus)) {
                    refundAmount = refundAmount.add(item.getSubtotal());
                } else if (OrderStatus.PENDING_SHIP.equals(itemStatus) || OrderStatus.SHIPPING.equals(itemStatus)
                        || OrderStatus.PENDING_PAYMENT.equals(itemStatus)
                        || OrderStatus.PENDING_REVIEW.equals(itemStatus)) {
                    hasPending = true;
                }
            }
            if (hasCompleted)
                completedOrderCount++;
            if (hasPending)
                pendingOrderCount++;
        }

        // 实际成交额 = 销售额 - 退款总额
        BigDecimal actualSalesAmount = totalSalesAmount.subtract(refundAmount);

        // 客单价 = 销售额 / 已完成订单数
        BigDecimal avgOrderValue = BigDecimal.ZERO;
        if (completedOrderCount > 0) {
            avgOrderValue = totalSalesAmount.divide(BigDecimal.valueOf(completedOrderCount), 2,
                    BigDecimal.ROUND_HALF_UP);
        }

        result.put("totalOrders", totalOrderCount);
        result.put("completedOrders", completedOrderCount);
        result.put("pendingOrders", pendingOrderCount);
        result.put("totalSales", totalSalesAmount);
        result.put("refundAmount", refundAmount);
        result.put("actualSales", actualSalesAmount);
        result.put("avgOrderValue", avgOrderValue);
        result.put("totalCustomers", customerIds.size());

        // 3. 统计该商家的平均评分
        List<Book> merchantBooks = bookService.lambdaQuery()
                .eq(Book::getMerchantId, merchantId)
                .list();

        Set<Long> merchantBookIds = new HashSet<>();
        for (Book book : merchantBooks) {
            merchantBookIds.add(book.getId());
        }

        List<BookComment> comments = bookCommentService.lambdaQuery()
                .isNotNull(BookComment::getRating)
                .list();

        double totalRating = 0.0;
        int ratedCount = 0;

        for (BookComment comment : comments) {
            if (merchantBookIds.contains(comment.getBookId()) && comment.getRating() != null) {
                totalRating += comment.getRating();
                ratedCount++;
            }
        }

        double averageRating = ratedCount > 0 ? Math.round((totalRating / ratedCount) * 10) / 10.0 : 0.0;
        result.put("rating", averageRating);
        result.put("ratedCount", ratedCount);

        return Result.success(result);
    }

    /**
     * 获取商家的近期待订单
     *
     * @param merchantId 商家ID
     * @param limit      返回数量，默认5条
     */
    @GetMapping("/recent-orders")
    public Result<List<Map<String, Object>>> getRecentOrders(@RequestParam Long merchantId,
            @RequestParam(defaultValue = "5") Integer limit) {
        List<Map<String, Object>> recentOrders = new ArrayList<>();

        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getMerchantId, merchantId);
        List<OrderItem> merchantItems = orderItemService.list(itemWrapper);

        if (merchantItems.isEmpty()) {
            return Result.success(recentOrders);
        }

        Set<Long> orderIds = new HashSet<>();
        for (OrderItem item : merchantItems) {
            orderIds.add(item.getOrderId());
        }

        LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
        orderWrapper.in(Order::getId, orderIds);
        orderWrapper.orderByDesc(Order::getCreateTime)
                .orderByDesc(Order::getId);
        List<Order> orders = orderService.list(orderWrapper);

        int count = 0;
        for (Order order : orders) {
            if (count >= limit)
                break;

            // 收集该订单中属于当前商家的所有商品
            List<OrderItem> orderMerchantItems = new ArrayList<>();
            StringBuilder bookNames = new StringBuilder();
            int totalQuantity = 0;

            for (OrderItem item : merchantItems) {
                if (item.getOrderId().equals(order.getId()) && merchantId.equals(item.getMerchantId())) {
                    orderMerchantItems.add(item);
                    if (bookNames.length() > 0) {
                        bookNames.append("、");
                    }
                    bookNames.append(item.getBookName());
                    totalQuantity += item.getQuantity();
                }
            }

            if (orderMerchantItems.isEmpty())
                continue;

            // 计算该商家在订单中的总金额（只算该商家的商品）
            BigDecimal merchantAmount = BigDecimal.ZERO;
            for (OrderItem item : orderMerchantItems) {
                if (item.getSubtotal() != null) {
                    merchantAmount = merchantAmount.add(item.getSubtotal());
                }
            }

            Map<String, Object> orderInfo = new HashMap<>();
            orderInfo.put("orderNo", order.getOrderNumber());
            orderInfo.put("status", order.getOrderStatus());
            orderInfo.put("totalPrice", merchantAmount); // 只算该商家的金额
            orderInfo.put("createTime", order.getCreateTime());
            orderInfo.put("bookName", bookNames.toString());
            orderInfo.put("quantity", totalQuantity);

            if (order.getUserId() != null) {
                User user = userService.getById(order.getUserId());
                if (user != null) {
                    orderInfo.put("userName", user.getRealName() != null && !user.getRealName().isEmpty()
                            ? user.getRealName()
                            : user.getUsername());
                }
            }

            recentOrders.add(orderInfo);
            count++;
        }

        return Result.success(recentOrders);
    }

    /**
     * 获取商家的热销图书
     *
     * @param merchantId 商家ID
     * @param limit      返回数量，默认5条
     */
    @GetMapping("/hot-books")
    public Result<List<Map<String, Object>>> getHotBooks(@RequestParam Long merchantId,
            @RequestParam(defaultValue = "5") Integer limit) {
        List<Map<String, Object>> hotBooks = new ArrayList<>();

        List<Book> books = bookService.lambdaQuery()
                .eq(Book::getMerchantId, merchantId)
                .orderByDesc(Book::getSales)
                .orderByDesc(Book::getId)
                .list();

        int count = 0;
        for (Book book : books) {
            if (count >= limit)
                break;

            Map<String, Object> bookInfo = new HashMap<>();
            bookInfo.put("name", book.getBookName());
            bookInfo.put("salesCount", book.getSales() != null ? book.getSales() : 0);
            bookInfo.put("price", book.getPrice());

            hotBooks.add(bookInfo);
            count++;
        }

        return Result.success(hotBooks);
    }

    /**
     * 获取商家的详细统计数据（支持不同时间范围）
     *
     * @param merchantId 商家ID
     * @param range      时间范围：day-今天, week-本周, month-本月, all-全部
     */
    @GetMapping("/detailed-statistics")
    public Result<Map<String, Object>> getDetailedStatistics(@RequestParam Long merchantId,
            @RequestParam(defaultValue = "week") String range) {
        Map<String, Object> result = new HashMap<>();

        LocalDate today = LocalDate.now();
        LocalDate startDate = null;

        switch (range) {
            case "day":
                startDate = today;
                break;
            case "week":
                startDate = today.minusDays(6);
                break;
            case "month":
                startDate = today.minusDays(29);
                break;
            case "all":
            default:
                startDate = LocalDate.of(2000, 1, 1);
                break;
        }

        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getMerchantId, merchantId);
        List<OrderItem> merchantItems = orderItemService.list(itemWrapper);

        Set<Long> orderIds = new HashSet<>();
        for (OrderItem item : merchantItems) {
            orderIds.add(item.getOrderId());
        }

        if (orderIds.isEmpty()) {
            result.put("sales", BigDecimal.ZERO);
            result.put("orders", 0);
            result.put("avgOrderValue", BigDecimal.ZERO);
            result.put("customers", 0);
            result.put("actualSales", BigDecimal.ZERO);
            result.put("refundAmount", BigDecimal.ZERO);
            return Result.success(result);
        }

        LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
        orderWrapper.in(Order::getId, orderIds);
        List<Order> orders = orderService.list(orderWrapper);

        BigDecimal totalSales = BigDecimal.ZERO;
        BigDecimal refundAmount = BigDecimal.ZERO;
        Set<Long> customerSet = new HashSet<>();
        int merchantOrderCount = 0;

        for (Order order : orders) {
            if (order.getCreateTime() == null)
                continue;

            LocalDate orderDate = order.getCreateTime().toLocalDate();
            if (orderDate.isBefore(startDate) || orderDate.isAfter(today))
                continue;

            // 收集该订单中属于当前商家的商品
            List<OrderItem> orderMerchantItems = new ArrayList<>();
            for (OrderItem item : merchantItems) {
                if (item.getOrderId().equals(order.getId()) && merchantId.equals(item.getMerchantId())) {
                    orderMerchantItems.add(item);
                }
            }

            if (orderMerchantItems.isEmpty())
                continue;

            // 按每个商品自己的状态分别统计
            boolean hasCompleted = false;
            for (OrderItem item : orderMerchantItems) {
                if (item.getSubtotal() == null)
                    continue;
                String itemStatus = item.getStatus();

                if (OrderStatus.COMPLETED.equals(itemStatus)) {
                    totalSales = totalSales.add(item.getSubtotal());
                    hasCompleted = true;
                    if (order.getUserId() != null) {
                        customerSet.add(order.getUserId());
                    }
                } else if (OrderStatus.REFUNDED.equals(itemStatus)) {
                    refundAmount = refundAmount.add(item.getSubtotal());
                }
            }
            if (hasCompleted) {
                merchantOrderCount++;
            }
        }

        result.put("sales", totalSales);
        result.put("orders", merchantOrderCount);
        result.put("customers", customerSet.size());
        result.put("actualSales", totalSales);
        result.put("refundAmount", refundAmount);

        BigDecimal avgOrderValue = BigDecimal.ZERO;
        if (merchantOrderCount > 0) {
            avgOrderValue = totalSales.divide(BigDecimal.valueOf(merchantOrderCount), 2, BigDecimal.ROUND_HALF_UP);
        }
        result.put("avgOrderValue", avgOrderValue);

        return Result.success(result);
    }

    /**
     * 获取商家的销售明细（按日期分组）
     *
     * @param merchantId 商家ID
     * @param days       天数，默认7天
     */
    @GetMapping("/sales-detail")
    public Result<List<Map<String, Object>>> getSalesDetail(@RequestParam Long merchantId,
            @RequestParam(defaultValue = "7") Integer days) {
        List<Map<String, Object>> salesDetail = new ArrayList<>();

        LocalDate today = LocalDate.now();
        Map<LocalDate, Map<String, Object>> dailyData = new LinkedHashMap<>();

        for (int i = days - 1; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            Map<String, Object> data = new HashMap<>();
            data.put("date", date.toString());
            data.put("orders", 0);
            data.put("sales", BigDecimal.ZERO);
            data.put("customers", 0);
            data.put("avgOrderValue", BigDecimal.ZERO);
            data.put("customerSet", new HashSet<Long>());
            dailyData.put(date, data);
        }

        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getMerchantId, merchantId);
        List<OrderItem> merchantItems = orderItemService.list(itemWrapper);

        if (merchantItems.isEmpty()) {
            for (Map.Entry<LocalDate, Map<String, Object>> entry : dailyData.entrySet()) {
                Map<String, Object> data = new HashMap<>(entry.getValue());
                data.remove("customerSet");
                salesDetail.add(data);
            }
            return Result.success(salesDetail);
        }

        Set<Long> orderIds = new HashSet<>();
        for (OrderItem item : merchantItems) {
            orderIds.add(item.getOrderId());
        }

        LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
        orderWrapper.in(Order::getId, orderIds);
        List<Order> orders = orderService.list(orderWrapper);

        for (Order order : orders) {
            if (order.getCreateTime() == null)
                continue;

            LocalDate orderDate = order.getCreateTime().toLocalDate();
            if (!dailyData.containsKey(orderDate))
                continue;

            // 按每个商品自己的状态分别统计
            BigDecimal orderMerchantAmount = BigDecimal.ZERO;
            boolean hasCompleted = false;
            for (OrderItem item : merchantItems) {
                if (!item.getOrderId().equals(order.getId()) || !merchantId.equals(item.getMerchantId()))
                    continue;
                if (item.getSubtotal() == null)
                    continue;
                if (!OrderStatus.COMPLETED.equals(item.getStatus()))
                    continue;

                orderMerchantAmount = orderMerchantAmount.add(item.getSubtotal());
                hasCompleted = true;
            }

            if (hasCompleted && orderMerchantAmount.compareTo(BigDecimal.ZERO) > 0) {
                Map<String, Object> data = dailyData.get(orderDate);
                data.put("orders", (int) data.get("orders") + 1);
                data.put("sales",
                        ((BigDecimal) data.get("sales")).add(orderMerchantAmount));
                if (order.getUserId() != null) {
                    @SuppressWarnings("unchecked")
                    Set<Long> customers = (Set<Long>) data.get("customerSet");
                    customers.add(order.getUserId());
                }
            }
        }

        for (Map.Entry<LocalDate, Map<String, Object>> entry : dailyData.entrySet()) {
            Map<String, Object> data = new HashMap<>(entry.getValue());
            @SuppressWarnings("unchecked")
            Set<Long> customers = (Set<Long>) data.get("customerSet");
            data.put("customers", customers.size());
            data.remove("customerSet");

            int orders2 = (int) data.get("orders");
            if (orders2 > 0) {
                BigDecimal sales = (BigDecimal) data.get("sales");
                data.put("avgOrderValue",
                        sales.divide(BigDecimal.valueOf(orders2), 2, BigDecimal.ROUND_HALF_UP));
            }
            salesDetail.add(data);
        }

        return Result.success(salesDetail);
    }

    /**
     * 获取商家的销售趋势（近7天）
     *
     * @param merchantId 商家ID
     */
    @GetMapping("/sales-trend")
    public Result<List<Map<String, Object>>> getSalesTrend(@RequestParam Long merchantId) {
        List<Map<String, Object>> trend = new ArrayList<>();

        LocalDate today = LocalDate.now();
        Map<LocalDate, BigDecimal> dailySales = new LinkedHashMap<>();

        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            dailySales.put(date, BigDecimal.ZERO);
        }

        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getMerchantId, merchantId);
        List<OrderItem> merchantItems = orderItemService.list(itemWrapper);

        if (merchantItems.isEmpty()) {
            for (Map.Entry<LocalDate, BigDecimal> entry : dailySales.entrySet()) {
                Map<String, Object> dayData = new HashMap<>();
                dayData.put("date", entry.getKey().toString());
                dayData.put("dayName", getDayName(entry.getKey()));
                dayData.put("sales", entry.getValue());
                trend.add(dayData);
            }
            return Result.success(trend);
        }

        Set<Long> orderIds = new HashSet<>();
        for (OrderItem item : merchantItems) {
            orderIds.add(item.getOrderId());
        }

        LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
        orderWrapper.in(Order::getId, orderIds);
        List<Order> orders = orderService.list(orderWrapper);

        for (Order order : orders) {
            if (order.getCreateTime() == null)
                continue;

            LocalDate orderDate = order.getCreateTime().toLocalDate();
            if (!dailySales.containsKey(orderDate))
                continue;

            // 按每个商品自己的状态分别统计
            for (OrderItem item : merchantItems) {
                if (!item.getOrderId().equals(order.getId()) || !merchantId.equals(item.getMerchantId()))
                    continue;
                if (item.getSubtotal() == null)
                    continue;
                if (!OrderStatus.COMPLETED.equals(item.getStatus()))
                    continue;

                BigDecimal current = dailySales.get(orderDate);
                dailySales.put(orderDate, current.add(item.getSubtotal()));
            }
        }

        for (Map.Entry<LocalDate, BigDecimal> entry : dailySales.entrySet()) {
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", entry.getKey().toString());
            dayData.put("dayName", getDayName(entry.getKey()));
            dayData.put("sales", entry.getValue());
            trend.add(dayData);
        }

        return Result.success(trend);
    }

    private String getDayName(LocalDate date) {
        DayOfWeek dayOfWeek = date.getDayOfWeek();
        switch (dayOfWeek) {
            case MONDAY:
                return "周一";
            case TUESDAY:
                return "周二";
            case WEDNESDAY:
                return "周三";
            case THURSDAY:
                return "周四";
            case FRIDAY:
                return "周五";
            case SATURDAY:
                return "周六";
            case SUNDAY:
                return "周日";
            default:
                return "";
        }
    }
}
