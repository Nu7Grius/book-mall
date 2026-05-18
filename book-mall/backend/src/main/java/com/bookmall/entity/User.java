package com.bookmall.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 用户实体类
 */
@Data
@TableName("sys_user")
public class User implements Serializable {

  private static final long serialVersionUID = 1L;

  /**
   * 用户ID
   */
  @TableId(type = IdType.AUTO)
  private Long id;

  /**
   * 用户名
   */
  private String username;

  /**
   * 密码（加密存储）
   */
  private String password;

  /**
   * 真实姓名
   */
  private String realName;

  /**
   * 手机号码
   */
  private String phone;

  /**
   * 邮箱
   */
  private String email;

  /**
   * 头像URL
   */
  private String avatar;

  /**
   * 性别：男、女、保密
   */
  private String gender;

  /**
   * 年龄
   */
  private Integer age;

  /**
   * 角色：admin管理员，merchant商家，user普通用户
   */
  private String role;

  /**
   * 店铺类型：旗舰店、专卖店、直营店、自营等（仅商家）
   */
  private String shopType;

  /**
   * 店铺名称（仅商家）
   */
  private String shopName;

  /**
   * 店铺Logo（仅商家）- 存储图片URL路径
   */
  private String logo;

  /**
   * 店铺简介（仅商家）
   */
  private String description;

  /**
   * 店铺地址（仅商家）
   */
  private String address;

  /**
   * 开户银行（仅商家）
   */
  private String bankName;

  /**
   * 银行账号（仅商家）
   */
  private String bankAccount;

  /**
   * 开户姓名（仅商家）
   */
  private String bankAccountName;

  /**
   * 用户状态：0禁用，1启用
   */
  private Integer status;

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
   * 逻辑删除标记：0未删除，1已删除
   */
  @TableLogic
  @TableField("deleted")
  private Integer deleted;
}
