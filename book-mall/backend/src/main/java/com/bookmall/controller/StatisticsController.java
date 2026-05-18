package com.bookmall.controller;

import com.bookmall.common.Result;
import com.bookmall.entity.User;
import com.bookmall.entity.Book;
import com.bookmall.entity.Order;
import com.bookmall.service.UserService;
import com.bookmall.service.BookService;
import com.bookmall.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 统计控制器
 */
@RestController
@RequestMapping("/statistics")
@CrossOrigin
public class StatisticsController {

        @Autowired
        private UserService userService;

        @Autowired
        private BookService bookService;

        @Autowired
        private OrderService orderService;

        /**
         * 获取平台统计数据
         */
        @GetMapping("/overview")
        public Result<Map<String, Object>> getOverview() {
                Map<String, Object> data = new HashMap<>();

                // 管理员数量
                long adminCount = userService.lambdaQuery()
                                .eq(User::getRole, "admin")
                                .count();
                data.put("adminCount", adminCount);

                // 会员数量（普通用户）
                long userCount = userService.lambdaQuery()
                                .eq(User::getRole, "user")
                                .count();
                data.put("userCount", userCount);

                // 商家数量
                long merchantCount = userService.lambdaQuery()
                                .eq(User::getRole, "merchant")
                                .count();
                data.put("merchantCount", merchantCount);

                // 图书总数
                long bookCount = bookService.count();
                data.put("bookCount", bookCount);

                // 订单总数
                long orderCount = orderService.count();
                data.put("orderCount", orderCount);

                // 今日订单数
                LocalDateTime startOfDay = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
                LocalDateTime endOfDay = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);
                long todayOrderCount = orderService.lambdaQuery()
                                .ge(Order::getCreateTime, startOfDay)
                                .le(Order::getCreateTime, endOfDay)
                                .count();
                data.put("todayOrderCount", todayOrderCount);

                return Result.success(data);
        }

        /**
         * 获取热门图书
         */
        @GetMapping("/hot-books")
        public Result<List<Book>> getHotBooks(@RequestParam(defaultValue = "10") Integer limit) {
                List<Book> allBooks = bookService.list();
                List<Book> hotBooks = allBooks.stream()
                                .sorted(Comparator
                                                .comparing(Book::getSales,
                                                                Comparator.nullsFirst(Comparator.naturalOrder()))
                                                .reversed())
                                .limit(limit)
                                .collect(Collectors.toList());
                return Result.success(hotBooks);
        }

        /**
         * 获取热门商家
         */
        @GetMapping("/hot-merchants")
        public Result<List<Map<String, Object>>> getHotMerchants(@RequestParam(defaultValue = "5") Integer limit) {
                List<User> merchants = userService.lambdaQuery()
                                .eq(User::getRole, "merchant")
                                .list();
                List<Map<String, Object>> merchantStats = new ArrayList<>();

                for (User merchant : merchants) {
                        Map<String, Object> stats = new HashMap<>();
                        stats.put("id", merchant.getId());
                        stats.put("shopName", merchant.getShopName());
                        stats.put("shopType", merchant.getShopType());
                        stats.put("avatar", merchant.getAvatar());

                        // 统计该商家的图书数量
                        long bookCount = bookService.lambdaQuery()
                                        .eq(Book::getMerchantId, merchant.getId())
                                        .count();
                        stats.put("bookCount", bookCount);

                        // 统计总销量
                        List<Book> books = bookService.lambdaQuery()
                                        .eq(Book::getMerchantId, merchant.getId())
                                        .list();
                        long totalSales = books.stream()
                                        .mapToLong(book -> book.getSales() != null ? book.getSales() : 0)
                                        .sum();
                        stats.put("totalSales", totalSales);

                        merchantStats.add(stats);
                }

                // 按销量排序
                merchantStats.sort((a, b) -> Long.compare((Long) b.get("totalSales"), (Long) a.get("totalSales")));

                // 取前N个
                if (merchantStats.size() > limit) {
                        merchantStats = merchantStats.subList(0, limit);
                }

                return Result.success(merchantStats);
        }
}
