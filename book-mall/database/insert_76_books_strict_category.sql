-- ============================================
-- 图书商城系统 - 76本图书数据（按数据库实际分类结构）
-- ============================================

USE book_mall;

-- ============================================
-- 计算机类图书（20本）
-- ============================================

-- 计算机-编程语言（5本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Python编程从入门到精通第3版零基础学习Python开发实战', '张晓平', '人民邮电出版社', 89.00, 150, 120, (SELECT id FROM (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/python.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Python编程从入门到精通第3版零基础学习Python开发实战');

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

-- 计算机-数据库（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'MySQL必知必会数据库管理与查询优化实战教程书籍', 'Ben Forta', '人民邮电出版社', 29.00, 200, 156, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/mysql.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'MySQL必知必会数据库管理与查询优化实战教程书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Redis设计与实现内存数据库技术内幕实战指南书籍', '黄健宏', '人民邮电出版社', 79.00, 180, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/redis.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Redis设计与实现内存数据库技术内幕实战指南书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'MongoDB权威指南第3版NoSQL非关系型数据库实战', 'Kristina Chodorow', '人民邮电出版社', 69.00, 150, 112, (SELECT id FROM (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/mongodb.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'MongoDB权威指南第3版NoSQL非关系型数据库实战');

-- 计算机-人工智能（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '深度学习入门基于Python的理论与实现AI人工智能教程', '斋藤康毅', '人民邮电出版社', 59.00, 200, 180, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/deep-learning.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '深度学习入门基于Python的理论与实现AI人工智能教程');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '机器学习实战基于Scikit-Learn和TensorFlow机器学习算法', 'Aurelien Geron', '人民邮电出版社', 119.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/ml-action.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '机器学习实战基于Scikit-Learn和TensorFlow机器学习算法');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Python神经网络编程深度学习人工神经网络原理实战', 'Tariq Rashid', '人民邮电出版社', 49.00, 140, 98, (SELECT id FROM (SELECT id FROM category WHERE category_name = '人工智能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/neural-network.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Python神经网络编程深度学习人工神经网络原理实战');

-- 计算机-前端开发（4本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Vue.js实战Vue2Vue3框架学习Web前端开发教程书籍', '梁灏', '人民邮电出版社', 79.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/vuejs.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Vue.js实战Vue2Vue3框架学习Web前端开发教程书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'React进阶之路React16Redux技术栈Web前端开发', '阮一峰', '电子工业出版社', 89.00, 150, 132, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/react.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'React进阶之路React16Redux技术栈Web前端开发');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'CSS权威指南第4版Web前端开发样式布局设计教程', 'Eric A. Meyer', '中国电力出版社', 99.00, 120, 105, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/css-guide.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'CSS权威指南第4版Web前端开发样式布局设计教程');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'TypeScript入门与进阶Web前端开发TypeScript编程', 'Steve Fenton', '人民邮电出版社', 69.00, 160, 118, (SELECT id FROM (SELECT id FROM category WHERE category_name = '前端开发' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/typescript.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'TypeScript入门与进阶Web前端开发TypeScript编程');

