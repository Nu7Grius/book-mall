-- ============================================
-- 图书商城系统 - 补充76本图书数据
-- 这些书基于 download_book_covers_v14_final.py 脚本的书单
-- 书名经过优化，更容易被 Hardcover + Open Library + Google Books API 识别
-- 执行前请确保已运行数据库初始化脚本
-- 执行前请先运行下载脚本下载这76本书的封面图片
-- ============================================

USE book_mall;

-- ============================================
-- 计算机类图书（15本）
-- ============================================

-- 计算机-编程语言（5本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Python编程从入门到精通', '张晓平', '人民邮电出版社', 89.00, 150, 120, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/Python编程从入门到精通.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Python编程从入门到精通');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Java核心技术', 'Cay S. Horstmann', '机械工业出版社', 119.00, 180, 95, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/Java核心技术.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Java核心技术');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'JavaScript高级程序设计', 'Matt Frisbie', '人民邮电出版社', 99.00, 160, 88, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/JavaScript高级程序设计.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'JavaScript高级程序设计');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'C++ Primer Plus', 'Stephen Prata', '人民邮电出版社', 108.00, 120, 76, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/C++ Primer Plus.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'C++ Primer Plus');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Go语言编程', '许式伟', '人民邮电出版社', 79.00, 140, 85, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/Go语言编程.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Go语言编程');

-- 计算机-数据库（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'MySQL必知必会', 'Ben Forta', '人民邮电出版社', 29.00, 200, 156, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/MySQL必知必会.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'MySQL必知必会');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Redis设计与实现', '黄健宏', '人民邮电出版社', 79.00, 180, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/Redis设计与实现.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Redis设计与实现');

-- 计算机-人工智能（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '深度学习', 'Ian Goodfellow', '人民邮电出版社', 128.00, 150, 110, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/深度学习.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '深度学习');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '机器学习实战', 'Peter Harrington', '人民邮电出版社', 79.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/机器学习实战.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '机器学习实战');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Python神经网络编程', 'Tariq Rashid', '人民邮电出版社', 49.00, 140, 98, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/Python神经网络编程.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Python神经网络编程');

-- 计算机-前端开发（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Vue.js实战', '梁灏', '人民邮电出版社', 79.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/Vue.js实战.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Vue.js实战');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'React进阶之路', '阮一峰', '电子工业出版社', 89.00, 150, 132, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/React进阶之路.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'React进阶之路');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'TypeScript入门与进阶', 'Steve Fenton', '人民邮电出版社', 69.00, 160, 118, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/TypeScript入门与进阶.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'TypeScript入门与进阶');

-- 计算机-后端架构（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Spring Boot实战', 'Craig Walls', '人民邮电出版社', 79.00, 180, 155, (SELECT id FROM (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/Spring Boot实战.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Spring Boot实战');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Docker容器化', 'Dieter Koch', '人民邮电出版社', 59.00, 170, 142, (SELECT id FROM (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/Docker容器化.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Docker容器化');

-- ============================================
-- 文学类图书（12本）
-- ============================================

-- 文学-小说（4本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '活着', '余华', '作家出版社', 38.00, 300, 285, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/活着.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '活着');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '三体', '刘慈欣', '重庆出版社', 58.00, 280, 268, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/三体.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '三体');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '平凡的世界', '路遥', '人民文学出版社', 98.00, 250, 232, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/平凡的世界.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '平凡的世界');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '白夜行', '东野圭吾', '南海出版公司', 39.00, 260, 245, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/白夜行.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '白夜行');

-- 文学-散文（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '围城', '钱钟书', '人民文学出版社', 35.00, 240, 228, (SELECT id FROM (SELECT id FROM category WHERE category_name = '散文' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/围城.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '围城');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '解忧杂货店', '东野圭吾', '南海出版公司', 39.00, 240, 228, (SELECT id FROM (SELECT id FROM category WHERE category_name = '散文' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/解忧杂货店.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '解忧杂货店');

-- 文学-外国文学（6本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '百年孤独', '加西亚·马尔克斯', '南海出版公司', 49.00, 280, 265, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/百年孤独.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '百年孤独');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '追风筝的人', '卡勒德·胡赛尼', '上海人民出版社', 38.00, 260, 245, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/追风筝的人.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '追风筝的人');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '挪威的森林', '村上春树', '上海译文出版社', 35.00, 250, 238, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/挪威的森林.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '挪威的森林');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '小王子', '圣-埃克苏佩里', '人民文学出版社', 28.00, 300, 285, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/小王子.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '小王子');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '月亮与六便士', '毛姆', '浙江文艺出版社', 39.00, 220, 205, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/月亮与六便士.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '月亮与六便士');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '了不起的盖茨比', 'F·S·菲茨杰拉德', '人民文学出版社', 32.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/了不起的盖茨比.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '了不起的盖茨比');

