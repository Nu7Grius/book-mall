-- 店铺设置扩展字段 SQL 迁移脚本
-- 执行此脚本为 sys_user 表添加店铺相关的扩展字段

-- 添加店铺Logo字段（TEXT类型，用于存储Base64编码的图片）
ALTER TABLE sys_user
ADD COLUMN IF NOT EXISTS logo TEXT COMMENT '店铺Logo' AFTER shop_name;

-- 添加店铺简介字段
ALTER TABLE sys_user
ADD COLUMN IF NOT EXISTS description VARCHAR(1000) COMMENT '店铺简介' AFTER logo;

-- 添加店铺地址字段
ALTER TABLE sys_user
ADD COLUMN IF NOT EXISTS address VARCHAR(255) COMMENT '店铺地址' AFTER description;

-- 添加开户银行字段
ALTER TABLE sys_user
ADD COLUMN IF NOT EXISTS bank_name VARCHAR(100) COMMENT '开户银行' AFTER address;

-- 添加银行账号字段
ALTER TABLE sys_user
ADD COLUMN IF NOT EXISTS bank_account VARCHAR(50) COMMENT '银行账号' AFTER bank_name;

-- 添加开户姓名字段
ALTER TABLE sys_user
ADD COLUMN IF NOT EXISTS bank_account_name VARCHAR(50) COMMENT '开户姓名' AFTER bank_account;

-- ============================================
-- 重要：如果之前已经执行过旧版本脚本，需要先删除旧字段再重新添加
-- ============================================

-- 删除旧字段（如果存在）
-- ALTER TABLE sys_user DROP COLUMN IF EXISTS logo;
-- ALTER TABLE sys_user DROP COLUMN IF EXISTS description;
-- ALTER TABLE sys_user DROP COLUMN IF EXISTS address;
-- ALTER TABLE sys_user DROP COLUMN IF EXISTS bank_name;
-- ALTER TABLE sys_user DROP COLUMN IF EXISTS bank_account;
-- ALTER TABLE sys_user DROP COLUMN IF EXISTS bank_account_name;

-- 重新添加正确类型的字段
-- ALTER TABLE sys_user ADD COLUMN logo TEXT COMMENT '店铺Logo' AFTER shop_name;
-- ALTER TABLE sys_user ADD COLUMN description VARCHAR(1000) COMMENT '店铺简介' AFTER logo;
-- ALTER TABLE sys_user ADD COLUMN address VARCHAR(255) COMMENT '店铺地址' AFTER description;
-- ALTER TABLE sys_user ADD COLUMN bank_name VARCHAR(100) COMMENT '开户银行' AFTER address;
-- ALTER TABLE sys_user ADD COLUMN bank_account VARCHAR(50) COMMENT '银行账号' AFTER bank_name;
-- ALTER TABLE sys_user ADD COLUMN bank_account_name VARCHAR(50) COMMENT '开户姓名' AFTER bank_account;

-- ============================================
-- 如果MySQL版本不支持 IF NOT EXISTS，使用以下语句
-- ============================================

-- 修改logo字段为TEXT类型（如果已经是VARCHAR(500)）
-- ALTER TABLE sys_user MODIFY COLUMN logo TEXT COMMENT '店铺Logo';

-- 修改description字段为VARCHAR(1000)（如果已经是VARCHAR(500)）
-- ALTER TABLE sys_user MODIFY COLUMN description VARCHAR(1000) COMMENT '店铺简介';

SELECT '店铺扩展字段添加/更新成功！' AS result;
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'book_mall' AND TABLE_NAME = 'sys_user'
AND COLUMN_NAME IN ('logo', 'description', 'address', 'bank_name', 'bank_account', 'bank_account_name');
