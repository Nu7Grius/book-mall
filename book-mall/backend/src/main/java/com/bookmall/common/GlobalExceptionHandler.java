package com.bookmall.common;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

/**
 * 全局异常处理器
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

  /**
   * 处理重复键异常（如用户名重复）
   */
  @ExceptionHandler(DuplicateKeyException.class)
  public Result<Map<String, Object>> handleDuplicateKeyException(DuplicateKeyException e) {
    String message = "数据已存在";
    if (e.getMessage() != null && e.getMessage().contains("username")) {
      message = "用户名已存在，请使用其他用户名";
    } else if (e.getMessage() != null && e.getMessage().contains("isbn")) {
      message = "ISBN号已存在";
    }
    return Result.error(400, message);
  }

  /**
   * 处理数据完整性异常（如字段不能为空）
   */
  @ExceptionHandler(DataIntegrityViolationException.class)
  public Result<Map<String, Object>> handleDataIntegrityViolationException(DataIntegrityViolationException e) {
    String message = "数据格式不正确";
    if (e.getMessage() != null) {
      if (e.getMessage().contains("doesn't have a default value")) {
        message = "请填写必填字段";
      } else if (e.getMessage().contains("cannot be null")) {
        message = "请填写必填字段";
      } else if (e.getMessage().contains("Data truncation")) {
        message = "数据长度超出限制";
      }
    }
    return Result.error(400, message + "：" + e.getMessage());
  }

  /**
   * 处理所有未捕获的异常
   */
  @ExceptionHandler(Exception.class)
  public Result<Map<String, Object>> handleException(Exception e) {
    Map<String, Object> map = new HashMap<>();
    map.put("exceptionMessage", e.getMessage());
    map.put("exceptionType", e.getClass().getSimpleName());
    // 返回详细错误信息用于调试
    String errorMsg = "操作失败：" + e.getClass().getSimpleName();
    if (e.getMessage() != null) {
      errorMsg += " - " + e.getMessage();
    }
    return Result.error(500, errorMsg);
  }

  /**
   * 处理运行时异常
   */
  @ExceptionHandler(RuntimeException.class)
  public Result<Map<String, Object>> handleRuntimeException(RuntimeException e) {
    Map<String, Object> map = new HashMap<>();
    map.put("exceptionMessage", e.getMessage());
    // 返回详细错误信息用于调试
    String errorMsg = "操作失败：" + e.getClass().getSimpleName();
    if (e.getMessage() != null) {
      errorMsg += " - " + e.getMessage();
    }
    return Result.error(500, errorMsg);
  }

  /**
   * 处理空指针异常
   */
  @ExceptionHandler(NullPointerException.class)
  public Result<Void> handleNullPointerException(NullPointerException e) {
    return Result.error(500, "操作失败：空指针异常 - " + (e.getMessage() != null ? e.getMessage() : "N/A"));
  }

  /**
   * 处理参数校验异常
   */
  @ExceptionHandler(IllegalArgumentException.class)
  public Result<Void> handleIllegalArgumentException(IllegalArgumentException e) {
    return Result.error(400, "参数错误：" + e.getMessage());
  }

  /**
   * 处理业务异常（自定义业务异常）
   */
  @ExceptionHandler(BusinessException.class)
  public Result<Void> handleBusinessException(BusinessException e) {
    return Result.error(e.getCode(), e.getMessage());
  }

  /**
   * 处理认证异常
   */
  @ExceptionHandler(AuthenticationException.class)
  public Result<Void> handleAuthenticationException(AuthenticationException e) {
    return Result.error(401, e.getMessage());
  }

  /**
   * 处理授权异常
   */
  @ExceptionHandler(AuthorizationException.class)
  public Result<Void> handleAuthorizationException(AuthorizationException e) {
    return Result.error(403, e.getMessage());
  }

  /**
   * 自定义业务异常类
   */
  public static class BusinessException extends RuntimeException {
    private Integer code = 400;

    public BusinessException(String message) {
      super(message);
    }

    public BusinessException(Integer code, String message) {
      super(message);
      this.code = code;
    }

    public Integer getCode() {
      return code;
    }
  }

  /**
   * 认证异常
   */
  public static class AuthenticationException extends RuntimeException {
    public AuthenticationException(String message) {
      super(message);
    }
  }

  /**
   * 授权异常
   */
  public static class AuthorizationException extends RuntimeException {
    public AuthorizationException(String message) {
      super(message);
    }
  }
}
