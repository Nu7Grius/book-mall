package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookmall.entity.BookComment;
import com.bookmall.entity.User;
import com.bookmall.entity.Book;
import com.bookmall.mapper.BookCommentMapper;
import com.bookmall.service.BookCommentService;
import com.bookmall.service.UserService;
import com.bookmall.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BookCommentServiceImpl extends ServiceImpl<BookCommentMapper, BookComment> implements BookCommentService {

    @Autowired
    private UserService userService;

    @Autowired
    private BookService bookService;

    @Override
    public List<BookComment> getCommentsByBookId(Long bookId) {
        LambdaQueryWrapper<BookComment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookComment::getBookId, bookId)
                .eq(BookComment::getStatus, 1)
                .orderByDesc(BookComment::getCreateTime)
                .orderByDesc(BookComment::getId);
        List<BookComment> comments = this.list(wrapper);

        for (BookComment comment : comments) {
            User user = userService.getById(comment.getUserId());
            if (user != null) {
                comment.setUserName(user.getRealName() != null && !user.getRealName().isEmpty()
                        ? user.getRealName()
                        : user.getUsername());
                comment.setUserAvatar(user.getAvatar());
            }
            if (comment.getRating() == null) {
                comment.setRating(5);
            }
        }

        return comments;
    }

    @Override
    public List<BookComment> getCommentsByUserId(Long userId) {
        LambdaQueryWrapper<BookComment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookComment::getUserId, userId)
                .orderByDesc(BookComment::getCreateTime)
                .orderByDesc(BookComment::getId);
        List<BookComment> comments = this.list(wrapper);

        for (BookComment comment : comments) {
            Book book = bookService.getById(comment.getBookId());
            if (book != null) {
                comment.setBookName(book.getBookName());
            }
        }

        return comments;
    }

    @Override
    public List<BookComment> getAllComments() {
        LambdaQueryWrapper<BookComment> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(BookComment::getCreateTime)
                .orderByDesc(BookComment::getId);
        List<BookComment> comments = this.list(wrapper);

        for (BookComment comment : comments) {
            User user = userService.getById(comment.getUserId());
            if (user != null) {
                comment.setUserName(user.getRealName() != null && !user.getRealName().isEmpty()
                        ? user.getRealName()
                        : user.getUsername());
                comment.setUserAvatar(user.getAvatar());
            }
            Book book = bookService.getById(comment.getBookId());
            if (book != null) {
                comment.setBookName(book.getBookName());
            }
        }

        return comments;
    }

    @Override
    public Map<String, Object> getCommentPage(Integer page, Integer pageSize, String bookName, String userName,
            Integer rating) {
        LambdaQueryWrapper<BookComment> wrapper = new LambdaQueryWrapper<>();

        if (bookName != null && !bookName.trim().isEmpty()) {
            List<Book> books = bookService.lambdaQuery()
                    .like(Book::getBookName, bookName)
                    .list();
            if (!books.isEmpty()) {
                List<Long> bookIds = books.stream().map(Book::getId).collect(java.util.stream.Collectors.toList());
                wrapper.in(BookComment::getBookId, bookIds);
            } else {
                wrapper.eq(BookComment::getBookId, -1L);
            }
        }

        if (userName != null && !userName.trim().isEmpty()) {
            List<User> users = userService.lambdaQuery()
                    .like(User::getUsername, userName)
                    .or()
                    .like(User::getRealName, userName)
                    .list();
            if (!users.isEmpty()) {
                List<Long> userIds = users.stream().map(User::getId).collect(java.util.stream.Collectors.toList());
                wrapper.in(BookComment::getUserId, userIds);
            } else {
                wrapper.eq(BookComment::getUserId, -1L);
            }
        }

        if (rating != null) {
            wrapper.eq(BookComment::getRating, rating);
        }

        wrapper.orderByDesc(BookComment::getCreateTime)
                .orderByDesc(BookComment::getId);

        Page<BookComment> commentPage = this.page(new Page<>(page, pageSize), wrapper);
        List<BookComment> comments = commentPage.getRecords();

        for (BookComment comment : comments) {
            User user = userService.getById(comment.getUserId());
            if (user != null) {
                comment.setUserName(user.getRealName() != null && !user.getRealName().isEmpty()
                        ? user.getRealName()
                        : user.getUsername());
                comment.setUserAvatar(user.getAvatar());
            }
            Book book = bookService.getById(comment.getBookId());
            if (book != null) {
                comment.setBookName(book.getBookName());
                comment.setBookCover(book.getCoverImage());
                comment.setBookAuthor(book.getAuthor());
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("records", comments);
        result.put("total", commentPage.getTotal());
        result.put("page", commentPage.getCurrent());
        result.put("pageSize", commentPage.getSize());
        return result;
    }

    @Override
    public Map<String, Object> getMerchantCommentPage(Long merchantId, Integer page, Integer pageSize, String bookName,
            String userName, Integer rating, Integer status, String startDate, String endDate) {
        List<Long> merchantBookIds = bookService.lambdaQuery()
                .eq(Book::getMerchantId, merchantId)
                .list()
                .stream()
                .map(Book::getId)
                .collect(java.util.stream.Collectors.toList());

        LambdaQueryWrapper<BookComment> wrapper = new LambdaQueryWrapper<>();

        if (merchantBookIds.isEmpty()) {
            Map<String, Object> emptyResult = new HashMap<>();
            emptyResult.put("records", new java.util.ArrayList<>());
            emptyResult.put("total", 0L);
            emptyResult.put("page", page);
            emptyResult.put("pageSize", pageSize);
            return emptyResult;
        }
        wrapper.in(BookComment::getBookId, merchantBookIds);

        if (bookName != null && !bookName.trim().isEmpty()) {
            List<Long> filteredBookIds = bookService.lambdaQuery()
                    .eq(Book::getMerchantId, merchantId)
                    .like(Book::getBookName, bookName)
                    .list()
                    .stream()
                    .map(Book::getId)
                    .collect(java.util.stream.Collectors.toList());
            if (!filteredBookIds.isEmpty()) {
                wrapper.in(BookComment::getBookId, filteredBookIds);
            } else {
                wrapper.eq(BookComment::getBookId, -1L);
            }
        }

        if (userName != null && !userName.trim().isEmpty()) {
            List<User> users = userService.lambdaQuery()
                    .like(User::getUsername, userName)
                    .or()
                    .like(User::getRealName, userName)
                    .list();
            if (!users.isEmpty()) {
                List<Long> userIds = users.stream().map(User::getId).collect(java.util.stream.Collectors.toList());
                wrapper.in(BookComment::getUserId, userIds);
            } else {
                wrapper.eq(BookComment::getUserId, -1L);
            }
        }

        if (rating != null) {
            wrapper.eq(BookComment::getRating, rating);
        }

        if (status != null) {
            wrapper.eq(BookComment::getStatus, status);
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            wrapper.ge(BookComment::getCreateTime, startDate + " 00:00:00");
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            wrapper.le(BookComment::getCreateTime, endDate + " 23:59:59");
        }

        wrapper.orderByDesc(BookComment::getCreateTime)
                .orderByDesc(BookComment::getId);

        Page<BookComment> commentPage = this.page(new Page<>(page, pageSize), wrapper);
        List<BookComment> comments = commentPage.getRecords();

        for (BookComment comment : comments) {
            User user = userService.getById(comment.getUserId());
            if (user != null) {
                comment.setUserName(user.getRealName() != null && !user.getRealName().isEmpty()
                        ? user.getRealName()
                        : user.getUsername());
                comment.setUserAvatar(user.getAvatar());
            }
            Book book = bookService.getById(comment.getBookId());
            if (book != null) {
                comment.setBookName(book.getBookName());
                comment.setBookCover(book.getCoverImage());
                comment.setBookAuthor(book.getAuthor());
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("records", comments);
        result.put("total", commentPage.getTotal());
        result.put("page", commentPage.getCurrent());
        result.put("pageSize", commentPage.getSize());
        return result;
    }

    @Override
    public void addComment(BookComment comment) {
        if (comment.getRating() == null) {
            comment.setRating(5);
        }
        if (comment.getIsAnonymous() == null) {
            comment.setIsAnonymous(0);
        }
        if (comment.getStatus() == null) {
            comment.setStatus(1);
        }
        comment.setCreateTime(LocalDateTime.now());
        this.save(comment);
    }

    @Override
    public void replyComment(Long commentId, String replyContent, String replyRole, Long replyUserId) {
        BookComment comment = this.getById(commentId);
        if (comment != null) {
            comment.setReplyContent(replyContent);
            comment.setReplyTime(LocalDateTime.now());
            comment.setReplyRole("merchant");
            comment.setReplyUserId(replyUserId);
            this.updateById(comment);
        }
    }

    @Override
    public boolean deleteComment(Long commentId) {
        return this.removeById(commentId);
    }

    @Override
    public Map<String, Object> getCommentStats(Long bookId) {
        Map<String, Object> stats = new HashMap<>();
        LambdaQueryWrapper<BookComment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookComment::getBookId, bookId)
                .eq(BookComment::getStatus, 1);

        long total = this.count(wrapper);
        stats.put("total", total);

        if (total > 0) {
            List<BookComment> comments = this.list(wrapper);
            double avgRating = comments.stream()
                    .mapToInt(BookComment::getRating)
                    .average()
                    .orElse(0.0);
            stats.put("avgRating", Math.round(avgRating * 10) / 10.0);

            long fiveStar = comments.stream().filter(c -> c.getRating() == 5).count();
            long fourStar = comments.stream().filter(c -> c.getRating() == 4).count();
            long threeStar = comments.stream().filter(c -> c.getRating() == 3).count();
            long twoStar = comments.stream().filter(c -> c.getRating() == 2).count();
            long oneStar = comments.stream().filter(c -> c.getRating() == 1).count();

            stats.put("fiveStar", fiveStar);
            stats.put("fourStar", fourStar);
            stats.put("threeStar", threeStar);
            stats.put("twoStar", twoStar);
            stats.put("oneStar", oneStar);
        } else {
            stats.put("avgRating", 0.0);
            stats.put("fiveStar", 0);
            stats.put("fourStar", 0);
            stats.put("threeStar", 0);
            stats.put("twoStar", 0);
            stats.put("oneStar", 0);
        }

        return stats;
    }
}
