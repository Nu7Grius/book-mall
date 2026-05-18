-- 修改所有 cover_image 字段为 MEDIUMTEXT 类型
-- TEXT 类型只能存储 64KB，不够存储 Base64 编码的图片
-- MEDIUMTEXT 可以存储最多 16MB，足够存储 Base64 编码的图片

-- 1. 修改 book 表的 cover_image 字段
ALTER TABLE book
MODIFY COLUMN cover_image MEDIUMTEXT COMMENT '封面图片URL';

-- 2. 修改 order_item 表的 cover_image 字段
ALTER TABLE order_item
MODIFY COLUMN cover_image MEDIUMTEXT COMMENT '封面图片（冗余字段）';

-- 3. 修改 notice 表的 cover_image 字段
ALTER TABLE notice
MODIFY COLUMN cover_image MEDIUMTEXT COMMENT '封面图片URL';

-- 验证修改结果
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND COLUMN_NAME = 'cover_image';
