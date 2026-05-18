-- 完整修复：修改所有 cover_image 字段为 TEXT 类型
-- 因为前端使用 Base64 上传图片，字符串可能超过 VARCHAR(255) 的限制

-- 1. 修改 book 表的 cover_image 字段
ALTER TABLE book
MODIFY COLUMN cover_image TEXT COMMENT '封面图片URL';

-- 2. 修改 order_item 表的 cover_image 字段（冗余字段）
ALTER TABLE order_item
MODIFY COLUMN cover_image TEXT COMMENT '封面图片（冗余字段）';

-- 3. 修改 notice 表的 cover_image 字段
ALTER TABLE notice
MODIFY COLUMN cover_image TEXT COMMENT '封面图片URL';

-- 验证所有表的 cover_image 字段类型
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND COLUMN_NAME = 'cover_image';
