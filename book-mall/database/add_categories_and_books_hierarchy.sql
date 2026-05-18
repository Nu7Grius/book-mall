-- ============================================
-- 图书商城系统 - 一二级分类图书数据脚本
-- 包含完整的一二级分类结构和图书数据
-- ============================================

USE book_mall;

-- ============================================
-- 1. 添加一级分类
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '计算机', 0, 1, 2 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '计算机' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '文学', 0, 1, 3 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '文学' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '历史', 0, 1, 4 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '历史' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '经济管理', 0, 1, 5 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '经济管理' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '儿童文学', 0, 1, 6 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '儿童文学' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '艺术', 0, 1, 7 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '艺术' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '心理学', 0, 1, 8 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '心理学' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '哲学', 0, 1, 9 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '哲学' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '医学', 0, 1, 10 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '医学' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '教育', 0, 1, 11 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '教育' AND parent_id = 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '科技', 0, 1, 12 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '科技' AND parent_id = 0);

-- ============================================
-- 2. 添加二级分类（计算机）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '编程语言', (SELECT id FROM (SELECT id FROM category WHERE category_name = '计算机' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '编程语言' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '数据库', (SELECT id FROM (SELECT id FROM category WHERE category_name = '计算机' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '数据库' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '人工智能', (SELECT id FROM (SELECT id FROM category WHERE category_name = '计算机' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '人工智能' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '前端开发', (SELECT id FROM (SELECT id FROM category WHERE category_name = '计算机' AND parent_id = 0 LIMIT 1) AS t), 2, 4
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '前端开发' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '后端架构', (SELECT id FROM (SELECT id FROM category WHERE category_name = '计算机' AND parent_id = 0 LIMIT 1) AS t), 2, 5
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '后端架构' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '网络与安全', (SELECT id FROM (SELECT id FROM category WHERE category_name = '计算机' AND parent_id = 0 LIMIT 1) AS t), 2, 6
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '网络与安全' AND parent_id != 0);

-- ============================================
-- 3. 添加二级分类（文学）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '小说', (SELECT id FROM (SELECT id FROM category WHERE category_name = '文学' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '小说' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '诗歌', (SELECT id FROM (SELECT id FROM category WHERE category_name = '文学' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '诗歌' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '散文', (SELECT id FROM (SELECT id FROM category WHERE category_name = '文学' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '散文' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '外国文学', (SELECT id FROM (SELECT id FROM category WHERE category_name = '文学' AND parent_id = 0 LIMIT 1) AS t), 2, 4
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '外国文学' AND parent_id != 0);

-- ============================================
-- 4. 添加二级分类（历史）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '中国历史', (SELECT id FROM (SELECT id FROM category WHERE category_name = '历史' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '中国历史' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '世界历史', (SELECT id FROM (SELECT id FROM category WHERE category_name = '历史' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '世界历史' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '历史人物传记', (SELECT id FROM (SELECT id FROM category WHERE category_name = '历史' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '历史人物传记' AND parent_id != 0);

-- ============================================
-- 5. 添加二级分类（经济管理）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '管理学', (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济管理' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '管理学' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '投资理财', (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济管理' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '投资理财' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '经济学基础', (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济管理' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '经济学基础' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '市场营销', (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济管理' AND parent_id = 0 LIMIT 1) AS t), 2, 4
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '市场营销' AND parent_id != 0);

-- ============================================
-- 6. 添加二级分类（儿童文学）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '儿童绘本', (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '儿童绘本' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '儿童文学', (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '儿童文学' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '益智游戏', (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '益智游戏' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '科普百科', (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id = 0 LIMIT 1) AS t), 2, 4
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '科普百科' AND parent_id != 0);

-- ============================================
-- 7. 添加二级分类（艺术）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '绘画', (SELECT id FROM (SELECT id FROM category WHERE category_name = '艺术' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '绘画' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '摄影', (SELECT id FROM (SELECT id FROM category WHERE category_name = '艺术' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '摄影' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '设计', (SELECT id FROM (SELECT id FROM category WHERE category_name = '艺术' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '设计' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '书法', (SELECT id FROM (SELECT id FROM category WHERE category_name = '艺术' AND parent_id = 0 LIMIT 1) AS t), 2, 4
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '书法' AND parent_id != 0);

-- ============================================
-- 8. 添加二级分类（心理学）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '大众心理学', (SELECT id FROM (SELECT id FROM category WHERE category_name = '心理学' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '大众心理学' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '社会心理学', (SELECT id FROM (SELECT id FROM category WHERE category_name = '心理学' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '社会心理学' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '心理咨询', (SELECT id FROM (SELECT id FROM category WHERE category_name = '心理学' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '心理咨询' AND parent_id != 0);

-- ============================================
-- 9. 添加二级分类（哲学）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '中国哲学', (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '中国哲学' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '西方哲学', (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '西方哲学' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '哲学入门', (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '哲学入门' AND parent_id != 0);

-- ============================================
-- 10. 添加二级分类（医学）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '中医', (SELECT id FROM (SELECT id FROM category WHERE category_name = '医学' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '中医' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '西医', (SELECT id FROM (SELECT id FROM category WHERE category_name = '医学' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '西医' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '养生保健', (SELECT id FROM (SELECT id FROM category WHERE category_name = '医学' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '养生保健' AND parent_id != 0);

-- ============================================
-- 11. 添加二级分类（教育）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '中小学教辅', (SELECT id FROM (SELECT id FROM category WHERE category_name = '教育' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '中小学教辅' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '外语考试', (SELECT id FROM (SELECT id FROM category WHERE category_name = '教育' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '外语考试' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '职业技能', (SELECT id FROM (SELECT id FROM category WHERE category_name = '教育' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '职业技能' AND parent_id != 0);

-- ============================================
-- 12. 添加二级分类（科技）
-- ============================================

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '通信技术', (SELECT id FROM (SELECT id FROM category WHERE category_name = '科技' AND parent_id = 0 LIMIT 1) AS t), 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '通信技术' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '互联网', (SELECT id FROM (SELECT id FROM category WHERE category_name = '科技' AND parent_id = 0 LIMIT 1) AS t), 2, 2
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '互联网' AND parent_id != 0);

INSERT INTO category (category_name, parent_id, category_level, sort_order)
SELECT '科普读物', (SELECT id FROM (SELECT id FROM category WHERE category_name = '科技' AND parent_id = 0 LIMIT 1) AS t), 2, 3
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM category WHERE category_name = '科普读物' AND parent_id != 0);

-- ============================================
-- 13. 插入图书数据（计算机-编程语言）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Python编程从入门到精通第3版零基础学习Python开发实战教程书籍', '张晓平', '人民邮电出版社', 89.00, 150, 120, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/python.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Python编程从入门到精通第3版零基础学习Python开发实战教程书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Java核心技术卷I基础知识原书第12版Java编程思想入门经典', 'Cay S. Horstmann', '机械工业出版社', 119.00, 180, 95, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/java-core.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Java核心技术卷I基础知识原书第12版Java编程思想入门经典');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'JavaScript高级程序设计第4版Web前端开发经典教程书籍', 'Matt Frisbie', '人民邮电出版社', 99.00, 160, 88, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/javascript.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'JavaScript高级程序设计第4版Web前端开发经典教程书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'C++ Primer Plus第6版中文版C++编程入门经典教程书籍', 'Stephen Prata', '人民邮电出版社', 108.00, 120, 76, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/cpp-primer.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'C++ Primer Plus第6版中文版C++编程入门经典教程书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Go语言编程Go语言实战指南分布式系统开发教程书籍', '许式伟', '人民邮电出版社', 79.00, 140, 85, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/golang.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Go语言编程Go语言实战指南分布式系统开发教程书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Swift编程权威指南iOS开发实战教程苹果官方推荐书籍', 'Matthew Mathias', '东南大学出版社', 98.00, 110, 72, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/swift.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Swift编程权威指南iOS开发实战教程苹果官方推荐书籍');

-- ============================================
-- 14. 插入图书数据（计算机-数据库）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'MySQL必知必会数据库管理与查询优化实战教程书籍', 'Ben Forta', '人民邮电出版社', 29.00, 200, 156, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/mysql.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'MySQL必知必会数据库管理与查询优化实战教程书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Redis设计与实现内存数据库技术内幕实战指南书籍', '黄健宏', '人民邮电出版社', 79.00, 180, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/redis.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Redis设计与实现内存数据库技术内幕实战指南书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'MongoDB权威指南第3版NoSQL非关系型数据库实战', 'Kristina Chodorow', '人民邮电出版社', 69.00, 150, 112, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/mongodb.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'MongoDB权威指南第3版NoSQL非关系型数据库实战');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'PostgreSQL数据库技术内幕从原理到实践应用指南', 'Hannes Landeholm', '电子工业出版社', 118.00, 125, 88, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/postgresql.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'PostgreSQL数据库技术内幕从原理到实践应用指南');

-- ============================================
-- 15. 插入图书数据（计算机-人工智能）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '深度学习详解基于Python语言AI神经网络实战机器学习算法', 'Ian Goodfellow', '人民邮电出版社', 168.00, 140, 112, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/deep-learning.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '深度学习详解基于Python语言AI神经网络实战机器学习算法');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '机器学习实战基于Scikit-Learn和TensorFlow机器学习入门教程', 'Aurelien Geron', '人民邮电出版社', 119.00, 130, 98, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/ml.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '机器学习实战基于Scikit-Learn和TensorFlow机器学习入门教程');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Python神经网络编程深度学习入门教程人工智能实战', 'Tariq Rashid', '人民邮电出版社', 49.00, 160, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/neural-network.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Python神经网络编程深度学习入门教程人工智能实战');

-- ============================================
-- 16. 插入图书数据（计算机-前端开发）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Vue.js实战Vue3渐进式JavaScript框架开发教程', '梁灏', '人民邮电出版社', 89.00, 150, 118, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/vue.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Vue.js实战Vue3渐进式JavaScript框架开发教程');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'React进阶之路ReactHooksReactRouter前端框架实战', '阮一峰', '电子工业出版社', 79.00, 140, 105, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/react.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'React进阶之路ReactHooksReactRouter前端框架实战');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'TypeScript入门与进阶企业级应用开发实战教程', '陈广', '清华大学出版社', 88.00, 135, 95, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/typescript.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'TypeScript入门与进阶企业级应用开发实战教程');

-- ============================================
-- 17. 插入图书数据（计算机-后端架构）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Spring Boot实战SpringCloud微服务架构设计与实战', ' Craig Walls', '人民邮电出版社', 79.00, 145, 112, (SELECT id FROM (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/spring.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Spring Boot实战SpringCloud微服务架构设计与实战');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Docker容器化部署与Kubernetes集群管理实战DevOps指南', 'Kelvin Masterson', '人民邮电出版社', 98.00, 130, 96, (SELECT id FROM (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/docker.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Docker容器化部署与Kubernetes集群管理实战DevOps指南');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Node.js实战基于Express和MongoDB的Web应用开发', 'Mike Cantelon', '电子工业出版社', 69.00, 125, 88, (SELECT id FROM (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/nodejs.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Node.js实战基于Express和MongoDB的Web应用开发');

-- ============================================
-- 18. 插入图书数据（文学-小说）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '活着余华经典文学小说当代文学名著推荐书籍', '余华', '作家出版社', 28.00, 300, 250, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/live.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '活着余华经典文学小说当代文学名著推荐书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '三体全套刘慈欣科幻小说典藏版中国科幻文学里程碑之作', '刘慈欣', '重庆出版社', 168.00, 250, 205, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/three-body.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '三体全套刘慈欣科幻小说典藏版中国科幻文学里程碑之作');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '平凡的世界全三册路遥茅盾文学奖获奖作品经典小说', '路遥', '北京十月文艺出版社', 128.00, 220, 178, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/ordinary-world.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '平凡的世界全三册路遥茅盾文学奖获奖作品经典小说');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '白夜行东野圭吾日本文学悬疑推理小说日本文学经典', '东野圭吾', '南海出版公司', 48.00, 280, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/white-night.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '白夜行东野圭吾日本文学悬疑推理小说日本文学经典');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '解忧杂货店东野圭吾温情治愈系小说日本文学代表作', '东野圭吾', '南海出版公司', 45.00, 290, 235, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/worried-deli.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '解忧杂货店东野圭吾温情治愈系小说日本文学代表作');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '围城钱钟书经典文学小说城里的人想出去城外的人想进来', '钱钟书', '人民文学出版社', 38.00, 240, 192, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/siege.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '围城钱钟书经典文学小说城里的人想出去城外的人想进来');

-- ============================================
-- 19. 插入图书数据（文学-外国文学）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '百年孤独加西亚马尔克斯诺贝尔文学奖作品魔幻现实主义', '加西亚·马尔克斯', '南海出版公司', 55.00, 260, 208, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/century-lonely.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '百年孤独加西亚马尔克斯诺贝尔文学奖作品魔幻现实主义');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '追风筝的人卡勒德胡赛尼经典文学小说为你千千万万遍', '卡勒德·胡赛尼', '上海人民出版社', 36.00, 280, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/kite-runner.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '追风筝的人卡勒德胡赛尼经典文学小说为你千千万万遍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '挪威的森林村上春树日本文学经典爱情小说村上春树代表作', '村上春树', '上海译文出版社', 42.00, 250, 198, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/norwegian-forest.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '挪威的森林村上春树日本文学经典爱情小说村上春树代表作');

-- ============================================
-- 20. 插入图书数据（历史-中国历史）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '万历十五年黄仁宇明史研究中国历史学经典著作', '黄仁宇', '中华书局', 45.00, 200, 158, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/wanli-year.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '万历十五年黄仁宇明史研究中国历史学经典著作');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '明朝那些事儿当年明月趣味历史小说全套九册历史书籍', '当年明月', '北京联合出版公司', 298.00, 150, 118, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/ming-dynasty.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '明朝那些事儿当年明月趣味历史小说全套九册历史书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '中国历代政治得失钱穆国史九讲中国历史研究书籍', '钱穆', '九州出版社', 52.00, 170, 132, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/china-politics.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '中国历代政治得失钱穆国史九讲中国历史研究书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '半小时漫画中国史半小时漫画历史系列趣味历史读物', '二混子', '江苏凤凰文艺出版社', 49.00, 220, 175, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/comic-china.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '半小时漫画中国史半小时漫画历史系列趣味历史读物');

-- ============================================
-- 21. 插入图书数据（历史-世界历史）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '全球通史从史前到21世纪世界历史文明发展史书籍', '斯塔夫里阿诺斯', '北京大学出版社', 78.00, 180, 142, (SELECT id FROM (SELECT id FROM category WHERE category_name = '世界历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/global-history.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '全球通史从史前到21世纪世界历史文明发展史书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '人类简史从动物到上帝尤瓦尔赫拉利历史学巨著书籍', '尤瓦尔·赫拉利', '中信出版社', 68.00, 200, 160, (SELECT id FROM (SELECT id FROM category WHERE category_name = '世界历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/human-history.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '人类简史从动物到上帝尤瓦尔赫拉利历史学巨著书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '世界上下五千年全套世界历史文明发展史通史书籍', '崔慧', '北京联合出版公司', 88.00, 160, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '世界历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/world-5000.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '世界上下五千年全套世界历史文明发展史通史书籍');

-- ============================================
-- 22. 插入图书数据（经济管理-投资理财）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '富爸爸穷爸爸财商教育投资理财思维启蒙书籍推荐', '罗伯特·清崎', '四川人民出版社', 48.00, 320, 258, (SELECT id FROM (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/rich-dad.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '富爸爸穷爸爸财商教育投资理财思维启蒙书籍推荐');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '巴菲特致股东的信投资理念与价值投资实践指南书籍', '沃伦·巴菲特', '机械工业出版社', 78.00, 210, 168, (SELECT id FROM (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/buffett.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '巴菲特致股东的信投资理念与价值投资实践指南书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '小狗钱钱理财小白入门书籍亲子财商教育投资指南', '博多·舍费尔', '南海出版公司', 36.00, 280, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/dog-money.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '小狗钱钱理财小白入门书籍亲子财商教育投资指南');

-- ============================================
-- 23. 插入图书数据（经济管理-管理学）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '管理学第13版斯蒂芬罗宾斯管理学原理与方法经典书籍', 'Stephen Robbins', '中国人民大学出版社', 68.00, 200, 160, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/management.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '管理学第13版斯蒂芬罗宾斯管理学原理与方法经典书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '卓有成效的管理者德鲁克经典管理学著作珍藏版书籍', '彼得·德鲁克', '机械工业出版社', 48.00, 230, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/effective-manager.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '卓有成效的管理者德鲁克经典管理学著作珍藏版书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '原则瑞达利欧生活和工作管理原则成功学书籍', '瑞·达利欧', '中信出版社', 89.00, 195, 155, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/principles.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '原则瑞达利欧生活和工作管理原则成功学书籍');

-- ============================================
-- 24. 插入图书数据（儿童文学-儿童绘本）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '小王子圣埃克苏佩里儿童文学经典绘本双语版书籍', '安托万·德·圣埃克苏佩里', '人民文学出版社', 32.00, 320, 258, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/little-prince.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '小王子圣埃克苏佩里儿童文学经典绘本双语版书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '猜猜我有多爱你儿童绘本亲子阅读情商启蒙图画书', '山姆·麦克布雷尼', '明天出版社', 28.00, 300, 240, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/guess-love.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '猜猜我有多爱你儿童绘本亲子阅读情商启蒙图画书');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '我爸爸我妈妈全套安东尼布朗经典绘本儿童图画书', '安东尼·布朗', '启发绘本', 58.00, 280, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/dad-mom.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '我爸爸我妈妈全套安东尼布朗经典绘本儿童图画书');

-- ============================================
-- 25. 插入图书数据（儿童文学-儿童文学）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '窗边的小豆豆黑柳彻子儿童成长教育经典小说书籍', '黑柳彻子', '南海出版公司', 35.00, 310, 248, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/koko.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '窗边的小豆豆黑柳彻子儿童成长教育经典小说书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '草房子曹文轩儿童文学小说国际安徒生奖获奖作品书籍', '曹文轩', '江苏凤凰少年儿童出版社', 36.00, 280, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/straw-house.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '草房子曹文轩儿童文学小说国际安徒生奖获奖作品书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '狼王梦沈石溪动物小说儿童文学经典作品书籍', '沈石溪', '浙江少年儿童出版社', 32.00, 290, 232, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/wolf-dream.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '狼王梦沈石溪动物小说儿童文学经典作品书籍');

-- ============================================
-- 26. 插入图书数据（心理学-大众心理学）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '自卑与超越阿德勒心理学经典个体心理学著作书籍', '阿尔弗雷德·阿德勒', '商务印书馆', 38.00, 280, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/inferiority.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '自卑与超越阿德勒心理学经典个体心理学著作书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '乌合之众群体心理研究大众心理研究经典著作书籍', '古斯塔夫·勒庞', '民主与建设出版社', 32.00, 300, 240, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/mob.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '乌合之众群体心理研究大众心理研究经典著作书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '蛤蟆先生去看心理医生心理学自我疗愈入门书籍', '罗伯特·戴博德', '天津人民出版社', 38.00, 320, 256, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/toad.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '蛤蟆先生去看心理医生心理学自我疗愈入门书籍');

-- ============================================
-- 27. 插入图书数据（心理学-社会心理学）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '社会心理学戴维迈尔斯第9版社会认知与人际关系书籍', 'David Myers', '人民邮电出版社', 88.00, 190, 152, (SELECT id FROM (SELECT id FROM category WHERE category_name = '社会心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/social-psychology.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '社会心理学戴维迈尔斯第9版社会认知与人际关系书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '思考快与慢丹尼尔卡尼曼行为经济学诺贝尔经济学奖书籍', 'Daniel Kahneman', '中信出版社', 58.00, 240, 192, (SELECT id FROM (SELECT id FROM category WHERE category_name = '社会心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/think-fast.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '思考快与慢丹尼尔卡尼曼行为经济学诺贝尔经济学奖书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '亲密关系通往灵魂的桥梁心理学情感自助书籍推荐', '罗兰·米勒', '人民邮电出版社', 68.00, 220, 175, (SELECT id FROM (SELECT id FROM category WHERE category_name = '社会心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/intimate.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '亲密关系通往灵魂的桥梁心理学情感自助书籍推荐');

-- ============================================
-- 28. 插入图书数据（哲学-中国哲学）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '中国哲学简史冯友兰中国哲学思想入门导读书籍', '冯友兰', '北京大学出版社', 42.00, 220, 175, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国哲学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/chinese-philosophy.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '中国哲学简史冯友兰中国哲学思想入门导读书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '老子他说南怀瑾讲述道德经道家思想解读书籍', '南怀瑾', '复旦大学出版社', 45.00, 200, 160, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国哲学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/laozi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '老子他说南怀瑾讲述道德经道家思想解读书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '庄子浅说陈鼓应解读逍遥游齐物论道家哲学书籍', '陈鼓应', '商务印书馆', 38.00, 190, 152, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国哲学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/zhuangzi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '庄子浅说陈鼓应解读逍遥游齐物论道家哲学书籍');

-- ============================================
-- 29. 插入图书数据（哲学-西方哲学）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '西方哲学史罗素西方哲学思想发展历程经典书籍', '伯特兰·罗素', '商务印书馆', 68.00, 185, 148, (SELECT id FROM (SELECT id FROM category WHERE category_name = '西方哲学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/western-philosophy.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '西方哲学史罗素西方哲学思想发展历程经典书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '理想国柏拉图古希腊哲学经典政治哲学著作书籍', '柏拉图', '商务印书馆', 35.00, 200, 160, (SELECT id FROM (SELECT id FROM category WHERE category_name = '西方哲学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/republic.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '理想国柏拉图古希腊哲学经典政治哲学著作书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '尼采文集悲剧的诞生查拉图斯特拉如是说珍藏版', '弗里德里希·尼采', '上海文化出版社', 88.00, 160, 128, (SELECT id FROM (SELECT id FROM category WHERE category_name = '西方哲学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/nietzsche.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '尼采文集悲剧的诞生查拉图斯特拉如是说珍藏版');

-- ============================================
-- 30. 插入图书数据（医学-中医）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '黄帝内经养生智慧中医养生保健经典指南书籍', '徐文兵', '江西科学技术出版社', 48.00, 270, 215, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中医' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/huangdi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '黄帝内经养生智慧中医养生保健经典指南书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '本草纲目李时珍中医中药学经典著作白话版书籍', '李时珍', '人民卫生出版社', 98.00, 150, 118, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中医' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/bencao.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '本草纲目李时珍中医中药学经典著作白话版书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '人体使用手册吴清忠中医养生经络穴位保健书籍', '吴清忠', '上海交通大学出版社', 42.00, 240, 192, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中医' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/body-manual.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '人体使用手册吴清忠中医养生经络穴位保健书籍');

-- ============================================
-- 31. 插入图书数据（教育-外语考试）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '新概念英语第一册英语入门教材同步练习册书籍', 'L.G. Alexander', '外语教学与研究出版社', 42.00, 350, 280, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外语考试' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/new-concept.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '新概念英语第一册英语入门教材同步练习册书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '新东方雅思词汇词根联想记忆法乱序版俞敏洪书籍', '俞敏洪', '群言出版社', 58.00, 280, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外语考试' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/ielts.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '新东方雅思词汇词根联想记忆法乱序版俞敏洪书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '英语四六级历年真题卷cet4cet6级考试用书推荐', '王长喜', '高等教育出版社', 38.00, 320, 256, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外语考试' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/cet46.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '英语四六级历年真题卷cet4cet6级考试用书推荐');

-- ============================================
-- 32. 插入图书数据（艺术-设计）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '零基础学Photoshop CC图像处理设计从入门到精通书籍', '锐艺视觉', '人民邮电出版社', 78.00, 210, 168, (SELECT id FROM (SELECT id FROM category WHERE category_name = '设计' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/photoshop.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '零基础学Photoshop CC图像处理设计从入门到精通书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '配色设计原理设计师色彩搭配实践指南书籍推荐', '内藤裕史', '中国青年出版社', 48.00, 190, 152, (SELECT id FROM (SELECT id FROM category WHERE category_name = '设计' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/color.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '配色设计原理设计师色彩搭配实践指南书籍推荐');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '版式设计原理设计师平面设计实践教程书籍推荐', '佐佐木刚士', '中国青年出版社', 52.00, 175, 138, (SELECT id FROM (SELECT id FROM category WHERE category_name = '设计' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/layout.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '版式设计原理设计师平面设计实践教程书籍推荐');

-- ============================================
-- 33. 插入图书数据（科技-通信技术）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '5G移动通信技术从原理到网络架构实战应用书籍', '李正茂', '人民邮电出版社', 98.00, 150, 118, (SELECT id FROM (SELECT id FROM category WHERE category_name = '通信技术' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/5g.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '5G移动通信技术从原理到网络架构实战应用书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '区块链技术原理与实战应用开发指南2024年新版书籍', '徐明星', '中信出版社', 88.00, 170, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '通信技术' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/blockchain.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '区块链技术原理与实战应用开发指南2024年新版书籍');

-- ============================================
-- 34. 插入图书数据（科技-互联网）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '物联网IoT智能家居工业互联网应用实战开发书籍', '王志良', '机械工业出版社', 85.00, 160, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '互联网' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/iot.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '物联网IoT智能家居工业互联网应用实战开发书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '大数据技术概论HadoopSpark数据处理实战教程书籍', '林子雨', '清华大学出版社', 75.00, 170, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '互联网' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/bigdata.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '大数据技术概论HadoopSpark数据处理实战教程书籍');

-- ============================================
-- 数据验证查询
-- ============================================
SELECT '一二级分类图书数据插入完成！' AS message;
SELECT COUNT(*) AS total_books FROM book;
SELECT COUNT(*) AS total_categories FROM category;
SELECT '一级分类:' AS info;
SELECT id, category_name, parent_id FROM category WHERE parent_id = 0 ORDER BY sort_order;
SELECT '二级分类示例:' AS info;
SELECT c.category_name AS parent_name, sc.category_name AS sub_name
FROM category c
JOIN category sc ON c.id = sc.parent_id
WHERE c.parent_id = 0
ORDER BY c.sort_order, sc.sort_order
LIMIT 20;
