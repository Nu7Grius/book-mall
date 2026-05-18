-- 修改地址表，将 phone 字段改为 receiver_phone
-- 执行此SQL前请先备份数据库

ALTER TABLE address CHANGE COLUMN phone receiver_phone VARCHAR(20) NOT NULL COMMENT '联系电话';
