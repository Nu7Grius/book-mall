package com.bookmall.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("notice")
public class Notice {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private String content;

    private String coverImage;

    private String noticeType;

    private Long publisherId;

    private LocalDateTime publishTime;

    private LocalDateTime endTime;

    private Integer status;

    private Integer viewCount;

    @TableField(exist = false)
    private String publisherName;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}
