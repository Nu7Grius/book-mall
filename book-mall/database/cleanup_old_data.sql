-- ============================================
-- 清理脚本：删除之前添加的分类和图书数据
-- 用于重置数据后重新执行新的分类脚本
-- ============================================

USE book_mall;

-- 关闭安全模式（允许不带WHERE条件的DELETE）
SET SQL_SAFE_UPDATES = 0;

-- 0. 清空所有引用book表的子表（解除外键关联）
DELETE FROM order_item;          -- 订单明细表
DELETE FROM book_comment;        -- 图书评论表
DELETE FROM book_favorite;       -- 图书收藏表
DELETE FROM cart;               -- 购物车表

-- 1. 先删除所有图书（解除外键关联）
DELETE FROM book;

-- 2. 删除所有二级分类
DELETE FROM category WHERE parent_id != 0;

-- 3. 删除一级分类（除了初始的文学和计算机和历史）
DELETE FROM category WHERE parent_id = 0 AND category_name NOT IN ('文学', '计算机', '历史');

-- 重新开启安全模式
SET SQL_SAFE_UPDATES = 1;

-- ============================================
-- 验证清理结果
-- ============================================
SELECT '分类数据：' AS info;
SELECT id, category_name, parent_id, category_level FROM category ORDER BY parent_id, sort_order;

SELECT '图书数据：' AS info;
SELECT id, book_name, category_id FROM book ORDER BY id;
