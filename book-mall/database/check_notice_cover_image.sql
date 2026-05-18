-- 修复 notice 表的 cover_image 字段类型
-- 问题原因：前端使用 Base64 上传图片，Base64 编码会增加约 33% 的大小
-- TEXT 类型最大只能存储 65535 字节，MEDIUMTEXT 可以存储 16MB
-- 这和之前图书封面图片的问题一样

ALTER TABLE notice
MODIFY COLUMN cover_image MEDIUMTEXT COMMENT '封面图片URL';

-- 验证修改结果
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND COLUMN_NAME = 'cover_image';
