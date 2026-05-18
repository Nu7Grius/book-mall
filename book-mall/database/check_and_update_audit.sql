-- 检查book表的审核字段是否存在
DESCRIBE book;

-- 为现有图书设置默认审核状态（假设已有图书都是审核通过的）
UPDATE book SET audit_status = 1 WHERE audit_status IS NULL;

-- 检查索引是否存在，如果不存在则创建
-- CREATE INDEX idx_book_audit_status ON book(audit_status);
-- CREATE INDEX idx_book_merchant_id ON book(merchant_id);