-- 计算机-后端架构（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Spring Boot实战Spring框架企业级应用开发教程书籍', 'Craig Walls', '人民邮电出版社', 79.00, 180, 155, (SELECT id FROM (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/springboot.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Spring Boot实战Spring框架企业级应用开发教程书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Spring Cloud微服务架构实战分布式系统开发指南', '周喜平', '电子工业出版社', 89.00, 150, 128, (SELECT id FROM (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/springcloud.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Spring Cloud微服务架构实战分布式系统开发指南');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Docker容器技术实战容器化应用部署与管理指南', 'Dieter Koch', '人民邮电出版社', 59.00, 170, 142, (SELECT id FROM (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/docker.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Docker容器技术实战容器化应用部署与管理指南');

-- 计算机-网络与安全（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '计算机网络第7版谢希仁TCPIP协议原理与应用教程', '谢希仁', '电子工业出版社', 49.00, 200, 178, (SELECT id FROM (SELECT id FROM category WHERE category_name = '网络与安全' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/network.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '计算机网络第7版谢希仁TCPIP协议原理与应用教程');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'Web安全深度渗透测试网络安全技术书籍', '陈端兵', '机械工业出版社', 69.00, 140, 115, (SELECT id FROM (SELECT id FROM category WHERE category_name = '网络与安全' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/web-security.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'Web安全深度渗透测试网络安全技术书籍');

-- ============================================
-- 文学类图书（12本）
-- ============================================

-- 文学-小说（4本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '活着余华著经典小说文学读物感人至深的生命故事', '余华', '作家出版社', 38.00, 300, 285, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/huozhe.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '活着余华著经典小说文学读物感人至深的生命故事');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '平凡的世界全三册路遥茅盾文学奖获奖作品经典小说', '路遥', '人民文学出版社', 98.00, 250, 232, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/pingfan.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '平凡的世界全三册路遥茅盾文学奖获奖作品经典小说');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '白鹿原作者渭文学经典陈忠实矛盾文学奖获奖作品', '陈忠实', '人民文学出版社', 45.00, 220, 198, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/bailu.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '白鹿原作者渭文学经典陈忠实矛盾文学奖获奖作品');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '百年孤独加西亚马尔克斯诺贝尔文学奖经典世界名著', '加西亚·马尔克斯', '南海出版公司', 49.00, 280, 265, (SELECT id FROM (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/bainiangudum.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '百年孤独加西亚马尔克斯诺贝尔文学奖经典世界名著');

-- 文学-诗歌（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '唐诗三百首详注版中华传统文化经典诗词读物', '蘅塘退士', '中华书局', 32.00, 250, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '诗歌' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/tangshi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '唐诗三百首详注版中华传统文化经典诗词读物');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '毛泽东诗词集全解毛泽东诗词鉴赏红色经典读物', '中央文献出版社', '中央文献出版社', 68.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '诗歌' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/maozedong.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '毛泽东诗词集全解毛泽东诗词鉴赏红色经典读物');

-- 文学-散文（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '鲁迅散文集全集中学生课外文学经典读物书籍', '鲁迅', '人民文学出版社', 42.00, 220, 198, (SELECT id FROM (SELECT id FROM category WHERE category_name = '散文' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/luxun.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '鲁迅散文集全集中学生课外文学经典读物书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '朱自清散文集经典文学选集语文阅读理解课外读物', '朱自清', '作家出版社', 35.00, 200, 175, (SELECT id FROM (SELECT id FROM category WHERE category_name = '散文' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/zhuziqing.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '朱自清散文集经典文学选集语文阅读理解课外读物');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '林清玄散文集清欢人生当代文学经典散文读物书籍', '林清玄', '作家出版社', 38.00, 180, 158, (SELECT id FROM (SELECT id FROM category WHERE category_name = '散文' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/linqingxuan.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '林清玄散文集清欢人生当代文学经典散文读物书籍');

-- 文学-外国文学（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '追风筝的人胡塞尼著外国文学经典小说感动千万读者', '卡勒德·胡赛尼', '上海人民出版社', 38.00, 260, 245, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/zhuifeng.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '追风筝的人胡塞尼著外国文学经典小说感动千万读者');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '小王子法语原版中文译本经典儿童文学外国名著', '安托万·德·圣-埃克苏佩里', '人民文学出版社', 28.00, 300, 285, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/xiaowangzi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '小王子法语原版中文译本经典儿童文学外国名著');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '解忧杂货店东野圭吾日本文学小说温暖治愈系读物', '东野圭吾', '南海出版公司', 39.00, 240, 228, (SELECT id FROM (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/jieyou.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '解忧杂货店东野圭吾日本文学小说温暖治愈系读物');

-- ============================================
-- 历史类图书（8本）
-- ============================================

-- 历史-中国历史（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '明朝那些事儿当年明月全套9册中国历史通俗读物', '当年明月', '北京联合出版公司', 198.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/mingchao.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '明朝那些事儿当年明月全套9册中国历史通俗读物');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '万历十五年黄仁宇著明史研究历史学经典著作书籍', '黄仁宇', '中华书局', 42.00, 200, 182, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/wanli.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '万历十五年黄仁宇著明史研究历史学经典著作书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '如果历史是一群喵全套12册肥志历史漫画趣味读物', '肥志', '广东旅游出版社', 239.00, 150, 138, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中国历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/lishi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '如果历史是一群喵全套12册肥志历史漫画趣味读物');

-- 历史-世界历史（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '全球通史从史前文明到现代世界历史学经典著作', 'L.S.斯塔夫里阿诺斯', '北京大学出版社', 68.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '世界历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/quanqiu.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '全球通史从史前文明到现代世界历史学经典著作');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '人类简史从动物到上帝尤瓦尔赫拉利著世界历史读物', '尤瓦尔·赫拉利', '中信出版社', 68.00, 200, 188, (SELECT id FROM (SELECT id FROM category WHERE category_name = '世界历史' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/renlei.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '人类简史从动物到上帝尤瓦尔赫拉利著世界历史读物');

-- 历史-历史人物传记（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '曾国藩传张宏杰著晚清名臣传记历史人物书籍', '张宏杰', '民主与建设出版社', 58.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '历史人物传记' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/zengguofan.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '曾国藩传张宏杰著晚清名臣传记历史人物书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '苏东坡传林语堂著北宋文学家传记经典读物书籍', '林语堂', '湖南文艺出版社', 42.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '历史人物传记' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/sudongpo.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '苏东坡传林语堂著北宋文学家传记经典读物书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '毛泽东传外国学者写的毛泽东传记伟人传记书籍', '罗斯·特里尔', '中国人民大学出版社', 48.00, 170, 155, (SELECT id FROM (SELECT id FROM category WHERE category_name = '历史人物传记' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/maozhuxi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '毛泽东传外国学者写的毛泽东传记伟人传记书籍');

-- ============================================
-- 经济管理类图书（10本）
-- ============================================

-- 经济管理-管理学（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '卓有成效的管理者德鲁克管理学经典著作企业经营管理', '彼得·德鲁克', '机械工业出版社', 49.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/gls.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '卓有成效的管理者德鲁克管理学经典著作企业经营管理');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '领导力21法则约翰麦克斯维尔企业管理团队管理书籍', '约翰·麦克斯维尔', '文汇出版社', 39.00, 160, 142, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/lingdao.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '领导力21法则约翰麦克斯维尔企业管理团队管理书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '高效能人士的七个习惯史蒂芬柯维企业管理培训书籍', '史蒂芬·柯维', '中国青年出版社', 45.00, 180, 168, (SELECT id FROM (SELECT id FROM category WHERE category_name = '管理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/gaoxiao.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '高效能人士的七个习惯史蒂芬柯维企业管理培训书籍');

-- 经济管理-投资理财（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '富爸爸穷爸爸罗伯特清崎理财投资理财入门经典书籍', '罗伯特·清崎', '四川人民出版社', 48.00, 220, 205, (SELECT id FROM (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/fubaba.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '富爸爸穷爸爸罗伯特清崎理财投资理财入门经典书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '小狗钱钱博多舍费尔理财童话投资理财入门读物', '博多·舍费尔', '南海出版公司', 39.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/xiaogou.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '小狗钱钱博多舍费尔理财童话投资理财入门读物');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '巴菲特致股东的信投资理念理财投资经典书籍', '沃伦·巴菲特', '机械工业出版社', 68.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/buffett.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '巴菲特致股东的信投资理念理财投资经典书籍');

-- 经济管理-经济学基础（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '经济学原理曼昆宏观经济学微观经济学经典教材书籍', 'N.格里高利·曼昆', '北京大学出版社', 89.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济学基础' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/jingji.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '经济学原理曼昆宏观经济学微观经济学经典教材书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '牛奶可乐经济学罗伯特弗兰克通俗经济学入门书籍', '罗伯特·弗兰克', '中国人民大学出版社', 42.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '经济学基础' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/niunai.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '牛奶可乐经济学罗伯特弗兰克通俗经济学入门书籍');

-- 经济管理-市场营销（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '定位艾里斯杰克特劳特营销学经典市场定位理论书籍', '艾·里斯', '机械工业出版社', 58.00, 170, 152, (SELECT id FROM (SELECT id FROM category WHERE category_name = '市场营销' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/dingwei.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '定位艾里斯杰克特劳特营销学经典市场定位理论书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '影响力罗伯特西奥迪尼说服心理学营销技巧经典书籍', '罗伯特·西奥迪尼', '中国人民大学出版社', 68.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '市场营销' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/yingxiang.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '影响力罗伯特西奥迪尼说服心理学营销技巧经典书籍');

-- ============================================
-- 儿童文学类图书（12本）
-- ============================================

-- 儿童文学-儿童绘本（4本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '猜猜我有多爱你绘本儿童绘本亲子阅读图画书', '山姆·麦克布雷尼', '明天出版社', 35.00, 250, 235, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/caicai.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '猜猜我有多爱你绘本儿童绘本亲子阅读图画书');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '我爸爸绘本安徒生奖获得者安东尼布朗家庭亲情读物', '安东尼·布朗', '河北教育出版社', 38.00, 240, 225, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/baba.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '我爸爸绘本安徒生奖获得者安东尼布朗家庭亲情读物');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '好饿的毛毛虫绘本艾瑞卡尔儿童早期阅读图画书', '艾瑞·卡尔', '明天出版社', 32.00, 260, 248, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/maomaochong.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '好饿的毛毛虫绘本艾瑞卡尔儿童早期阅读图画书');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '逃家小兔绘本希尔弗斯坦儿童文学经典图画书', '玛格丽特·怀斯·布朗', '少年儿童出版社', 28.00, 230, 218, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童绘本' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/taojia.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '逃家小兔绘本希尔弗斯坦儿童文学经典图画书');

-- 儿童文学-儿童文学（4本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '窗边的小豆豆黑柳彻子儿童文学经典小说推荐阅读', '黑柳彻子', '南海出版公司', 35.00, 220, 205, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/xiaodoudou.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '窗边的小豆豆黑柳彻子儿童文学经典小说推荐阅读');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '夏洛的网怀特著儿童文学经典名著小学生课外阅读', 'E.B.怀特', '上海译文出版社', 28.00, 200, 188, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/xialuo.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '夏洛的网怀特著儿童文学经典名著小学生课外阅读');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '草房子曹文轩著儿童文学经典小说小学生课外读物', '曹文轩', '江苏少年儿童出版社', 32.00, 210, 195, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/caofangzi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '草房子曹文轩著儿童文学经典小说小学生课外读物');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '米小圈上学记全套米小圈脑筋急转弯儿童文学读物', '北猫', '四川少年儿童出版社', 120.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '儿童文学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/mixiaowan.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '米小圈上学记全套米小圈脑筋急转弯儿童文学读物');