-- ============================================
-- 历史类图书（8本）
-- ============================================

-- 历史-中国历史（4本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '万历十五年', '黄仁宇', '中华书局', 42.00, 200, 182, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/万历十五年.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '万历十五年');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '明朝那些事儿', '当年明月', '北京联合出版公司', 198.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/明朝那些事儿.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '明朝那些事儿');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '中国历代政治得失', '钱穆', '九州出版社', 38.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/中国历代政治得失.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '中国历代政治得失');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '半小时漫画中国史', '二混子', '江苏凤凰文艺出版社', 48.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/半小时漫画中国史.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '半小时漫画中国史');

-- 历史-世界历史（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '全球通史', 'L.S.斯塔夫里阿诺斯', '北京大学出版社', 68.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '世界历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/全球通史.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '全球通史');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '人类简史', '尤瓦尔·赫拉利', '中信出版社', 68.00, 200, 188, (SELECT id FROM (SELECT id FROM category WHERE category_name = '世界历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/人类简史.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '人类简史');

-- 历史-历史人物传记（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '曾国藩传', '张宏杰', '民主与建设出版社', 58.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '历史人物传记' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/曾国藩传.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '曾国藩传');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '苏东坡传', '林语堂', '湖南文艺出版社', 42.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '历史人物传记' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/苏东坡传.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '苏东坡传');

-- ============================================
-- 经济管理类图书（10本）
-- ============================================

-- 经济管理-管理学（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '管理学', '周三多', '高等教育出版社', 45.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/管理学.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '管理学');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '卓有成效的管理者', '彼得·德鲁克', '机械工业出版社', 49.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/卓有成效的管理者.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '卓有成效的管理者');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '原则', '瑞·达利欧', '中信出版社', 98.00, 160, 148, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/原则.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '原则');

-- 经济管理-投资理财（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '富爸爸穷爸爸', '罗伯特·清崎', '四川人民出版社', 48.00, 220, 205, (SELECT id FROM (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/富爸爸穷爸爸.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '富爸爸穷爸爸');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '小狗钱钱', '博多·舍费尔', '南海出版公司', 39.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/小狗钱钱.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '小狗钱钱');

-- 经济管理-经济学基础（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '经济学原理', 'N·格里高利·曼昆', '北京大学出版社', 89.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济学基础' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/经济学原理.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '经济学原理');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '金融市场与机构', '弗雷德里克·米什金', '中国人民大学出版社', 75.00, 140, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济学基础' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/金融市场与机构.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '金融市场与机构');

-- 经济管理-市场营销（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '营销管理', '菲利普·科特勒', '中国人民大学出版社', 118.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '市场营销' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/营销管理.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '营销管理');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '竞争战略', '迈克尔·波特', '华夏出版社', 58.00, 140, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '市场营销' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/竞争战略.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '竞争战略');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '创新者的窘境', '克莱顿·克里斯坦森', '中信出版社', 48.00, 130, 115, (SELECT id FROM (SELECT id FROM category WHERE category_name = '市场营销' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/创新者的窘境.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '创新者的窘境');

-- ============================================
-- 儿童文学类图书（10本）
-- ============================================

-- 儿童文学-儿童绘本（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '猜猜我有多爱你', '山姆·麦克布雷尼', '明天出版社', 35.00, 250, 235, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/猜猜我有多爱你.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '猜猜我有多爱你');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '我爸爸我妈妈', '安东尼·布朗', '河北教育出版社', 76.00, 240, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/我爸爸我妈妈.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '我爸爸我妈妈');

-- 儿童文学-儿童文学（4本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '窗边的小豆豆', '黑柳彻子', '南海出版公司', 35.00, 220, 205, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/窗边的小豆豆.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '窗边的小豆豆');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '草房子', '曹文轩', '江苏少年儿童出版社', 32.00, 210, 195, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/草房子.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '草房子');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '狼王梦', '沈石溪', '浙江少年儿童出版社', 28.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/狼王梦.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '狼王梦');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '夏洛的网', 'E·B·怀特', '上海译文出版社', 28.00, 200, 188, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/夏洛的网.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '夏洛的网');

