-- ============================================
-- 更新所有书籍的详细描述和出版时间
-- 执行前请先备份数据
-- ============================================

USE book_mall;

-- ============================================
-- ID 71: Python编程从入门到精通
-- ============================================
UPDATE book SET
    description = '<h2>🐍 Python编程入门经典教材</h2><p><strong>《Python编程：从入门到精通》</strong>是一本系统全面的Python编程入门书籍，适合零基础读者学习。</p><h3>📚 内容特色</h3><ul><li>Python基础语法详解</li><li>面向对象编程思想</li><li>常用标准库和第三方库</li><li>文件操作和数据处理</li><li>网络编程和GUI开发</li></ul><h3>📖 学习路径</h3><p>从基础语法到项目实战，配有<strong>大量实例代码</strong>和练习题，帮助读者快速掌握Python编程技能。</p><blockquote>适合编程初学者、Web开发者和数据科学爱好者学习使用。</blockquote>',
    publish_date = '2021-03-15'
WHERE id = 71;

-- ============================================
-- ID 74: C++ Primer Plus
-- ============================================
UPDATE book SET
    description = '<h2>📚 经典C++编程入门教材</h2><p><strong>《C++ Primer Plus中文版第6版》</strong>是一本经典的C++编程入门书籍，由著名编程作家<em>Stephen Prata</em>撰写。</p><h3>📖 内容特色</h3><ul><li>详细介绍C++语言的基础知识</li><li>深入讲解面向对象编程思想</li><li>涵盖C++高级特性和最佳实践</li></ul><blockquote>适合零基础读者学习，通过丰富的示例和练习，帮助读者快速掌握C++编程技能。</blockquote><p>全书内容<strong>全面、结构清晰、讲解透彻</strong>，是学习C++语言的<em>绝佳入门教材</em>。</p>',
    publish_date = '2020-03-15'
WHERE id = 74;

-- ============================================
-- ID 76: Swift编程权威指南
-- ============================================
UPDATE book SET
    description = '<h2>🍎 iOS开发权威指南</h2><p><strong>《Swift编程权威指南》</strong>是学习Swift语言的经典教材，由<em>Matthew Mathias</em>和<em>John Gallagher</em>撰写。</p><h3>📚 核心内容</h3><ul><li>Swift基础语法和数据类型</li><li>函数和闭包</li><li>面向对象编程和协议</li><li>iOS应用开发实战</li><li>Xcode使用技巧</li></ul><h3>📖 书籍特色</h3><p>配有<strong>大量实例项目</strong>，从基础到进阶，循序渐进地掌握Swift编程。</p><blockquote>苹果官方推荐的Swift学习教材，适合iOS开发初学者和进阶者。</blockquote>',
    publish_date = '2020-09-01'
WHERE id = 76;

-- ============================================
-- ID 80: PostgreSQL数据库
-- ============================================
UPDATE book SET
    description = '<h2>🗄️ PostgreSQL数据库权威指南</h2><p><strong>《PostgreSQL数据库技术内幕》</strong>由<em>Hannes Landeholm</em>撰写，深入讲解PostgreSQL的<em>架构、原理和实践</em>。</p><h3>📚 涵盖主题</h3><ul><li>PostgreSQL体系结构</li><li>查询优化与执行</li><li>索引和查询规划</li><li>并发控制和事务处理</li><li>高可用性和复制</li></ul><h3>📖 实践导向</h3><p>理论与实践相结合，配有<strong>大量实战案例和性能优化技巧</strong>。</p><blockquote>适合数据库管理员、DBA和后端开发工程师学习使用。</blockquote>',
    publish_date = '2019-06-01'
WHERE id = 80;

-- ============================================
-- ID 82: 机器学习实战
-- ============================================
UPDATE book SET
    description = '<h2>🤖 机器学习实战经典</h2><p><strong>《机器学习实战：基于Scikit-Learn和TensorFlow》</strong>由<em>Aurelien Geron</em>撰写，是机器学习领域的<em>实战派经典之作</em>。</p><h3>📚 主要内容</h3><ul><li>机器学习基础概念</li><li>分类、回归和聚类算法</li><li>Scikit-Learn使用指南</li><li>神经网络和深度学习</li><li>TensorFlow实战</li></ul><h3>📖 特色亮点</h3><p>每个知识点都配有<strong>完整的Python代码实现</strong>，边学边练，快速上手。</p><blockquote>适合机器学习初学者、数据科学家和AI工程师学习使用。</blockquote>',
    publish_date = '2019-10-01'
