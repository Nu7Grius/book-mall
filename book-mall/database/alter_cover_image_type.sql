-- 修改图书表，将封面图片字段改为 TEXT 类型
-- 因为前端使用 Base64 上传图片，字符串可能超过 VARCHAR(255) 的限制
ALTER TABLE book
MODIFY COLUMN cover_image TEXT COMMENT '封面图片URL';

-- 如果上面失败（字段可能已经被修改），使用以下语句验证
-- SELECT COLUMN_TYPE FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'book' AND COLUMN_NAME = 'cover_image';
