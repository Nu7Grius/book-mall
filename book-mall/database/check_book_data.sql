-- ============================================
-- 诊断SQL：检查书籍数据是否正确插入
-- ============================================

USE book_mall;

-- 1. 查看book表中的所有书籍
SELECT '1. book表中的书籍总数：' AS check_point, COUNT(*) AS total FROM book;

-- 2. 查看2026-05-07文件夹的书籍
SELECT '2. 2026-05-07文件夹的书籍：' AS check_point;
SELECT id, book_name, author, price, category_id, cover_image, status
FROM book 
WHERE cover_image LIKE '%uploads/2026-05-07%'
ORDER BY id;

-- 3. 检查category表中的分类是否存在
SELECT '3. category表中的二级分类：' AS check_point;
SELECT id, category_name, parent_id FROM category WHERE parent_id != 0 ORDER BY id;

-- 4. 检查是否有category_id为NULL的书籍
SELECT '4. category_id为NULL的书籍：' AS check_point;
SELECT id, book_name, category_id FROM book WHERE category_id IS NULL;

-- 5. 查看最新的20本书（可能是前端只显示前20本）
SELECT '5. 按ID倒序查看最新的20本书：' AS check_point;
SELECT id, book_name, author, price, category_id, cover_image, status
FROM book 
ORDER BY id DESC
LIMIT 20;

-- 6. 检查书籍状态
SELECT '6. 各状态的书籍数量：' AS check_point;
SELECT status, COUNT(*) AS count FROM book GROUP BY status;