WHERE id = 82;

-- ============================================
-- ID 84: Vue.js实战
-- ============================================
UPDATE book SET
    description = '<h2>⚡ Vue.js实战开发指南</h2><p><strong>《Vue.js实战》</strong>由<em>梁灏</em>撰写，系统介绍Vue.js框架的<em>核心知识和实战技巧</em>。</p><h3>📚 核心内容</h3><ul><li>Vue.js核心概念和语法</li><li>组件化开发思想</li><li>Vue Router路由管理</li><li>Vuex状态管理</li><li>项目实战开发</li></ul><h3>📖 实战导向</h3><p>配有<strong>完整的项目案例</strong>，从环境搭建到项目部署，全面掌握Vue.js开发。</p><blockquote>适合前端开发者和Web开发工程师学习使用。</blockquote>',
    publish_date = '2020-11-01'
WHERE id = 84;

-- ============================================
-- ID 89: Node.js实战
-- ============================================
UPDATE book SET
    description = '<h2>🚀 Node.js后端开发实战</h2><p><strong>《Node.js实战：基于Express和MongoDB的Web应用开发》</strong>由<em>Mike Cantelon</em>等撰写，是Node.js后端开发的<em>实战指南</em>。</p><h3>📚 涵盖内容</h3><ul><li>Node.js核心模块</li><li>Express框架使用</li><li>MongoDB数据库操作</li><li>RESTful API开发</li><li>认证和授权</li></ul><h3>📖 项目驱动</h3><p>以<strong>真实项目为导向</strong>，从零开始构建完整的Web应用。</p><blockquote>适合全栈开发者和Node.js爱好者学习使用。</blockquote>',
    publish_date = '2020-04-01'
WHERE id = 89;

-- ============================================
-- ID 90: 活着
-- ============================================
UPDATE book SET
    description = '<h2>📖 中国当代文学经典</h2><p><strong>《活着》</strong>是著名作家<em>余华</em>的代表作，讲述了农村人<strong>福贵</strong>悲惨的一生。</p><h3>📚 故事简介</h3><p>福贵年轻时嗜赌成性，输光家产，父亲被活活气死。此后厄运接踵而至，母亲、儿子、女儿、妻子、女婿、外孙相继离世，最后只剩福贵和一头老牛相依为命。</p><h3>📖 文学价值</h3><p>小说通过<strong>极致的苦难叙事</strong>，展现了生命的韧性和人性的光辉，引人深思。</p><blockquote>荣获多项文学大奖，是每个中国人必读的经典之作。</blockquote>',
    publish_date = '2012-08-01'
WHERE id = 90;

-- ============================================
-- ID 91: 三体
-- ============================================
UPDATE book SET
    description = '<h2>🌌 中国科幻文学巅峰之作</h2><p><strong>《三体》</strong>是著名科幻作家<em>刘慈欣</em>的代表作，讲述了人类与<strong>三体文明</strong>的首次接触。</p><h3>📚 故事背景</h3><p>文化大革命期间，天体物理学家叶文洁向宇宙发送了信号，被三体星系的文明接收。三体舰队开始向地球进发，人类文明面临前所未有的危机。</p><h3>🌟 科幻魅力</h3><ul><li>宏大的宇宙观和想象力</li><li>深刻的科学思考</li><li>对人性和文明的反思</li></ul><blockquote>荣获雨果奖最佳长篇小说奖，让中国科幻走向世界。</blockquote>',
    publish_date = '2008-01-01'
WHERE id = 91;

-- ============================================
-- ID 93: 白夜行
-- ============================================
UPDATE book SET
    description = '<h2>🔍 日本推理小说巅峰之作</h2><p><strong>《白夜行》</strong>是日本著名作家<em>东野圭吾</em>的代表作之一，讲述了<strong>桐原亮司</strong>和<strong>唐泽雪穗</strong>之间长达19年的扭曲爱情和救赎故事。</p><h3>📚 故事简介</h3><p>两个小学生因一起命案而命运交织。亮司为了保护雪穗，杀死了自己的父亲。此后两人形同陌路，却暗中相互扶持，在黑暗中挣扎前行。</p><h3>📖 文学特色</h3><p>采用<strong>双线叙事</strong>手法，男女主角从未直接对话，却命运紧紧相连。</p><blockquote>东野圭吾代表作之一，销量突破千万册，是日本文学的经典。</blockquote>',
    publish_date = '2013-01-01'
