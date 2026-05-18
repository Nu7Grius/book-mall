package com.bookmall.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookmall.entity.User;
import com.bookmall.mapper.UserMapper;
import com.bookmall.service.UserService;
import org.springframework.stereotype.Service;

/**
 * 用户 Service 实现类
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Override
    public boolean isUsernameExistsInRole(String username, String role) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username)
               .eq(User::getRole, role);
        return this.count(wrapper) > 0;
    }
}
