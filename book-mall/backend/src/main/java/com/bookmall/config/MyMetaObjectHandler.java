package com.bookmall.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * MyBatis Plus 自动填充配置
 * 用于自动填充创建时间、更新时间字段和密码加密
 */
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    /**
     * 插入时自动填充
     */
    @Override
    public void insertFill(MetaObject metaObject) {
        this.strictInsertFill(metaObject, "createTime", LocalDateTime.class, LocalDateTime.now());
        this.strictInsertFill(metaObject, "updateTime", LocalDateTime.class, LocalDateTime.now());

        // 自动加密密码
        Object passwordObj = getFieldValByName("password", metaObject);
        if (passwordObj != null) {
            String password = passwordObj.toString();
            // 只加密明文密码（不加密已经是 BCrypt 格式的）
            if (!password.startsWith("$2a$") && !password.startsWith("$2b$") && !password.startsWith("$2y$")) {
                String encryptedPassword = passwordEncoder.encode(password);
                setFieldValByName("password", encryptedPassword, metaObject);
            }
        }
    }

    /**
     * 更新时自动填充
     */
    @Override
    public void updateFill(MetaObject metaObject) {
        this.strictUpdateFill(metaObject, "updateTime", LocalDateTime.class, LocalDateTime.now());

        // 自动加密密码（如果密码被修改且不为空）
        Object passwordObj = getFieldValByName("password", metaObject);
        if (passwordObj != null) {
            String password = passwordObj.toString();
            // 只在密码不为空时才处理
            if (!password.trim().isEmpty() && !password.startsWith("$2a$") && !password.startsWith("$2b$") && !password.startsWith("$2y$")) {
                String encryptedPassword = passwordEncoder.encode(password);
                setFieldValByName("password", encryptedPassword, metaObject);
            }
        }
    }
}
