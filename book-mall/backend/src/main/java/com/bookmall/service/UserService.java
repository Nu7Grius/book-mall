package com.bookmall.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.bookmall.entity.User;

/**
 * 用户 Service 接口
 */
public interface UserService extends IService<User> {

    /**
     * 检查用户名在同一角色内是否已存在
     * @param username 用户名
     * @param role 角色类型
     * @return 是否存在
     */
    boolean isUsernameExistsInRole(String username, String role);
}
