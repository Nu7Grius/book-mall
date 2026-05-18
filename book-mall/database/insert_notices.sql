-- 插入公告测试数据
INSERT INTO notice (title, content, coverImage, notice_type, publisher_id, publish_time, end_time, status, view_count, create_time) VALUES
('🎉 春季图书大促活动', '全场图书5折起，限时优惠！购买满100元送精美书签一套。快来选购吧！', NULL, 'promotion', 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 1, 0, NOW()),
('📚 世界读书日特别活动', '4月23日世界读书日，我们为广大读者准备了丰富的线上线下活动，参与即有机会获得精美图书礼包！', NULL, 'activity', 1, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 1, 0, NOW()),
('📖 2024年度好书推荐榜单', '年度最佳小说、科普读物、儿童文学等各类好书推荐，让您在新的一年里找到更多阅读乐趣！', NULL, 'news', 1, NOW(), NULL, 1, 0, NOW()),
('📢 商城系统升级通知', '尊敬的用户，我们的商城系统将于本周日凌晨2:00-6:00进行升级维护，届时部分功能将暂停使用，给您带来不便敬请谅解！', NULL, 'notice', 1, NOW(), NULL, 1, 0, NOW()),
('🔔 新用户注册有礼', '新用户注册即送50元优惠券，首次购买更可享受额外9折优惠，快来加入我们的阅读大家庭吧！', NULL, 'promotion', 1, NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY), 1, 0, NOW());
