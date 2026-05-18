# 调试教训总结

## 问题描述

在实现图书分类筛选功能时，遇到了前端分类筛选不生效的问题。用户期望：
- 选择一级分类（文学）时，显示该分类下的所有图书
- 再选择二级分类（小说）时，进一步缩小范围

## 调试过程回顾

### 问题现象
- 选择"文学"分类后，图书列表没有按照预期刷新
- 数据库中的分类和图书关系正确
- 后端API单独测试正常

### 排查步骤

#### 1. 检查前端代码
发现前端逻辑会传递 `categoryIds` 参数，但传递方式有问题。

#### 2. 使用浏览器开发者工具诊断
- **Network 面板**：发现请求参数为 `categoryIds[]=2&categoryIds[]=3`
- **Console 面板**：发现 `Failed to fetch` 网络错误
- 确认参数格式正确，但后端无法解析

#### 3. 直接测试后端API
- `http://localhost:8080/book/list` → 返回5本书 ✅
- `http://localhost:8080/book/list?categoryIds[]=2&categoryIds[]=3` → HTTP 400 错误 ❌

#### 4. 根本原因分析
- 前端发送的参数：`categoryIds[]=2&categoryIds[]=3`
- URL编码后：`categoryIds%5B%5D=2&categoryIds%5B%5D=3`
- Spring MVC 默认无法正确解析带方括号的参数

#### 5. 解决方案
修改后端Controller，手动解析HTTP请求参数：

```java
@GetMapping("/list")
public Result<List<Book>> getBookList(
        HttpServletRequest request,
        @RequestParam(required = false) String keyword,
        @RequestParam(required = false) Long categoryId) {
    List<Book> books;
    
    // 手动解析categoryIds[]参数（支持categoryIds[]和categoryIds两种格式）
    List<Long> categoryIds = parseCategoryIds(request);
    
    if (keyword != null && !keyword.trim().isEmpty()) {
        books = bookService.searchBooks(keyword.trim());
    } else if (!categoryIds.isEmpty()) {
        books = bookService.getBooksByCategories(categoryIds);
    } else if (categoryId != null) {
        books = bookService.getBooksByCategory(categoryId);
    } else {
        books = bookService.list();
    }
    return Result.success("查询成功", books);
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
```

## 关键教训

### 1. 先确认问题，再动手修改 ⚠️
- **教训**：一开始看到代码"看起来正确"就直接修改
- **正确做法**：应该先让用户测试，确认问题到底在前端还是后端
- **花费时间**：浪费了大量时间修改其实没问题的代码

### 2. 学会看浏览器开发者工具 🔍
- **教训**：花了很长时间才让用户学会看 Network 和 Console
- **正确做法**：这是排查前端问题的基本技能，应该第一时间就学会使用
- **关键工具**：
  - Network 面板：查看请求和响应
  - Console 面板：查看 JavaScript 日志和错误
  - Sources 面板：调试 JavaScript 代码

### 3. 后端日志很重要 📊
- **教训**：应该第一时间检查后端控制台
- **正确做法**：每次测试都应该同时观察前端和后端两边
- **关键日志**：`System.out.println()` 是最简单有效的调试方式

### 4. 请求参数的编码问题 🌐
- **教训**：HTTP 参数中的特殊字符（`[]`）需要 URL 编码
- **根本原因**：
  - 前端发送：`categoryIds[]=2&categoryIds[]=3`
  - 实际请求：`categoryIds%5B%5D=2&categoryIds%5B%5D=3`
  - 后端没处理 `%5B%5D`，导致解析失败

### 5. 沟通要更直接 💬
- **教训**：一直在猜测问题，而不是直接问用户测试结果
- **正确做法**：每个步骤都要问清楚结果，不要假设

---

## 快速排查流程

```
1. 打开浏览器开发者工具（F12）
   ↓
2. 切换到 Network 标签
   ↓
3. 执行操作（点击按钮、选择分类等）
   ↓
4. 查看请求是否发出？
   ├─ 没有 → 检查前端代码或网络问题
   └─ 有 → 点击请求查看详情
   ↓
5. 查看请求参数是否正确？
   ├─ 不正确 → 检查前端代码
   └─ 正确 → 继续
   ↓
6. 查看响应状态码？
   ├─ 4xx/5xx → 检查后端代码
   └─ 200 → 继续
   ↓
7. 查看后端控制台日志
   ↓
8. 根据日志判断问题所在
```

## 技术知识点

### HTTP 参数编码
- 方括号 `[]` 在 URL 中会被编码为 `%5B` 和 `%5D`
- Spring MVC 默认的 `@RequestParam` 无法解析这种编码后的参数
- 解决方案：使用 `HttpServletRequest` 手动解析

### Axios 数组参数处理
- 默认情况下，Axios 会将数组转换为 `param[]=value` 格式
- 这是符合 Java Servlet 规范的，但与某些后端框架不兼容
- 需要在后端手动处理，或配置 Axios 的 `paramsSerializer`

---

## 经验总结

### 最重要的一点

**遇到问题不要慌，一步一步排查比盲目修改更高效！**

### 调试心态

1. **保持冷静**：问题总能找到原因
2. **分而治之**：将大问题拆分成小问题
3. **验证假设**：每一步都验证后再继续
4. **记录过程**：方便回溯和总结

### 常用调试工具

- 浏览器开发者工具（F12）
- Postman 或 curl
- 后端日志输出
- 数据库查询工具

---

## 修改文件清单

1. **后端**：`backend/src/main/java/com/bookmall/controller/BookController.java`
   - 添加了 `parseCategoryIds()` 方法
   - 支持解析 `categoryIds[]` 和 `categoryIds` 两种格式

2. **前端**：`frontend/src/views/shop/BookListPage.vue`
   - 修正了分类筛选逻辑
   - 只查询二级分类，不包含一级分类ID

---

**日期**：2026-04-30
**问题状态**：已解决 ✅
