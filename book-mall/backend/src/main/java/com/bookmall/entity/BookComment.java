package com.bookmall.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("book_comment")
public class BookComment {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long bookId;

    private Long userId;

    private Long orderId;

    private Integer rating;

    private String content;

    private Integer isAnonymous;

    private Integer status;

    private String replyContent;

    private LocalDateTime replyTime;

    private String replyRole;

    private Long replyUserId;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;

    @TableField(exist = false)
    private String userName;

    @TableField(exist = false)
    private String bookName;

    @TableField(exist = false)
    private String bookCover;

    @TableField(exist = false)
    private String bookAuthor;

    @TableField(exist = false)
    private String userAvatar;

    @TableField(exist = false)
    private String images;
}
