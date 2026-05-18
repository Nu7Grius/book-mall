package com.bookmall.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookmall.common.Result;
import com.bookmall.entity.Book;
import com.bookmall.entity.User;
import com.bookmall.entity.Category;
import com.bookmall.service.BookService;
import com.bookmall.service.UserService;
import com.bookmall.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 图书管理控制器
 */
@RestController
@RequestMapping("/book")
@CrossOrigin
public class BookController {
    private static final Logger logger = LoggerFactory.getLogger(BookController.class);

    @Autowired
    private BookService bookService;

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService;

    /**
     * 获取所有图书列表（支持分页）
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getBookList(
            HttpServletRequest request,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false, defaultValue = "1") Long page,
            @RequestParam(required = false, defaultValue = "8") Long size,
            @RequestParam(required = false) String filterType,
            @RequestParam(required = false) BigDecimal priceMin,
            @RequestParam(required = false) BigDecimal priceMax,
            @RequestParam(required = false, defaultValue = "price") String sort,
            @RequestParam(required = false, defaultValue = "asc") String order) {
        List<Book> books;
        long total = 0;

        logger.info(
                "图书列表请求 - keyword: {}, categoryId: {}, filterType: {}, priceMin: {}, priceMax: {}, page: {}, size: {}",
                keyword, categoryId, filterType, priceMin, priceMax, page, size);

        // 手动解析categoryIds[]参数（支持categoryIds[]和categoryIds两种格式）
        List<Long> categoryIds = parseCategoryIds(request);

        // 构建分页查询条件
        LambdaQueryWrapper<Book> wrapper = new LambdaQueryWrapper<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.like(Book::getBookName, keyword.trim())
                    .or()
                    .like(Book::getAuthor, keyword.trim());
        }

        if (!categoryIds.isEmpty()) {
            // 使用categoryIds列表查询
            wrapper.in(Book::getCategoryId, categoryIds);
        } else if (categoryId != null) {
            // 判断传入的分类ID是否是一级分类
            Category category = categoryService.getById(categoryId);
            if (category != null && (category.getParentId() == null || category.getParentId() == 0)) {
                // 如果是一级分类，查询该分类下的所有子分类的图书
                List<Long> allCategoryIds = categoryService.getAllChildIds(categoryId);
                wrapper.in(Book::getCategoryId, allCategoryIds);
            } else {
                // 如果是二级分类，直接查询该分类的图书
                wrapper.eq(Book::getCategoryId, categoryId);
            }
        }

        // 只查询已审核通过的图书
        wrapper.eq(Book::getAuditStatus, 1);

        // 价格区间过滤
        if (priceMin != null) {
            wrapper.ge(Book::getPrice, priceMin);
        }
        if (priceMax != null) {
            wrapper.le(Book::getPrice, priceMax);
        }

        // 根据filterType进行排序（添加id作为第二排序字段，确保分页稳定）
        if ("hot".equals(filterType)) {
            wrapper.orderByDesc(Book::getSales)
                    .orderByDesc(Book::getId);
        } else if ("new".equals(filterType)) {
            wrapper.orderByDesc(Book::getCreateTime)
                    .orderByDesc(Book::getId);
        } else if ("price".equals(filterType)) {
            boolean isDesc = "desc".equalsIgnoreCase(order);
            if (isDesc) {
                wrapper.orderByDesc(Book::getPrice).orderByDesc(Book::getId);
            } else {
                wrapper.orderByAsc(Book::getPrice).orderByAsc(Book::getId);
            }
        } else {
            wrapper.orderByAsc(Book::getId);
        }

        // 执行分页查询
        Page<Book> bookPage = bookService.page(new Page<>(page, size), wrapper);
        books = bookPage.getRecords();
        total = bookPage.getTotal();

        // 填充商家信息
        for (Book book : books) {
            if (book.getMerchantId() != null) {
                User merchant = userService.getById(book.getMerchantId());
                if (merchant != null) {
                    book.setMerchantName(
                            merchant.getShopName() != null ? merchant.getShopName() : merchant.getUsername());
                    book.setShopName(merchant.getShopName());
                    book.setMerchantType(getMerchantType(merchant.getShopType()));
                    book.setMerchantAvatar(merchant.getLogo());
                }
            }
        }

        // 如果前端不需要分页，则返回所有数据
        if (page == 1 && size == 0) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                books = bookService.searchBooks(keyword.trim());
            } else if (!categoryIds.isEmpty()) {
                books = bookService.getBooksByCategories(categoryIds);
            } else if (categoryId != null) {
                books = bookService.getBooksByCategory(categoryId);
            } else {
                books = bookService.list();
            }
            total = books.size();
        }

        Map<String, Object> result = new HashMap<>();
        result.put("records", books);
        result.put("total", total);

        return Result.success("查询成功", result);
    }

    @GetMapping("/page")
    public Result<Map<String, Object>> getBookPage(
            @RequestParam(defaultValue = "1") Long page,
            @RequestParam(defaultValue = "10") Long pageSize,
            @RequestParam(required = false) String bookName,
            @RequestParam(required = false) String author,
            @RequestParam(required = false) String publisher,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(required = false) Long merchantId,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) List<Long> categoryIds) {
        LambdaQueryWrapper<Book> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(bookName != null && !bookName.trim().isEmpty(), Book::getBookName, bookName);
        wrapper.like(author != null && !author.trim().isEmpty(), Book::getAuthor, author);
        wrapper.like(publisher != null && !publisher.trim().isEmpty(), Book::getPublisher, publisher);
        wrapper.eq(status != null, Book::getStatus, status);
        wrapper.eq(auditStatus != null, Book::getAuditStatus, auditStatus);
        wrapper.eq(merchantId != null, Book::getMerchantId, merchantId);

        if (categoryId != null) {
            wrapper.eq(Book::getCategoryId, categoryId);
        }
        if (categoryIds != null && !categoryIds.isEmpty()) {
            wrapper.in(Book::getCategoryId, categoryIds);
        }

        wrapper.orderByDesc(Book::getCreateTime)
                .orderByDesc(Book::getId);

        Page<Book> bookPage = bookService.page(new Page<>(page, pageSize), wrapper);

        // 填充商家名称和分类名称
        for (Book book : bookPage.getRecords()) {
            // 填充商家名称
            if (book.getMerchantId() != null) {
                User merchant = userService.getById(book.getMerchantId());
                if (merchant != null) {
                    book.setMerchantName(
                            merchant.getShopName() != null ? merchant.getShopName() : merchant.getUsername());
                    book.setShopName(merchant.getShopName());
                }
            }

            // 填充分类名称
            if (book.getCategoryId() != null) {
                Category category = categoryService.getById(book.getCategoryId());
                if (category != null) {
                    book.setCategoryName(category.getCategoryName());
                }
            }
        }

        Map<String, Object> data = new HashMap<>();
        data.put("records", bookPage.getRecords());
        data.put("total", bookPage.getTotal());
        data.put("page", bookPage.getCurrent());
        data.put("pageSize", bookPage.getSize());
        return Result.success("查询成功", data);
    }

    /**
     * 解析categoryIds参数，支持categoryIds[]=1&categoryIds[]=2格式
     */
    private List<Long> parseCategoryIds(HttpServletRequest request) {
        List<Long> ids = new ArrayList<>();

        // 先尝试获取categoryIds[]（带方括号）
        String[] values = request.getParameterValues("categoryIds[]");
        if (values == null || values.length == 0) {
            // 尝试获取categoryIds（不带方括号）
            values = request.getParameterValues("categoryIds");
        }

        if (values != null) {
            for (String value : values) {
                try {
                    ids.add(Long.parseLong(value.trim()));
                } catch (NumberFormatException e) {
                    // 忽略无效数字
                }
            }
        }

        return ids;
    }

