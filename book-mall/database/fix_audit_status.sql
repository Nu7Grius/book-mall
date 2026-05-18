-- ============================================
-- 修复SQL：只将新加入的书籍设置为待审核状态
-- ============================================

USE book_mall;

-- 1. 查看所有书籍的审核状态
SELECT id, book_name, audit_status, status, create_time
FROM book
ORDER BY id DESC
LIMIT 30;

-- 2. 只将今天添加的书籍（2026-05-07）设为待审核状态
-- 注意：这里用日期来区分新书，只更新今天的书籍
UPDATE book SET audit_status = 0
WHERE DATE(create_time) = '2026-05-07'
AND (audit_status IS NULL OR audit_status = 1);

-- 3. 如果没有日期匹配，可以用ID范围（假设ID大于某个值是新书）
-- 请根据实际情况调整这个ID值
-- UPDATE book SET audit_status = 0 WHERE id > 50 AND audit_status = 1;

-- 4. 确认修改结果
SELECT
    '修复后统计：' AS info,
    SUM(CASE WHEN audit_status = 0 THEN 1 ELSE 0 END) AS 待审核,
    SUM(CASE WHEN audit_status = 1 THEN 1 ELSE 0 END) AS 已审核,
    SUM(CASE WHEN audit_status = 2 THEN 1 ELSE 0 END) AS 已拒绝,
    COUNT(*) AS 总数
FROM book;
