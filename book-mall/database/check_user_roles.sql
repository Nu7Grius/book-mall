-- 检查系统管理员的角色值
SELECT id, username, role, status FROM sys_user WHERE role = 'super_admin';

-- 查看所有用户及其角色
SELECT id, username, role, status FROM sys_user ORDER BY role, id;

-- 如果需要，将某个管理员设置为超级管理员
-- UPDATE sys_user SET role = 'super_admin' WHERE id = 你的管理员ID;
