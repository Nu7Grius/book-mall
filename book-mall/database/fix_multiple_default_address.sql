-- 修复每个用户只有一个默认地址
-- 对于每个用户，只保留ID最小的那个地址为默认，其他设为非默认
UPDATE address a
INNER JOIN (
    SELECT user_id, MIN(id) as min_id
    FROM address
    WHERE deleted = 0
    GROUP BY user_id
    HAVING COUNT(*) > 0
) b ON a.user_id = b.user_id
SET a.is_default = CASE WHEN a.id = b.min_id THEN 1 ELSE 0 END
WHERE a.deleted = 0;
