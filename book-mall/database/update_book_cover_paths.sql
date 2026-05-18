-- ============================================
-- 更新图书封面路径脚本
-- 将 /images/books/xxx.jpg 更新为 /uploads/2026-05-06/xxx.jpg
-- ============================================

USE book_mall;

-- 查看当前所有图书的封面路径
SELECT id, book_name, cover_image FROM book WHERE deleted = 0 LIMIT 10;

-- 批量更新封面路径（将 /images/books/ 替换为 /uploads/2026-05-06/）
UPDATE book 
SET cover_image = REPLACE(cover_image, '/images/books/', '/uploads/2026-05-06/')
WHERE cover_image LIKE '/images/books/%';

-- 验证更新结果
SELECT id, book_name, cover_image FROM book WHERE deleted = 0 LIMIT 10;

-- 输出更新统计
SELECT CONCAT('已更新 ', COUNT(*), ' 本图书的封面路径') AS result
FROM book
WHERE cover_image LIKE '/uploads/2026-05-06/%';
