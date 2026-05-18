-- ================================================
-- 整理分类表数据，重新排序ID从1开始
-- ================================================

-- 1. 查看当前分类数据
SELECT id, category_name, category_level, parent_id, sort_order
FROM category
ORDER BY id;

-- 2. 创建临时表保存分类数据（不包括ID）
CREATE TEMPORARY TABLE temp_category (
    category_name VARCHAR(100),
    category_level INT,
    parent_id BIGINT,
    sort_order INT,
    create_time DATETIME,
    update_time DATETIME
);

-- 3. 备份当前分类数据到临时表
INSERT INTO temp_category (category_name, category_level, parent_id, sort_order, create_time, update_time)
SELECT category_name, category_level, parent_id, sort_order, create_time, update_time
FROM category
ORDER BY category_level, sort_order, id;

-- 4. 清空分类表
TRUNCATE TABLE category;

-- 5. 重新插入分类数据（自动生成ID从1开始）
INSERT INTO category (category_name, category_level, parent_id, sort_order, create_time, update_time)
SELECT category_name, category_level, parent_id, sort_order, create_time, update_time
FROM temp_category;

-- 6. 删除临时表
DROP TEMPORARY TABLE temp_category;

-- 7. 查看重新排序后的分类数据
SELECT id, category_name, category_level, parent_id, sort_order
FROM category
ORDER BY id;
