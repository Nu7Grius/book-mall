-- 为用户表添加性别和年龄字段
-- 用于存储用户的基本信息

-- 添加性别字段
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS gender VARCHAR(10) DEFAULT 'secret' COMMENT '性别：male男，female女，secret保密';

-- 添加年龄字段
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS age INT DEFAULT NULL COMMENT '年龄';