-- 儿童文学-科普百科（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '世界上下五千年', '丁志明', '北京联合出版公司', 58.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '科普百科' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/世界上下五千年.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '世界上下五千年');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '十万个为什么', '米伊林', '北京教育出版社', 68.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '科普百科' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/十万个为什么.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '十万个为什么');

-- 儿童文学-益智游戏（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '数独合订本', 'Nikoli', '人民邮电出版社', 28.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '益智游戏' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/数独合订本.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '数独合订本');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '儿童专注力训练游戏书', '小麒麟', '化学工业出版社', 38.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '益智游戏' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/儿童专注力训练游戏书.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '儿童专注力训练游戏书');

-- ============================================
-- 心理学类图书（8本）
-- ============================================

-- 心理学-大众心理学（4本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '自卑与超越', '阿尔弗雷德·阿德勒', '春风文艺出版社', 38.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/自卑与超越.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '自卑与超越');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '乌合之众', '古斯塔夫·勒庞', '中央编译出版社', 32.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/乌合之众.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '乌合之众');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '蛤蟆先生去看心理医生', '罗伯特·戴博德', '天津人民出版社', 38.00, 190, 175, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/蛤蟆先生去看心理医生.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '蛤蟆先生去看心理医生');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '思考快与慢', '丹尼尔·卡尼曼', '中信出版社', 58.00, 170, 155, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/思考快与慢.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '思考快与慢');

-- 心理学-社会心理学（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '社会心理学', '戴维·迈尔斯', '人民邮电出版社', 79.00, 150, 138, (SELECT id FROM (SELECT id FROM category WHERE category_name = '社会心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/社会心理学.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '社会心理学');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '亲密关系', '罗兰·米勒', '人民邮电出版社', 68.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '社会心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/亲密关系.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '亲密关系');

-- 心理学-心理咨询（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '为何家会伤人', '武志红', '北京联合出版公司', 42.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '心理咨询' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/为何家会伤人.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '为何家会伤人');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '被讨厌的勇气', '岸见一郎', '机械工业出版社', 42.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '心理咨询' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/被讨厌的勇气.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '被讨厌的勇气');

-- ============================================
-- 哲学类图书（6本）
-- ============================================

-- 哲学-哲学入门（6本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '中国哲学简史', '冯友兰', '北京大学出版社', 45.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学入门' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/中国哲学简史.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '中国哲学简史');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '老子', '老子', '中华书局', 28.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学入门' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/老子.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '老子');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '庄子', '庄周', '中华书局', 32.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学入门' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/庄子.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '庄子');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '西方哲学史', '伯特兰·罗素', '商务印书馆', 58.00, 140, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学入门' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/西方哲学史.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '西方哲学史');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '理想国', '柏拉图', '商务印书馆', 38.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学入门' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/理想国.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '理想国');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '尼采', '弗里德里希·尼采', '商务印书馆', 42.00, 130, 115, (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学入门' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/尼采.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '尼采');

-- ============================================
-- 医学类图书（2本）
-- ============================================

-- 医学-养生保健（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '黄帝内经', '徐文兵', '天津科学技术出版社', 68.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '养生保健' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/黄帝内经.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '黄帝内经');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '本草纲目', '李时珍', '人民卫生出版社', 88.00, 140, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '养生保健' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/本草纲目.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '本草纲目');

-- ============================================
-- 教育类图书（3本）
-- ============================================

-- 教育-中小学教辅（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '新概念英语', 'L.G.亚历山大', '外语教学与研究出版社', 45.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中小学教辅' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/新概念英语.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '新概念英语');

-- 教育-外语考试（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '雅思词汇', '胡敏', '中国广播电视出版社', 58.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外语考试' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/雅思词汇.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '雅思词汇');

-- 教育-职业技能（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '领导力', '约翰·麦克斯维尔', '文汇出版社', 39.00, 160, 142, (SELECT id FROM (SELECT id FROM category WHERE category_name = '职业技能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/领导力.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '领导力');

-- ============================================
-- 经济管理-补充（2本，用于达到76本总数）
-- ============================================

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '宏观经济学', 'N·格里高利·曼昆', '中国人民大学出版社', 65.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济学基础' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/宏观经济学.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '宏观经济学');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '微观经济学', 'N·格里高利·曼昆', '中国人民大学出版社', 65.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济学基础' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/uploads/2026-05-06/微观经济学.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '微观经济学');
