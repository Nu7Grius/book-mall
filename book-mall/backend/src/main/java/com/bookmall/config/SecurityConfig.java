package com.bookmall.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Spring Security 配置类
 * 禁用默认的安全拦截，只使用密码加密功能
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        // 禁用 CSRF 防护
        http.csrf().disable();

        // 禁用 HTTP Basic 认证
        http.httpBasic().disable();

        // 禁用表单登录
        http.formLogin().disable();

        // 允许所有请求（不进行权限拦截）
        http.authorizeRequests().anyRequest().permitAll();
    }
}
