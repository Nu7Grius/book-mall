-- ============================================
-- 图书商城系统 - 14本书完整数据
-- 基于 uploads/2026-05-07 文件夹中的封面
-- 执行前请确保已运行数据库初始化脚本
-- ============================================

USE book_mall;

-- ============================================
-- 14本书数据
-- ============================================

-- 1. C++ Primer Plus -> 计算机-编程语言
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description, publish_date)
VALUES (
    'C++ Primer Plus中文版第6版C语言编程入门经典教程书籍',
    'Stephen Prata',
    '人民邮电出版社',
    108.00,
    150,
    86,
    (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/C++ Primer Plus.jpg',
    0,
    '<h2>📚 经典C++编程入门教材</h2><p><strong>《C++ Primer Plus中文版第6版》</strong>是一本经典的C++编程入门书籍，由著名编程作家<em>Stephen Prata</em>撰写。</p><h3>📖 内容特色</h3><ul><li>详细介绍C++语言的基础知识</li><li>深入讲解面向对象编程思想</li><li>涵盖C++高级特性和最佳实践</li></ul><blockquote>适合零基础读者学习，通过丰富的示例和练习，帮助读者快速掌握C++编程技能。</blockquote><p>全书内容<strong>全面、结构清晰、讲解透彻</strong>，是学习C++语言的<em>绝佳入门教材</em>。</p>',
    '2020-03-15'
);

-- 2. Effective Java -> 计算机-编程语言
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description, publish_date)
VALUES (
    'Effective Java中文版第3版Java编程思想与实践经典书籍',
    'Joshua Bloch',
    '电子工业出版社',
    89.00,
    180,
    125,
    (SELECT id FROM category WHERE category_name = '编程语言' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/Effective Java.jpg',
    0,
    '<h2>☕ Java程序员必读进阶书籍</h2><p><strong>《Effective Java中文版》</strong>是<em>Java之父Joshua Bloch</em>的经典之作，被公认为Java程序员必读的进阶书籍。</p><h3>📖 核心亮点</h3><ul><li>从<strong>57个最具实践性的角度</strong>出发</li><li>深入探讨Java编程中的最佳实践</li><li>详细分析常见陷阱和高级技巧</li></ul><h3>📚 涵盖主题</h3><p>类与接口、泛型、枚举、注解、并发编程等核心主题，每一条建议都经过精心提炼，配有详细的案例分析。</p><blockquote>阅读本书可以显著提升Java编程水平和代码质量，是Java开发者迈向高级的必读之作。</blockquote>',
    '2018-09-01'
);

-- 3. 宏观经济学 -> 经济管理-经济学基础
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description, publish_date)
VALUES (
    '宏观经济学曼昆第10版教材考研经济学基础理论书籍',
    'N·格里高利·曼昆',
    '中国人民大学出版社',
    65.00,
    200,
    168,
    (SELECT id FROM category WHERE category_name = '经济学基础' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/宏观经济学.jpg',
    0,
    '<h2>💰 经济学大师曼昆经典教材</h2><p><strong>《宏观经济学》</strong>是经济学大师<em>曼昆</em>的经典教材，系统阐述了宏观经济学的基本原理和核心理论。</p><h3>📚 主要内容</h3><ul><li>国民收入核算与经济指标</li><li>经济增长理论</li><li>通货膨胀与失业</li><li>财政政策与货币政策</li></ul><h3>📖 书籍特色</h3><p>配有<strong>大量图表和案例分析</strong>，帮助读者深入理解宏观经济运行规律。</p><blockquote>本书语言通俗易懂、逻辑清晰，适合经济学专业学生和感兴趣的读者学习使用。</blockquote>',
    '2021-01-01'
);

-- 4. 富爸爸穷爸爸 -> 经济管理-投资理财
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description, publish_date)
VALUES (
    '富爸爸穷爸爸个人理财投资理财入门经典财富思维书籍',
    '罗伯特·清崎',
    '四川人民出版社',
    48.00,
    250,
    235,
    (SELECT id FROM category WHERE category_name = '投资理财' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/富爸爸穷爸爸.jpg',
    0,
    '<h2>💎 财富思维启蒙经典</h2><p><strong>《富爸爸穷爸爸》</strong>是投资理财领域的<em>现象级畅销书</em>，通过讲述作者两个父亲截然不同的理财观念，揭示了财富自由的秘密。</p><h3>👨‍👦 两个爸爸的对比</h3><ul><li><strong>穷爸爸</strong>：受过良好教育，却一生在财务困境中挣扎</li><li><strong>富爸爸</strong>：通过投资和创业实现财务自由</li></ul><h3>📖 本书价值</h3><p>用通俗易懂的语言传授<strong>财务知识，投资技巧和创业思维</strong>，帮助读者树立正确的金钱观和财富观。</p><blockquote>书中提出的"财商"概念影响深远，是开启财富人生的思想启蒙读物。</blockquote>',
    '2017-09-01'
);

-- 5. 微观经济学 -> 经济管理-经济学基础
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description, publish_date)
VALUES (
    '微观经济学曼昆第10版教材考研经济学基础理论书籍',
    'N·格里高利·曼昆',
    '中国人民大学出版社',
    65.00,
    200,
    168,
    (SELECT id FROM category WHERE category_name = '经济学基础' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/微观经济学.jpg',
    0,
    '<h2>📈 市场经济运行的微观基础</h2><p><strong>《微观经济学》</strong>同样是<em>曼昆</em>的经典教材，专注于分析个体经济行为和市场机制。</p><h3>📚 核心内容</h3><ul><li>供求理论与价格机制</li><li>消费者行为理论</li><li>生产者行为理论</li><li>市场结构分析</li><li>要素市场理论</li></ul><h3>📖 学习价值</h3><p>理论与实践相结合，配有<strong>丰富的案例和习题</strong>，帮助读者巩固所学知识。</p><blockquote>通过学习本书，读者可以深入理解市场经济运行的微观基础，培养经济学思维方式和分析问题的能力。</blockquote>',
    '2021-01-01'
);

-- 6. 操作系统 -> 计算机-后端架构
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description, publish_date)
VALUES (
    '操作系统概念原书第12版计算机操作系统原理与实践教程',
    'Abraham Silberschatz',
    '电子工业出版社',
    118.00,
    160,
    132,
    (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/操作系统.jpg',
    0,
    '<h2>💻 操作系统领域权威教材</h2><p><strong>《操作系统概念》</strong>是操作系统领域的权威教材，系统全面地介绍了操作系统的<em>原理、设计和实现</em>。</p><h3>📚 核心知识点</h3><ul><li>进程管理与线程</li><li>内存管理技术</li><li>文件系统设计</li><li>设备驱动程序</li><li>死锁与并发控制</li></ul><h3>📖 书籍特色</h3><p>配有<strong>大量实例和代码分析</strong>，既注重理论知识的讲解，又强调实际应用。</p><blockquote>是计算机专业学生学习操作系统课程的经典教材，也是系统程序员和软件工程师的必备参考书。</blockquote>',
    '2020-07-01'
);

-- 7. 操作系统概念 -> 计算机-后端架构
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description, publish_date)
VALUES (
    '操作系统概念第12版教材考研计算机操作系统原理书籍',
    'Abraham Silberschatz',
    '电子工业出版社',
    118.00,
    160,
    132,
    (SELECT id FROM category WHERE category_name = '后端架构' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/操作系统概念.jpg',
    0,
    '<h2>💻 操作系统学习权威指南</h2><p><strong>《操作系统概念》第12版</strong>是最新修订版，在保持经典内容的基础上，融入了操作系统领域的<em>最新发展成果</em>。</p><h3>📚 涵盖内容</h3><ul><li>进程线程与调度算法</li><li>同步与互斥机制</li><li>死锁预防与避免</li><li>内存管理与虚拟内存</li><li>文件系统管理</li></ul><h3>📖 学习指导</h3><p>每章配有<strong>习题和实验指导</strong>，帮助读者巩固所学知识，提升实际操作能力。</p><blockquote>本书是操作系统学习的权威指南，适合计算机专业学生和从业人员使用。</blockquote>',
    '2020-07-01'
);

-- 8. 数据库系统 -> 计算机-数据库
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description)
VALUES (
    '数据库系统概论第5版数据库原理与应用开发教材书籍',
    '王珊',
    '高等教育出版社',
    45.00,
    200,
    185,
    (SELECT id FROM category WHERE category_name = '数据库' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/数据库系统.jpg',
    0,
    '<h2>🗄️ 国内数据库课程经典教材</h2><p><strong>《数据库系统概论》</strong>是国内数据库课程的经典教材，系统介绍了数据库系统的<em>基本概念、原理和技术</em>。</p><h3>📚 核心内容</h3><ul><li>数据模型与关系模型</li><li>SQL语言与应用</li><li>数据库设计与规范化</li><li>事务管理与并发控制</li><li>数据库恢复技术</li></ul><h3>📖 实践导向</h3><p>理论与实践并重，配有<strong>大量的实例和练习题</strong>，帮助读者深入理解和掌握数据库技术。</p><blockquote>通过学习本书，读者可以全面掌握数据库系统的核心知识，具备数据库设计、开发和管理的能力。</blockquote>'
);

-- 9. 曾国藩传 -> 历史-历史人物传记
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description)
VALUES (
    '曾国藩传张宏杰著晚清名臣传记历史人物书籍',
    '张宏杰',
    '民主与建设出版社',
    58.00,
    180,
    162,
    (SELECT id FROM category WHERE category_name = '历史人物传记' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/曾国藩传.jpg',
    0,
    '<h2>📜 晚清名臣的传奇人生</h2><p><strong>《曾国藩传》</strong>是历史作家<em>张宏杰</em>的力作，以详实的史料和生动的笔触，全面展现了晚清重臣<strong>曾国藩</strong>的一生。</p><h3>👤 人物剖析</h3><ul><li><strong>为人处世</strong>：圆融而不世故的智慧</li><li><strong>治学修身</strong>：终身学习的精神</li><li><strong>为官从政</strong>：中兴名臣的风范</li></ul><h3>📖 阅读价值</h3><p>书中既有<em>宏大的历史叙事</em>，又有细腻的人物刻画，是了解晚清历史和曾国藩的重要读物。</p><blockquote>曾国藩的处世哲学和人生智慧，至今仍具有重要的借鉴意义。</blockquote>'
);

-- 10. 沙丘 -> 文学-外国文学
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description)
VALUES (
    '沙丘弗兰克赫伯特著科幻小说经典世界文学名著书籍',
    '弗兰克·赫伯特',
    '江苏凤凰文艺出版社',
    68.00,
    200,
    178,
    (SELECT id FROM category WHERE category_name = '外国文学' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/沙丘.jpg',
    0,
    '<h2>🚀 科幻文学的里程碑之作</h2><p><strong>《沙丘》</strong>是科幻文学的里程碑之作，作者<em>弗兰克·赫伯特</em>构建了一个宏大的沙漠星球世界<strong>厄拉科斯</strong>。</p><h3>📖 故事简介</h3><p>故事讲述了少年<strong>保罗·厄崔迪</strong>在政治阴谋、家族争斗和神秘力量交织中的成长历程。</p><h3>🌟 本书意义</h3><ul><li>精彩的冒险故事</li><li>深刻的宗教、政治、生态思考</li><li>开创"生态科幻"流派</li></ul><blockquote>影响了无数后来的科幻作家和电影导演，是科幻文学史上不可逾越的经典。</blockquote>'
);

-- 11. 流浪地球 -> 文学-小说
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description)
VALUES (
    '流浪地球刘慈欣著科幻小说电影原著中国科幻文学书籍',
    '刘慈欣',
    '中国华侨出版社',
    38.00,
    220,
    198,
    (SELECT id FROM category WHERE category_name = '小说' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/流浪地球.jpg',
    0,
    '<h2>🌍 中国科幻的里程碑</h2><p><strong>《流浪地球》</strong>是科幻作家<em>刘慈欣</em>的代表作之一，讲述了在太阳即将毁灭的未来，人类带着地球一起逃离太阳系寻找新家园的故事。</p><h3>📖 故事设定</h3><p>人类在地球表面建造出<strong>巨大的推进器</strong>，这个宏大的设定下，是一个个普通人在末世中的挣扎与选择。</p><h3>✨ 作品特色</h3><ul><li>独特的想象力</li><li>深刻的人文关怀</li><li>硬科幻的科学精神</li></ul><blockquote>改编电影更是开创了中国科幻电影的新纪元，让无数观众为之震撼。</blockquote>'
);

-- 12. 版式设计 -> 艺术-设计
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description)
VALUES (
    '版式设计原理与实践平面设计视觉传达设计教程书籍',
    '杨蕾',
    '人民邮电出版社',
    56.00,
    150,
    125,
    (SELECT id FROM category WHERE category_name = '设计' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/版式设计.jpg',
    0,
    '<h2>🎨 版式设计专业教程</h2><p><strong>《版式设计原理与实践》</strong>系统介绍了版式设计的<em>核心理论和实用技巧</em>。</p><h3>📚 设计要点</h3><ul><li>版面布局原则</li><li>元素编排技巧</li><li>视觉层次构建</li><li>色彩搭配方法</li><li>字体选择指南</li></ul><h3>📖 实践指导</h3><p>配有<strong>大量经典案例和实操练习</strong>，帮助读者将理论知识转化为实际操作能力。</p><blockquote>通过学习本书，读者可以掌握版式设计的专业技能，提升平面设计和视觉传达的能力。</blockquote>'
);

-- 13. 计算机网络 -> 计算机-网络与安全
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description)
VALUES (
    '计算机网络第7版谢希仁著TCP/IP协议原理与应用教程',
    '谢希仁',
    '电子工业出版社',
    49.00,
    220,
    198,
    (SELECT id FROM category WHERE category_name = '网络与安全' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/计算机网络.jpg',
    0,
    '<h2>🌐 国内最经典的计算机网络教材</h2><p><strong>《计算机网络》</strong>由著名计算机网络专家<em>谢希仁</em>教授撰写，是计算机网络领域的<strong>经典之作</strong>。</p><h3>📚 协议层次</h3><ul><li><strong>物理层</strong>：信号传输与编码</li><li><strong>数据链路层</strong>：帧封装与差错控制</li><li><strong>网络层</strong>：路由与IP协议</li><li><strong>传输层</strong>：TCP与UDP</li><li><strong>应用层</strong>：HTTP、DNS等协议</li></ul><h3>📖 书籍特色</h3><p>配有<strong>丰富的图表和实例分析</strong>，是计算机专业学生和网络工程师学习网络知识的必读教材。</p>'
);

-- 14. 饮食与健康 -> 医学-养生保健
INSERT INTO book (book_name, author, publisher, price, stock, sales, category_id, merchant_id, status, cover_image, audit_status, description)
VALUES (
    '饮食与健康营养学健康养生保健饮食搭配指南书籍',
    '李宁',
    '化学工业出版社',
    42.00,
    180,
    158,
    (SELECT id FROM category WHERE category_name = '养生保健' AND parent_id != 0 LIMIT 1),
    2,
    1,
    '/uploads/2026-05-07/饮食与健康.jpg',
    0,
    '<h2>🥗 实用营养健康指南</h2><p><strong>《饮食与健康》</strong>是一本实用的营养健康指南，从<em>科学的角度</em>阐述了饮食与健康的关系。</p><h3>📚 主要内容</h3><ul><li>营养学基础知识</li><li>食物的营养价值</li><li>膳食搭配原则</li><li>不同人群的饮食调理</li><li>常见疾病的饮食预防</li></ul><h3>📖 实用价值</h3><p>配有<strong>大量食谱推荐和食疗方案</strong>，实用性强，可操作性好。</p><blockquote>通过阅读本书，读者可以树立科学的饮食观念，掌握健康的饮食方法，提升生活质量。</blockquote>'
);

-- ============================================
-- 验证插入结果
-- ============================================
SELECT '插入完成！共插入图书：' AS message, COUNT(*) AS count FROM book WHERE cover_image LIKE '%uploads/2026-05-07%';

SELECT id, book_name, author, price, category_id, cover_image 
FROM book 
WHERE cover_image LIKE '%uploads/2026-05-07%'
ORDER BY id;
