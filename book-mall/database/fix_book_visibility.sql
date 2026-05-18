-- ============================================
-- 修复SQL：将所有书籍设为可显示状态
-- ============================================

USE book_mall;

-- 1. 查看所有书籍的状态
SELECT
    id,
    book_name,
    audit_status,
    CASE audit_status
        WHEN 0 THEN '待审核'
        WHEN 1 THEN '审核通过'
        WHEN 2 THEN '审核拒绝'
        ELSE '未知'
    END AS audit_status_name,
    status,
    CASE status
        WHEN 0 THEN '下架'
        WHEN 1 THEN '上架'
        ELSE '未知'
    END AS status_name
FROM book
ORDER BY id DESC
LIMIT 30;

-- 2. 将所有待审核的书籍设为审核通过
UPDATE book SET audit_status = 1 WHERE audit_status = 0;

-- 3. 将所有书籍设为上架状态
UPDATE book SET status = 1 WHERE status = 0;

-- 4. 确认修改后的状态
SELECT
    '修改后统计：' AS info,
    SUM(CASE WHEN audit_status = 1 THEN 1 ELSE 0 END) AS audit_passed,
    SUM(CASE WHEN audit_status = 0 THEN 1 ELSE 0 END) AS audit_pending,
    SUM(CASE WHEN audit_status = 2 THEN 1 ELSE 0 END) AS audit_rejected,
    SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS on_sale,
    SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS off_sale,
    COUNT(*) AS total
FROM book;
