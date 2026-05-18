package com.bookmall.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 图书实体类
 */
@Data
@TableName("book")
public class Book implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 图书ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 图书名称
     */
    private String bookName;

    /**
     * 作者
     */
    private String author;

    /**
     * 出版社
     */
    private String publisher;

    /**
     * 出版日期
     */
    private LocalDateTime publishDate;

    /**
     * ISBN号
     */
    private String isbn;

    /**
     * 图书描述
     */
    private String description;

    /**
     * 价格
     */
    private BigDecimal price;

    /**
     * 库存数量
     */
    private Integer stock;

    /**
     * 销量
     */
    private Integer sales;

    /**
     * 封面图片URL
     */
    private String coverImage;

    /**
     * 类别ID
     */
    private Long categoryId;

    /**
     * 分类名称（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String categoryName;

    /**
     * 商家ID（外键关联用户表）
     */
    private Long merchantId;

    /**
     * 状态：0下架，1上架
     */
    private Integer status;

    /**
     * 审核状态：0待审核，1审核通过，2审核拒绝
     */
    private Integer auditStatus;

    /**
     * 审核时间
     */
    private LocalDateTime auditTime;

    /**
     * 审核备注（拒绝原因等）
     */
    private String auditRemark;

    /**
     * 审核人ID
     */
    private Long auditUserId;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /**
     * 逻辑删除标记
     */
    @TableLogic
    @TableField("deleted")
    private Integer deleted;

    /**
     * 商家名称（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String merchantName;

    /**
     * 商家店铺名称（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String shopName;

    /**
     * 商家类型（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String merchantType;

    /**
     * 店铺类型（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String shopType;

    /**
     * 商家头像（仅用于前端展示，非数据库字段）
     */
    @TableField(exist = false)
    private String merchantAvatar;
}