WHERE id = 93;

-- ============================================
-- ID 96: 百年孤独
-- ============================================
UPDATE book SET
    description = '<h2>🌍 拉美文学里程碑</h2><p><strong>《百年孤独》</strong>是哥伦比亚作家<em>加西亚·马尔克斯</em>的代表作，魔幻现实主义文学的<strong>巅峰之作</strong>。</p><h3>📚 故事背景</h3><p>讲述了布恩迪亚家族七代人的兴衰史，以及虚构小镇<strong>马孔多</strong>的百年变迁。融神话传说、民间故事、宗教典故等因素，展现了拉丁美洲一个世纪以来风云变幻的历史。</p><h3>🌟 文学价值</h3><ul><li>魔幻现实主义的经典范本</li><li>独特的叙事结构</li><li>深刻的历史隐喻</li></ul><blockquote>诺贝尔文学奖获奖作品，影响了无数作家和读者。</blockquote>',
    publish_date = '2011-06-01'
WHERE id = 96;

-- ============================================
-- ID 101: 中国历代政治得失
-- ============================================
UPDATE book SET
    description = '<h2>🏛️ 钱穆先生的历史政治分析</h2><p><strong>《中国历代政治得失》</strong>是著名历史学家<em>钱穆</em>先生的经典之作，精辟地分析了中国历代<strong>汉、唐、宋、明、清</strong>五个朝代的政治制度。</p><h3>📚 核心内容</h3><ul><li>政府组织架构</li><li>考试与选举制度</li><li>赋税制度</li><li>兵役制度</li><li>历代政治得失总结</li></ul><h3>📖 学术价值</h3><p>以<strong>简约精炼的笔触</strong>，概括中国历史上重要的政治制度，揭示其利弊得失。</p><blockquote>是了解中国政治制度史的入门必读书。</blockquote>',
    publish_date = '2012-04-01'
WHERE id = 101;

-- ============================================
-- ID 105: 世界上下五千年
-- ============================================
UPDATE book SET
    description = '<h2>🌍 世界历史通识读物</h2><p><strong>《世界上下五千年》</strong>以通俗易懂的笔法，系统介绍了世界历史的<em>重大事件、著名人物和文明成就</em>。</p><h3>📚 内容覆盖</h3><ul><li>古代文明（埃及、希腊、罗马）</li><li>中世纪欧洲</li><li>文艺复兴与宗教改革</li><li>工业革命</li><li>两次世界大战</li></ul><h3>📖 编写特色</h3><p>配有<strong>丰富的历史图片和地图</strong>，图文并茂，适合历史爱好者和学生阅读。</p><blockquote>是了解世界历史的优秀入门读物。</blockquote>',
    publish_date = '2010-05-01'
WHERE id = 105;

-- ============================================
-- ID 107: 巴菲特致股东的信
-- ============================================
UPDATE book SET
    description = '<h2>💰 投资大师的智慧结晶</h2><p><strong>《巴菲特致股东的信》</strong>收录了股神<em>沃伦·巴菲特</em>致伯克希尔·哈撒韦公司股东的年度信件，是投资领域的<em>必读经典</em>。</p><h3>📚 核心主题</h3><ul><li>价值投资理念</li><li>企业内在价值评估</li><li>管理层评估标准</li><li>并购与收购哲学</li><li>风险控制策略</li></ul><h3>📖 投资智慧</h3><p>巴菲特用<strong>朴实幽默的语言</strong>阐述深刻的商业和投资哲学。</p><blockquote>巴菲特本人授权的权威版本，投资者必读。</blockquote>',
    publish_date = '2019-03-01'
WHERE id = 107;

-- ============================================
-- ID 109: 管理学
-- ============================================
UPDATE book SET
    description = '<h2>📊 管理学经典教材</h2><p><strong>《管理学》第13版</strong>由<em>斯蒂芬·罗宾斯</em>撰写，是全球最畅销的管理学教材之一。</p><h3>📚 核心内容</h3><ul><li>管理过程与管理理论</li><li>计划与决策</li><li>组织结构与设计</li><li>领导与激励</li><li>控制与变革</li></ul><h3>📖 教材特色</h3><p>内容<strong>系统全面、案例丰富</strong>，既有理论深度，又有实践指导。</p><blockquote>适合管理学专业学生和企业管理者学习使用。</blockquote>',
    publish_date = '2020-01-01'
