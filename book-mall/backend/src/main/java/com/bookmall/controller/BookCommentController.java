package com.bookmall.controller;

import com.bookmall.common.Result;
import com.bookmall.entity.BookComment;
import com.bookmall.entity.User;
import com.bookmall.service.BookCommentService;
import com.bookmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/comment")
@CrossOrigin
public class BookCommentController {

    @Autowired
    private BookCommentService bookCommentService;

    @Autowired
    private UserService userService;

    @GetMapping("/book/{bookId}")
    public Map<String, Object> getCommentsByBookId(@PathVariable Long bookId) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<BookComment> comments = bookCommentService.getCommentsByBookId(bookId);
            result.put("code", 200);
            result.put("msg", "获取成功");
            result.put("data", comments);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "获取评论失败: " + e.getMessage());
        }
        return result;
    }

    @GetMapping("/user/{userId}")
    public Map<String, Object> getCommentsByUserId(@PathVariable Long userId) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<BookComment> comments = bookCommentService.getCommentsByUserId(userId);
            result.put("code", 200);
            result.put("msg", "获取成功");
            result.put("data", comments);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "获取评论失败: " + e.getMessage());
        }
        return result;
    }

    @PostMapping
    public Map<String, Object> addComment(@RequestBody BookComment comment,
            HttpSession session,
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        Map<String, Object> result = new HashMap<>();
        try {
            User currentUser = null;

            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);
                try {
                    Long userId = Long.parseLong(token);
                    currentUser = userService.getById(userId);
                } catch (NumberFormatException e) {
                    // token 不是有效的用户ID，尝试从session获取
                }
            }

            if (currentUser == null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null && comment.getUserId() != null) {
                currentUser = userService.getById(comment.getUserId());
            }

            if (currentUser == null) {
                result.put("code", 401);
                result.put("msg", "请先登录");
                return result;
            }

            comment.setUserId(currentUser.getId());
            comment.setCreateTime(LocalDateTime.now());
            comment.setUpdateTime(LocalDateTime.now());
            comment.setStatus(1);

            bookCommentService.addComment(comment);
            result.put("code", 200);
            result.put("msg", "评论成功");
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "评论失败: " + e.getMessage());
        }
        return result;
    }

    @PutMapping("/reply/{id}")
    public Map<String, Object> replyComment(@PathVariable Long id,
            @RequestBody Map<String, String> params,
            HttpSession session,
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        Map<String, Object> result = new HashMap<>();
        try {
            User currentUser = null;

            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);
                try {
                    Long userId = Long.parseLong(token);
                    currentUser = userService.getById(userId);
                } catch (NumberFormatException e) {
                }
            }

            if (currentUser == null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                result.put("code", 401);
                result.put("msg", "请先登录");
                return result;
            }

            if (!"merchant".equals(currentUser.getRole())) {
                result.put("code", 403);
                result.put("msg", "只有商家才能回复评论");
                return result;
            }

            String replyContent = params.get("replyContent");
            if (replyContent == null || replyContent.trim().isEmpty()) {
                result.put("code", 400);
                result.put("msg", "回复内容不能为空");
                return result;
            }

            String replyRole = params.get("replyRole");
            String replyUserIdStr = params.get("replyUserId");
            Long replyUserId = null;
            if (replyUserIdStr != null && !replyUserIdStr.isEmpty()) {
                try {
                    replyUserId = Long.parseLong(replyUserIdStr);
                } catch (NumberFormatException e) {
                    result.put("code", 400);
                    result.put("msg", "无效的回复用户ID");
                    return result;
                }
            }

            bookCommentService.replyComment(id, replyContent, replyRole, replyUserId);
            result.put("code", 200);
            result.put("msg", "回复成功");
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "回复失败: " + e.getMessage());
        }
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> deleteComment(@PathVariable Long id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            bookCommentService.deleteComment(id);
            result.put("code", 200);
            result.put("msg", "删除成功");
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "删除失败: " + e.getMessage());
        }
        return result;
    }

    @PutMapping("/status/{id}")
    public Map<String, Object> updateCommentStatus(@PathVariable Long id, @RequestBody Map<String, Integer> params) {
        Map<String, Object> result = new HashMap<>();
        try {
            Integer status = params.get("status");
            if (status == null) {
                result.put("code", 400);
                result.put("msg", "状态不能为空");
                return result;
            }

            BookComment comment = bookCommentService.getById(id);
            if (comment == null) {
                result.put("code", 404);
                result.put("msg", "评论不存在");
                return result;
            }

            comment.setStatus(status);
            bookCommentService.updateById(comment);
            result.put("code", 200);
            result.put("msg", "状态更新成功");
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "状态更新失败: " + e.getMessage());
        }
        return result;
    }

    @GetMapping("/all")
    public Map<String, Object> getAllComments() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<BookComment> comments = bookCommentService.getAllComments();
            result.put("code", 200);
            result.put("msg", "获取成功");
            result.put("data", comments);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "获取评论失败: " + e.getMessage());
        }
        return result;
    }

    @GetMapping("/page")
    public Result<Map<String, Object>> getCommentPage(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String bookName,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) Integer rating) {
        Map<String, Object> data = bookCommentService.getCommentPage(page, pageSize, bookName, userName, rating);
        return Result.success("查询成功", data);
    }

    @GetMapping("/merchant/page")
    public Result<Map<String, Object>> getMerchantCommentPage(
            @RequestParam Long merchantId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String bookName,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) Integer rating,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        Map<String, Object> data = bookCommentService.getMerchantCommentPage(merchantId, page, pageSize, bookName,
                userName, rating, status, startDate, endDate);
        return Result.success("查询成功", data);
    }

    @GetMapping("/stats/{bookId}")
    public Map<String, Object> getCommentStats(@PathVariable Long bookId) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> stats = bookCommentService.getCommentStats(bookId);
            result.put("code", 200);
            result.put("msg", "获取成功");
            result.put("data", stats);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "获取统计失败: " + e.getMessage());
        }
        return result;
    }
}
