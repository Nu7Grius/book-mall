package com.bookmall.service;

import com.bookmall.entity.BookComment;
import com.baomidou.mybatisplus.extension.service.IService;
import java.util.List;
import java.util.Map;

public interface BookCommentService extends IService<BookComment> {
        List<BookComment> getCommentsByBookId(Long bookId);

        List<BookComment> getCommentsByUserId(Long userId);

        List<BookComment> getAllComments();

        Map<String, Object> getCommentPage(Integer page, Integer pageSize, String bookName, String userName,
                        Integer rating);

        Map<String, Object> getMerchantCommentPage(Long merchantId, Integer page, Integer pageSize, String bookName,
                        String userName, Integer rating, Integer status, String startDate, String endDate);

        void addComment(BookComment comment);

        void replyComment(Long commentId, String replyContent, String replyRole, Long replyUserId);

        boolean deleteComment(Long commentId);

        Map<String, Object> getCommentStats(Long bookId);
}