    /**
     * 搜索图书（模糊查询）
     */
    @GetMapping("/search")
    public Result<List<Book>> searchBooks(@RequestParam String keyword) {
        List<Book> books = bookService.searchBooks(keyword);
        return Result.success("搜索成功", books);
    }

    /**
     * 根据ID获取图书信息
     */
    @GetMapping("/{id}")
    public Result<Book> getBookById(@PathVariable Long id) {
        Book book = bookService.getById(id);
        if (book == null) {
            return Result.error("图书不存在");
        }

        // 填充商家信息
        if (book.getMerchantId() != null) {
            User merchant = userService.getById(book.getMerchantId());
            if (merchant != null) {
                book.setMerchantName(merchant.getShopName() != null ? merchant.getShopName() : merchant.getUsername());
                book.setShopName(merchant.getShopName());
                book.setShopType(merchant.getShopType());
                book.setMerchantType(getMerchantType(merchant.getShopType()));
                book.setMerchantAvatar(merchant.getLogo());
            }
        }

        // 填充分类信息
        if (book.getCategoryId() != null) {
            Category category = categoryService.getById(book.getCategoryId());
            if (category != null) {
                book.setCategoryName(category.getCategoryName());
            }
        }

        return Result.success(book);
    }

    /**
     * 添加图书
     */
    @PostMapping("/add")
    public Result<String> addBook(@RequestBody Book book,
            @RequestHeader(value = "X-User-Id", required = false) Long currentUserId,
            @RequestHeader(value = "X-User-Role", required = false) String currentRole) {
        // 商家添加图书时，自动设置为待审核状态
        if ("merchant".equals(currentRole)) {
            book.setAuditStatus(0); // 待审核
            // 商家添加的图书自动关联到当前商家
            if (book.getMerchantId() == null && currentUserId != null) {
                book.setMerchantId(currentUserId);
            }
        }

        boolean success = bookService.save(book);
        if (success) {
            return Result.success("图书添加成功，请等待管理员审核");
        }
        return Result.error("图书添加失败");
    }

