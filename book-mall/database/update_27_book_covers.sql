-- ============================================
-- 更新图书封面路径脚本
-- 将下载的27本书的封面图片路径填入book表的cover_image字段
-- 执行前请确保已经运行了数据库初始化脚本
-- ============================================

USE book_mall;

-- 临时关闭安全更新模式（允许没有KEY列的UPDATE）
SET SQL_SAFE_UPDATES = 0;

-- ============================================
-- 更新已下载封面的书籍（27本）
-- ============================================

-- 1. C++ Primer Plus
UPDATE book 
SET cover_image = '/uploads/2026-05-06/C++ Primer Plus.jpg' 
WHERE book_name LIKE '%C++ Primer Plus%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 2. Node.js实战
UPDATE book 
SET cover_image = '/uploads/2026-05-06/Node.js实战.jpg' 
WHERE book_name LIKE '%Node.js实战%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 3. PostgreSQL数据库
UPDATE book 
SET cover_image = '/uploads/2026-05-06/PostgreSQL数据库.jpg' 
WHERE book_name LIKE '%PostgreSQL数据库%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 4. Swift编程权威指南
UPDATE book 
SET cover_image = '/uploads/2026-05-06/Swift编程权威指南.jpg' 
WHERE book_name LIKE '%Swift编程权威指南%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 5. TypeScript入门与进阶
UPDATE book 
SET cover_image = '/uploads/2026-05-06/TypeScript入门与进阶.jpg' 
WHERE book_name LIKE '%TypeScript入门与进阶%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 6. Vue.js实战
UPDATE book 
SET cover_image = '/uploads/2026-05-06/Vue.js实战.jpg' 
WHERE book_name LIKE '%Vue.js实战%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 7. python编程：从入门到实战
UPDATE book 
SET cover_image = '/uploads/2026-05-06/python编程：从入门到实战.jpg' 
WHERE book_name LIKE '%python编程%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 8. 三体
UPDATE book 
SET cover_image = '/uploads/2026-05-06/三体.jpg' 
WHERE book_name LIKE '%三体%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 9. 世界上下五千年
UPDATE book 
SET cover_image = '/uploads/2026-05-06/世界上下五千年.jpg' 
WHERE book_name LIKE '%世界上下五千年%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 10. 中国历代政治得失
UPDATE book 
SET cover_image = '/uploads/2026-05-06/中国历代政治得失.jpg' 
WHERE book_name LIKE '%中国历代政治得失%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 11. 宏观经济学
UPDATE book 
SET cover_image = '/uploads/2026-05-06/宏观经济学.jpg' 
WHERE book_name LIKE '%宏观经济学%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 12. 小王子
UPDATE book 
SET cover_image = '/uploads/2026-05-06/小王子.jpg' 
WHERE book_name LIKE '%小王子%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 13. 尼采
UPDATE book 
SET cover_image = '/uploads/2026-05-06/尼采.jpg' 
WHERE book_name LIKE '%尼采%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 14. 巴菲特致股东的信
UPDATE book 
SET cover_image = '/uploads/2026-05-06/巴菲特致股东的信.jpg' 
WHERE book_name LIKE '%巴菲特致股东的信%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 15. 微观经济学
UPDATE book 
SET cover_image = '/uploads/2026-05-06/微观经济学.jpg' 
WHERE book_name LIKE '%微观经济学%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 16. 机器学习实战
UPDATE book 
SET cover_image = '/uploads/2026-05-06/机器学习实战.jpg' 
WHERE book_name LIKE '%机器学习实战%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 17. 活着
UPDATE book 
SET cover_image = '/uploads/2026-05-06/活着.jpg' 
WHERE book_name LIKE '%活着%' AND book_name LIKE '%余华%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 18. 理想国
UPDATE book 
SET cover_image = '/uploads/2026-05-06/理想国.jpg' 
WHERE book_name LIKE '%理想国%' AND book_name LIKE '%柏拉图%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 19. 白夜行
UPDATE book 
SET cover_image = '/uploads/2026-05-06/白夜行.jpg' 
WHERE book_name LIKE '%白夜行%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 20. 百年孤独
UPDATE book 
SET cover_image = '/uploads/2026-05-06/百年孤独.jpg' 
WHERE book_name LIKE '%百年孤独%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 21. 社会心理学
UPDATE book 
SET cover_image = '/uploads/2026-05-06/社会心理学.jpg' 
WHERE book_name LIKE '%社会心理学%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 22. 管理学
UPDATE book 
SET cover_image = '/uploads/2026-05-06/管理学.jpg' 
WHERE book_name LIKE '%管理学%' AND book_name LIKE '%罗宾斯%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 23. 经济学原理
UPDATE book 
SET cover_image = '/uploads/2026-05-06/经济学原理.jpg' 
WHERE book_name LIKE '%经济学原理%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 24. 自卑与超越
UPDATE book 
SET cover_image = '/uploads/2026-05-06/自卑与超越.jpg' 
WHERE book_name LIKE '%自卑与超越%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 25. 草房子
UPDATE book 
SET cover_image = '/uploads/2026-05-06/草房子.jpg' 
WHERE book_name LIKE '%草房子%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 26. 雅思词汇
UPDATE book 
SET cover_image = '/uploads/2026-05-06/雅思词汇.jpg' 
WHERE book_name LIKE '%雅思词汇%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 27. 黄帝内经
UPDATE book 
SET cover_image = '/uploads/2026-05-06/黄帝内经.jpg' 
WHERE book_name LIKE '%黄帝内经%' AND (cover_image IS NULL OR cover_image = '' OR cover_image LIKE '/images/books/%');

-- 重新开启安全更新模式
SET SQL_SAFE_UPDATES = 1;

-- ============================================
-- 验证更新结果
-- ============================================

SELECT id, book_name, cover_image 
FROM book 
WHERE cover_image LIKE '/uploads/2026-05-06/%' 
ORDER BY id;

-- 输出更新统计
SELECT COUNT(*) AS updated_count 
FROM book 
WHERE cover_image LIKE '/uploads/2026-05-06/%';