WHERE id = 109;

-- ============================================
-- ID 112: 小王子
-- ============================================
UPDATE book SET
    description = '<h2>⭐ 世界文学经典童话</h2><p><strong>《小王子》</strong>是法国作家<em>圣-埃克苏佩里</em>的代表作，是<em>世界上销量最好的童话之一</em>。</p><h3>📚 故事简介</h3><p>来自B-612星球的小王子，在访问了6个星球后来到地球。他驯养了一只狐狸，并遇到了飞行员叙述者。通过小王子的眼睛，我们看到了成人世界的空虚和愚蠢。</p><h3>🌟 文学魅力</h3><p>用<strong>简洁纯净的文字</strong>，讲述关于爱、责任和生命的深刻哲理。</p><blockquote>适合所有年龄段的读者，是永不褪色的经典。</blockquote>',
    publish_date = '2013-10-01'
WHERE id = 112;

-- ============================================
-- ID 116: 草房子
-- ============================================
UPDATE book SET
    description = '<h2>🏠 中国儿童文学经典</h2><p><strong>《草房子》</strong>是著名作家<em>曹文轩</em>的代表作，讲述了油麻地小学孩子们的成长故事。</p><h3>📚 故事简介</h3><p>主人公桑桑在油麻地小学度过了六年刻骨铭心的校园生活，亲眼目睹了一连串感人至深的故事：秃鹤的自信、纸月的优秀、细马的叛逆、杜小康家的变故...</p><h3>📖 文学价值</h3><p>以<strong>优美的笔触</strong>描绘了乡野少年的成长历程，充满诗意和温情。</p><blockquote>荣获国家图书奖等多项大奖，是儿童文学的经典之作。</blockquote>',
    publish_date = '2010-05-01'
WHERE id = 116;

-- ============================================
-- ID 118: 自卑与超越
-- ============================================
UPDATE book SET
    description = '<h2>🧠 个体心理学经典</h2><p><strong>《自卑与超越》</strong>是奥地利心理学家<em>阿尔弗雷德·阿德勒</em>的代表作，是<em>个体心理学的奠基之作</em>。</p><h3>📚 核心概念</h3><ul><li>自卑感与补偿机制</li><li>生活风格形成</li><li>早期记忆的影响</li><li>社会兴趣与合作</li><li>职业、友情、爱情</li></ul><h3>📖 实用价值</h3><p>帮助你<strong>认识自我、超越自卑</strong>，找到人生的意义和方向。</p><blockquote>适合心理学爱好者和追求个人成长的读者。</blockquote>',
    publish_date = '2016-01-01'
WHERE id = 118;

-- ============================================
-- ID 121: 社会心理学
-- ============================================
UPDATE book SET
    description = '<h2>🧠 社会心理学权威教材</h2><p><strong>《社会心理学》第9版</strong>由<em>戴维·迈尔斯</em>撰写，是全球最畅销的社会心理学教材。</p><h3>📚 主要内容</h3><ul><li>社会认知与归因</li><li>态度与说服</li><li>从众、服从与顺从</li><li>群体影响</li><li>偏见、攻击与利他</li><li>亲密关系</li></ul><h3>📖 编写特色</h3><p>内容<strong>权威前沿、案例丰富</strong>，兼具学术性和可读性。</p><blockquote>适合心理学专业学生和对社会心理学感兴趣的读者。</blockquote>',
    publish_date = '2017-01-01'
WHERE id = 121;

-- ============================================
-- ID 128: 理想国
-- ============================================
UPDATE book SET
    description = '<h2>🏛️ 西方哲学经典</h2><p><strong>《理想国》</strong>是古希腊哲学家<em>柏拉图</em>的代表作，是西方哲学史上<em>最重要的哲学著作之一</em>。</p><h3>📚 核心主题</h3><p>以苏格拉底与他人的对话形式，探讨<strong>正义的本质</strong>，以及理想国家的构建。涉及政治、教育、伦理、哲学等多个领域。</p><h3>🌟 哲学价值</h3><ul><li>哲学王思想</li><li>洞穴比喻</li><li>理念论</li></ul><blockquote>西方政治哲学和教育哲学的源头，影响深远。</blockquote>',
    publish_date = '2015-06-01'
