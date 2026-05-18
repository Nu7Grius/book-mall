-- 注意：如果字段已经存在，跳过前4行ALTER TABLE语句
-- 只需执行以下语句

-- 为现有图书设置默认审核状态（假设已有图书都是审核通过的）
UPDATE book SET audit_status = 1 WHERE audit_status IS NULL;

-- 如果上面的语句报错，使用这个带LIMIT的版本
-- UPDATE book SET audit_status = 1 WHERE id > 0 LIMIT 100000;
