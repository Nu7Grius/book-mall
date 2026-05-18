package com.bookmall.common;

import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 管理员权限验证工具类
 * 方案B: 普通管理员不能编辑/删除其他管理员账户
 */
@Component
public class AdminPermissionUtil {

    /**
     * 检查当前登录用户是否为管理员（admin或super_admin）
     */
    public boolean isAdmin(HttpSession session) {
        if (session == null) {
            return false;
        }
        String role = (String) session.getAttribute("role");
        return "admin".equals(role) || "super_admin".equals(role);
    }

    /**
     * 检查当前登录用户是否为超级管理员
     */
    public boolean isSuperAdmin(HttpSession session) {
        if (session == null) {
            return false;
        }
        String role = (String) session.getAttribute("role");
        return "super_admin".equals(role);
    }

    /**
     * 检查当前登录用户是否有权限操作目标用户
     * 规则:
     * - 超级管理员可以操作所有用户
     * - 普通管理员不能操作其他管理员（admin角色）
     * - 普通管理员可以操作商家和普通用户
     * - 商家和普通用户不能操作任何人
     *
     * @param currentUserRole 当前登录用户角色
     * @param targetUserRole  目标用户角色
     * @return 是否有权限
     */
    public boolean canOperateUser(String currentUserRole, String targetUserRole) {
        // 非管理员不能操作任何用户
        if (!"admin".equals(currentUserRole) && !"super_admin".equals(currentUserRole)) {
            return false;
        }

        // 超级管理员可以操作所有用户
        if ("super_admin".equals(currentUserRole)) {
            return true;
        }

        // 普通管理员不能操作其他管理员
        if ("admin".equals(targetUserRole)) {
            return false;
        }

        // 普通管理员可以操作商家和普通用户
        return true;
    }

    /**
     * 检查是否可以从请求中获取当前用户角色
     */
    public String getCurrentUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (String) session.getAttribute("role");
    }
}
