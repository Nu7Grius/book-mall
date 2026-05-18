SELECT id, username, real_name, phone, email, role, status FROM sys_user WHERE deleted = 0 ORDER BY role, id;
