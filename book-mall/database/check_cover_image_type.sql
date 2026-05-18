-- ============================================
-- 验证脚本：检查 cover_image 字段的当前类型
-- ============================================

-- 查看 book 表的 cover_image 字段详情
DESCRIBE book cover_image;

-- 查看 book 表的完整结构
SHOW CREATE TABLE book;

-- 查看所有包含 cover_image 字段的表及其类型
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND COLUMN_NAME = 'cover_image';