    /**
     * 更新图书信息
     */
    @PutMapping("/update")
    public Result<Book> updateBook(@RequestBody Book book) {
        Book existBook = bookService.getById(book.getId());
        if (existBook == null) {
            return Result.error("图书不存在");
        }

        if (book.getStatus() == null) {
            book.setStatus(existBook.getStatus());
        }
        if (book.getMerchantId() == null) {
            book.setMerchantId(existBook.getMerchantId());
        }

        book.setUpdateTime(null);
        book.setCreateTime(existBook.getCreateTime());
        boolean success = bookService.updateById(book);

        if (success) {
            Book updatedBook = bookService.getById(book.getId());

            if (updatedBook.getMerchantId() != null) {
                User merchant = userService.getById(updatedBook.getMerchantId());
                if (merchant != null) {
                    updatedBook.setMerchantName(
                            merchant.getShopName() != null ? merchant.getShopName() : merchant.getUsername());
                    updatedBook.setShopName(merchant.getShopName());
                }
            }

            if (updatedBook.getCategoryId() != null) {
                Category category = categoryService.getById(updatedBook.getCategoryId());
                if (category != null) {
                    updatedBook.setCategoryName(category.getCategoryName());
                }
            }

            return Result.success("图书更新成功", updatedBook);
        }
        return Result.error("图书更新失败");
    }

    /**
     * 删除图书
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteBook(@PathVariable Long id) {
        boolean success = bookService.removeById(id);
        if (success) {
            return Result.success("图书删除成功");
        }
        return Result.error("图书删除失败");
    }

    /**
     * 审核图书
     */
    @PutMapping("/audit")
    public Result<String> auditBook(
            @RequestBody Book book,
            @RequestHeader(value = "X-User-Id", required = false) Long currentUserId) {
        Book existBook = bookService.getById(book.getId());
        if (existBook == null) {
            return Result.error("图书不存在");
        }

        // 设置审核信息
        book.setAuditTime(java.time.LocalDateTime.now());
        book.setAuditUserId(currentUserId);
        // 清空 updateTime
        book.setUpdateTime(null);

        boolean success = bookService.updateById(book);
        if (success) {
            return Result.success("审核成功");
        }
        return Result.error("审核失败");
    }

    /**
     * 强制下架图书（管理员操作）
     */
    @PutMapping("/force-offline/{id}")
    public Result<String> forceOfflineBook(@PathVariable Long id) {
        Book book = bookService.getById(id);
        if (book == null) {
            return Result.error("图书不存在");
        }

        book.setStatus(0); // 下架
        boolean success = bookService.updateById(book);
        if (success) {
            return Result.success("强制下架成功");
        }
        return Result.error("强制下架失败");
    }

    /**
     * 重新上架图书
     */
    @PutMapping("/re-online/{id}")
    public Result<String> reOnlineBook(@PathVariable Long id) {
        Book book = bookService.getById(id);
        if (book == null) {
            return Result.error("图书不存在");
        }

        if (book.getAuditStatus() != 1) {
            return Result.error("该图书未通过审核，无法上架");
        }

        book.setStatus(1); // 上架
        boolean success = bookService.updateById(book);
        if (success) {
            return Result.success("重新上架成功");
        }
        return Result.error("重新上架失败");
    }