WHERE id = 128;

-- ============================================
-- ID 129: 尼采
-- ============================================
UPDATE book SET
    description = '<h2>💡 尼采哲学思想导读</h2><p><strong>《尼采文集》</strong>收录了德国哲学家<em>弗里德里希·尼采</em>的经典著作，包括《悲剧的诞生》《查拉图斯特拉如是说》等。</p><h3>📚 主要内容</h3><ul><li>酒神精神与日神精神</li><li>上帝已死</li><li>超人哲学</li><li>永恒轮回</li><li>强力意志</li></ul><h3>📖 思想特色</h3><p>尼采以<strong>诗意的语言和深刻的洞察</strong>，批判传统价值观，呼唤人类精神的重建。</p><blockquote>适合哲学爱好者和追求思想深度的读者。</blockquote>',
    publish_date = '2014-03-01'
WHERE id = 129;

-- ============================================
-- ID 130: 黄帝内经
-- ============================================
UPDATE book SET
    description = '<h2>🏥 中医养生经典</h2><p><strong>《黄帝内经》</strong>是中国最早的医学典籍，与《难经》《伤寒杂病论》《神农本草经》并称中国传统医学四大经典著作。</p><h3>📚 核心内容</h3><ul><li>阴阳五行学说</li><li>藏象经络理论</li><li>病因病机学说</li><li>养生保健原则</li><li>针灸治疗理论</li></ul><h3>📖 学术价值</h3><p>奠定了<strong>中医学的理论基础</strong>，被称为"医之始祖"。</p><blockquote>适合中医爱好者和养生保健人士阅读。</blockquote>',
    publish_date = '2018-05-01'
WHERE id = 130;

-- ============================================
-- ID 134: 雅思词汇
-- ============================================
UPDATE book SET
    description = '<h2>📚 雅思考试词汇必备</h2><p><strong>《新东方雅思词汇词根联想记忆法》</strong>由<em>俞敏洪</em>主编，是雅思考试的<em>词汇经典教材</em>。</p><h3>📚 编写特色</h3><ul><li>词根词缀记忆法</li><li>联想记忆技巧</li><li>乱序编排设计</li><li>配套音频下载</li><li>雅思真题例句</li></ul><h3>📖 使用价值</h3><p>帮助考生<strong>高效记忆雅思词汇</strong>，配有MP3音频支持听说练习。</p><blockquote>雅思备考首选词汇书，适合雅思考生使用。</blockquote>',
    publish_date = '2020-01-01'
WHERE id = 134;

-- ============================================
-- 为最近插入的书籍添加出版时间（ID 170-182）
-- ============================================

UPDATE book SET publish_date = '2018-09-01' WHERE id = 170;
UPDATE book SET publish_date = '2021-01-01' WHERE id = 171;
UPDATE book SET publish_date = '2017-09-01' WHERE id = 172;
UPDATE book SET publish_date = '2021-01-01' WHERE id = 173;
UPDATE book SET publish_date = '2020-07-01' WHERE id = 174;
UPDATE book SET publish_date = '2020-07-01' WHERE id = 175;
UPDATE book SET publish_date = '2019-08-01' WHERE id = 176;
UPDATE book SET publish_date = '2019-05-01' WHERE id = 177;
UPDATE book SET publish_date = '2017-08-01' WHERE id = 178;
UPDATE book SET publish_date = '2019-11-01' WHERE id = 179;
UPDATE book SET publish_date = '2019-06-01' WHERE id = 180;
UPDATE book SET publish_date = '2019-04-01' WHERE id = 181;
UPDATE book SET publish_date = '2018-01-01' WHERE id = 182;

-- ============================================
-- 验证更新结果
-- ============================================
SELECT
    '更新完成统计：' AS info,
    COUNT(*) AS 总数,
    SUM(CASE WHEN description IS NOT NULL AND description != '' THEN 1 ELSE 0 END) AS 有描述,
    SUM(CASE WHEN publish_date IS NOT NULL THEN 1 ELSE 0 END) AS 有出版时间
FROM book
WHERE id BETWEEN 71 AND 134 OR id BETWEEN 170 AND 182;