-- 儿童文学-益智游戏（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '数独合订本初级入门儿童益智逻辑思维训练游戏书籍', 'Nikoli', '人民邮电出版社', 28.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '益智游戏' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/shudu.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '数独合订本初级入门儿童益智逻辑思维训练游戏书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '儿童专注力训练游戏书全脑开发趣味迷宫找不同书籍', '小麒麟', '化学工业出版社', 38.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '益智游戏' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/zhongzhili.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '儿童专注力训练游戏书全脑开发趣味迷宫找不同书籍');

-- 儿童文学-科普百科（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '十万个为什么全套儿童版科普百科知识读物', '米伊林', '北京教育出版社', 68.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '科普百科' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/shiwan.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '十万个为什么全套儿童版科普百科知识读物');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'DK儿童百科全书全套科学科普知识图画书籍', 'DK出版社', '中国大百科全书出版社', 198.00, 150, 138, (SELECT id FROM (SELECT id FROM category WHERE category_name = '科普百科' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/dkbaike.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'DK儿童百科全书全套科学科普知识图画书籍');

-- ============================================
-- 艺术类图书（4本）
-- ============================================

-- 艺术-绘画（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '素描入门基础教程零基础学素描绘画技法书籍', '飞乐鸟', '中国水利水电出版社', 48.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '绘画' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/sumiao.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '素描入门基础教程零基础学素描绘画技法书籍');