    /**
     * 批量审核图书
     */
    @PutMapping("/batch-audit")
    public Result<String> batchAuditBooks(
            @RequestBody Map<String, Object> params,
            @RequestHeader(value = "X-User-Id", required = false) Long currentUserId) {
        List<Integer> ids = (List<Integer>) params.get("ids");
        Integer auditStatus = (Integer) params.get("auditStatus");
        String auditRemark = (String) params.get("auditRemark");

        if (ids == null || ids.isEmpty()) {
            return Result.error("请选择要审核的图书");
        }

        if (auditStatus == null) {
            return Result.error("请选择审核状态");
        }

        int successCount = 0;
        for (Integer id : ids) {
            Book book = bookService.getById(id);
            if (book != null) {
                book.setAuditStatus(auditStatus);
                book.setAuditTime(java.time.LocalDateTime.now());
                book.setAuditUserId(currentUserId);
                if (auditRemark != null && !auditRemark.isEmpty()) {
                    book.setAuditRemark(auditRemark);
                }
                if (bookService.updateById(book)) {
                    successCount++;
                }
            }
        }

        return Result.success("成功审核 " + successCount + " 本图书");
    }

    /**
     * 批量下架图书
     */
    @PutMapping("/batch-offline")
    public Result<String> batchOfflineBooks(@RequestBody Map<String, Object> params) {
        List<Integer> ids = (List<Integer>) params.get("ids");

        if (ids == null || ids.isEmpty()) {
            return Result.error("请选择要下架的图书");
        }

        int successCount = 0;
        for (Integer id : ids) {
            Book book = bookService.getById(id);
            if (book != null) {
                book.setStatus(0);
                if (bookService.updateById(book)) {
                    successCount++;
                }
            }
        }

        return Result.success("成功下架 " + successCount + " 本图书");
    }

    /**
     * 批量删除图书
     */
    @DeleteMapping("/batch-delete")
    public Result<String> batchDeleteBooks(@RequestBody Map<String, Object> params) {
        List<Integer> ids = (List<Integer>) params.get("ids");

        if (ids == null || ids.isEmpty()) {
            return Result.error("请选择要删除的图书");
        }

        int successCount = 0;
        for (Integer id : ids) {
            if (bookService.removeById(id)) {
                successCount++;
            }
        }

        return Result.success("成功删除 " + successCount + " 本图书");
    }

    /**
     * 获取待审核图书数量
     */
    @GetMapping("/pending-count")
    public Result<Long> getPendingAuditCount() {
        Long count = bookService.lambdaQuery()
                .eq(Book::getAuditStatus, 0)
                .count();
        return Result.success(count);
    }

    /**
     * 获取热门图书（按销量排序）
     */
    @GetMapping("/hot")
    public Result<List<Map<String, Object>>> getHotBooks(@RequestParam(defaultValue = "10") Integer limit) {
        List<Book> books = bookService.lambdaQuery()
                .eq(Book::getStatus, 1)
                .orderByDesc(Book::getSales)
                .last("LIMIT " + limit)
                .list();

        // 转换为包含店铺名称的Map
        List<Map<String, Object>> result = new java.util.ArrayList<>();
        for (Book book : books) {
            Map<String, Object> bookMap = new java.util.HashMap<>();
            bookMap.put("id", book.getId());
            bookMap.put("bookName", book.getBookName());
            bookMap.put("author", book.getAuthor());
            bookMap.put("price", book.getPrice());
            bookMap.put("sales", book.getSales());
            bookMap.put("stock", book.getStock());
            bookMap.put("coverImage", book.getCoverImage());

            // 查询商家店铺信息
            if (book.getMerchantId() != null) {
                User merchant = userService.getById(book.getMerchantId());
                if (merchant != null) {
                    // 店铺名称：优先使用shopName，如果没有则使用username
                    String shopName = merchant.getShopName();
                    if (shopName == null || shopName.trim().isEmpty()) {
                        shopName = merchant.getUsername();
                    }
                    bookMap.put("shopName", shopName);

                    // 店铺类型：使用shopType，如果没有则显示"自营"
                    String shopType = merchant.getShopType();
                    if (shopType == null || shopType.trim().isEmpty()) {
                        shopType = "自营";
                    }
                    bookMap.put("shopType", shopType);
                } else {
                    bookMap.put("shopName", "未知店铺");
                    bookMap.put("shopType", "自营");
                }
            } else {
                bookMap.put("shopName", "平台自营");
                bookMap.put("shopType", "自营");
            }

            result.add(bookMap);
        }

        return Result.success("查询成功", result);
    }

    /**
     * 根据店铺类型返回商家类型标识
     */
    private String getMerchantType(String shopType) {
        if (shopType == null || shopType.trim().isEmpty()) {
            return "self";
        }
        String type = shopType.trim();
        if (type.contains("旗舰") || type.contains("flagship")) {
            return "flagship";
        } else if (type.contains("自营") || type.contains("self")) {
            return "self";
        } else {
            return "third_party";
        }
    }
}