-- 艺术-摄影（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '摄影笔记宁思潇潇摄影教程入门实战技巧书籍', '宁思潇潇', '人民邮电出版社', 79.00, 140, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '摄影' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/sheying.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '摄影笔记宁思潇潇摄影教程入门实战技巧书籍');

-- 艺术-设计（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '设计中的设计原研哉平面设计理论创意设计书籍', '原研哉', '山东人民出版社', 48.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '设计' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/sheji.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '设计中的设计原研哉平面设计理论创意设计书籍');

-- 艺术-书法（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '田英章楷书教程书法毛笔字帖楷书技法书籍', '田英章', '上海交通大学出版社', 35.00, 170, 155, (SELECT id FROM (SELECT id FROM category WHERE category_name = '书法' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/shufa.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '田英章楷书教程书法毛笔字帖楷书技法书籍');

-- ============================================
-- 心理学类图书（6本）
-- ============================================

-- 心理学-大众心理学（3本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '乌合之众大众心理研究古斯塔夫勒庞社会心理学书籍', '古斯塔夫·勒庞', '中央编译出版社', 32.00, 200, 185, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/wuhe.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '乌合之众大众心理研究古斯塔夫勒庞社会心理学书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '自卑与超越阿德勒个体心理学经典著作自我成长书籍', '阿尔弗雷德·阿德勒', '春风文艺出版社', 38.00, 180, 165, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/zibei.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '自卑与超越阿德勒个体心理学经典著作自我成长书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '人性的弱点戴尔卡耐基人际关系心理学经典书籍', '戴尔·卡耐基', '中国友谊出版公司', 35.00, 220, 205, (SELECT id FROM (SELECT id FROM category WHERE category_name = '大众心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/renxing.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '人性的弱点戴尔卡耐基人际关系心理学经典书籍');

-- 心理学-社会心理学（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '社会心理学戴维迈尔斯第8版心理学入门经典教材', '戴维·迈尔斯', '人民邮电出版社', 79.00, 150, 138, (SELECT id FROM (SELECT id FROM category WHERE category_name = '社会心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/shehuixinli.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '社会心理学戴维迈尔斯第8版心理学入门经典教材');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '亲密关系罗兰米勒社会心理学人际关系经典书籍', '罗兰·米勒', '人民邮电出版社', 68.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '社会心理学' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/qinmi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '亲密关系罗兰米勒社会心理学人际关系经典书籍');

-- 心理学-心理咨询（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '蛤蟆先生去看心理医生心理学入门自我疗愈书籍', '罗伯特·戴博德', '天津人民出版社', 38.00, 190, 175, (SELECT id FROM (SELECT id FROM category WHERE category_name = '心理咨询' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/hama.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '蛤蟆先生去看心理医生心理学入门自我疗愈书籍');

-- ============================================
-- 哲学类图书（2本）
-- ============================================

-- 哲学-哲学入门（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '哲学的历程西方哲学史哲学入门经典教材书籍', '威廉·F.劳黑德', '中国轻工业出版社', 88.00, 120, 105, (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学入门' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/zhexue.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '哲学的历程西方哲学史哲学入门经典教材书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '中国哲学简史冯友兰著中国哲学入门经典读物书籍', '冯友兰', '北京大学出版社', 45.00, 150, 135, (SELECT id FROM (SELECT id FROM category WHERE category_name = '哲学入门' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/zhongguozhexue.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '中国哲学简史冯友兰著中国哲学入门经典读物书籍');

-- ============================================
-- 医学类图书（2本）
-- ============================================

-- 医学-养生保健（2本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '黄帝内经全集养生保健中医经典古籍全注全译书籍', '徐文兵', '天津科学技术出版社', 68.00, 160, 145, (SELECT id FROM (SELECT id FROM category WHERE category_name = '养生保健' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/huangdi.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '黄帝内经全集养生保健中医经典古籍全注全译书籍');

INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '本草纲目李时珍中医养生保健中药学经典著作书籍', '李时珍', '人民卫生出版社', 88.00, 140, 125, (SELECT id FROM (SELECT id FROM category WHERE category_name = '养生保健' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/bencao.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '本草纲目李时珍中医养生保健中药学经典著作书籍');

-- ============================================
-- 教育类图书（2本）
-- ============================================

-- 教育-中小学教辅（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '五年高考三年模拟高中数学高考复习资料教辅书籍', '曲一线', '首都师范大学出版社', 59.00, 180, 162, (SELECT id FROM (SELECT id FROM category WHERE category_name = '中小学教辅' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/wusan.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '五年高考三年模拟高中数学高考复习资料教辅书籍');

-- 教育-职业技能（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT 'HR人力资源管理实务从入门到精通职场技能书籍', '李志敏', '中国法制出版社', 49.00, 130, 115, (SELECT id FROM (SELECT id FROM category WHERE category_name = '职业技能' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/hr.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = 'HR人力资源管理实务从入门到精通职场技能书籍');

-- ============================================
-- 科技类图书（1本）
-- ============================================

-- 科技-科普读物（1本）
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image)
SELECT '时间简史霍金著宇宙学科普知识经典读物书籍', '史蒂芬·霍金', '湖南科学技术出版社', 45.00, 200, 188, (SELECT id FROM (SELECT id FROM category WHERE category_name = '科普读物' AND parent_id != 0 LIMIT 1) AS t), 2, 1, '/images/books/shijian.jpg'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM book WHERE book_name = '时间简史霍金著宇宙学科普知识经典读物书籍');
