BEGIN;

INSERT INTO notice (id, title, content, cover_image, notice_type, publisher_id, publish_time, end_time, status, view_count, create_time, update_time, deleted) VALUES (1,'书魂商城上线公告','<p>亲爱的用户们：</p><p>书魂商城正式上线啦！我们致力于为您提供优质的图书购物体验。</p><p>目前平台已上线数千种图书，涵盖编程技术、文学小说、历史传记、经济管理等多个品类，欢迎选购！</p><p>新用户注册即享优惠券礼包，快来体验吧！</p>','/uploads/2026-05-01/notice1.jpg','平台公告',1,'2026-04-29 17:03:00','2026-06-30 23:59:59',1,5,'2026-04-29 00:00:00','2026-05-02 02:44:17',0);
INSERT INTO notice (id, title, content, cover_image, notice_type, publisher_id, publish_time, end_time, status, view_count, create_time, update_time, deleted) VALUES (2,'五一劳动节促销活动','<p><strong>五一劳动节大促！</strong></p><p>为庆祝五一劳动节，书魂商城推出限时优惠活动：全场图书8折优惠，满100减20，满200减50。活动时间：5月1日-5月7日。</p>',NULL,'活动通知',1,'2026-04-30 00:00:00','2026-05-07 23:59:59',1,3,'2026-04-30 00:00:00','2026-05-02 02:44:17',0);
INSERT INTO notice (id, title, content, cover_image, notice_type, publisher_id, publish_time, end_time, status, view_count, create_time, update_time, deleted) VALUES (3,'关于优化搜索功能的通知','为了提升您的购物体验，我们近期对搜索功能进行了全面优化：新增分类筛选功能、优化关键词匹配算法、支持多条件组合搜索、新增价格区间筛选。',NULL,'功能更新',1,'2026-05-01 00:00:00','2026-06-30 23:59:59',1,2,'2026-05-01 00:00:00','2026-05-02 02:44:17',0);
INSERT INTO notice (id, title, content, cover_image, notice_type, publisher_id, publish_time, end_time, status, view_count, create_time, update_time, deleted) VALUES (4,'端午节优惠活动','端午安康！书魂商城送好礼！端午节期间，书魂商城推出以下优惠：购买任意图书赠送精美书签，满150元包邮，部分图书低至6折。',NULL,'活动通知',1,'2026-05-01 00:00:00','2026-06-10 23:59:59',1,1,'2026-05-01 00:00:00','2026-05-02 02:44:17',0);
INSERT INTO notice (id, title, content, cover_image, notice_type, publisher_id, publish_time, end_time, status, view_count, create_time, update_time, deleted) VALUES (5,'平台商家入驻指南','欢迎优质商家入驻书魂商城！入驻流程：点击商家入驻提交申请，填写店铺信息及资质材料，平台审核（1-3个工作日），审核通过后上架商品。',NULL,'平台公告',1,'2026-05-02 00:00:00','2026-12-31 23:59:59',1,0,'2026-05-02 00:00:00','2026-05-02 02:44:17',0);
SELECT setval('notice_id_seq', (SELECT COALESCE(MAX(id), 0) FROM notice));

INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (49,44,71,'2026-05-04 03:42:35');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (76,3,90,'2026-05-09 01:08:59');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (77,3,96,'2026-05-09 01:09:03');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (78,3,93,'2026-05-09 01:09:04');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (79,3,112,'2026-05-09 01:09:09');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (80,3,178,'2026-05-09 01:12:21');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (81,3,177,'2026-05-09 01:12:21');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (82,3,182,'2026-05-09 01:12:29');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (84,44,76,'2026-05-09 01:14:53');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (85,44,80,'2026-05-09 01:14:55');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (86,44,82,'2026-05-09 01:14:55');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (87,44,84,'2026-05-09 01:14:56');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (88,44,89,'2026-05-09 01:14:59');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (89,44,170,'2026-05-09 01:15:06');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (90,44,175,'2026-05-09 01:15:10');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (91,44,174,'2026-05-09 01:15:11');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (92,44,176,'2026-05-09 01:15:13');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (93,44,181,'2026-05-09 01:15:15');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (95,3,74,'2026-05-15 04:37:04');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (96,3,76,'2026-05-15 04:38:07');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (97,3,130,'2026-05-15 04:38:51');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (98,3,80,'2026-05-15 18:19:44');
INSERT INTO book_favorite (id, user_id, book_id, create_time) VALUES (101,3,91,'2026-05-15 19:07:18');
SELECT setval('book_favorite_id_seq', (SELECT COALESCE(MAX(id), 0) FROM book_favorite));

INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (17,82,3,61,5,'很好',0,1,NULL,NULL,'2026-05-12 22:52:31','2026-05-12 22:52:31',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (22,82,3,92,5,'你好',0,1,NULL,NULL,'2026-05-13 17:05:46','2026-05-13 17:05:46',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (23,82,3,111,2,'小程序下单买书，方便极了',0,1,NULL,NULL,'2026-05-16 19:12:29','2026-05-16 19:12:29',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (24,82,3,111,5,'看看这次能不能变成已完成',0,1,NULL,NULL,'2026-05-17 00:33:04','2026-05-17 00:33:04',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (25,82,3,111,5,'这次行吗',0,1,NULL,NULL,'2026-05-17 00:48:46','2026-05-17 00:48:46',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (26,82,3,111,5,'这次呢',0,1,NULL,NULL,'2026-05-17 00:56:04','2026-05-17 00:56:04',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (27,82,3,111,5,'这次呢？',0,1,NULL,NULL,'2026-05-17 01:00:29','2026-05-17 01:00:29',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (28,129,3,111,5,'小程序小程序下单方便，无敌！',0,1,'谢谢支持','2026-05-18 00:23:56','2026-05-17 01:32:45','2026-05-17 01:32:45',0,'merchant',50);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (30,105,3,112,3,'好好好，小程序好！',0,1,NULL,NULL,'2026-05-17 04:48:47','2026-05-17 04:48:47',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (31,129,3,117,5,'不错',0,1,NULL,NULL,'2026-05-18 02:13:52','2026-05-18 02:13:52',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (32,105,3,119,5,'好好好',0,1,NULL,NULL,'2026-05-18 02:24:48','2026-05-18 02:24:48',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (33,105,3,124,5,'好的',0,1,NULL,NULL,'2026-05-18 03:04:46','2026-05-18 03:04:46',0,NULL,NULL);
INSERT INTO book_comment (id, book_id, user_id, order_id, rating, content, is_anonymous, status, reply_content, reply_time, create_time, update_time, deleted, reply_role, reply_user_id) VALUES (36,105,3,131,5,'不错',0,1,NULL,NULL,'2026-05-18 15:32:12','2026-05-18 15:32:12',0,NULL,NULL);
SELECT setval('book_comment_id_seq', (SELECT COALESCE(MAX(id), 0) FROM book_comment));

INSERT INTO cart (id, user_id, book_id, quantity, create_time, update_time, deleted) VALUES (1,3,82,1,'2026-05-18 14:02:13','2026-05-18 14:02:13',0);
INSERT INTO cart (id, user_id, book_id, quantity, create_time, update_time, deleted) VALUES (2,3,107,1,'2026-05-18 14:02:17','2026-05-18 14:02:17',0);
INSERT INTO cart (id, user_id, book_id, quantity, create_time, update_time, deleted) VALUES (3,44,82,2,'2026-05-18 15:30:00','2026-05-18 15:30:00',0);
INSERT INTO cart (id, user_id, book_id, quantity, create_time, update_time, deleted) VALUES (4,44,71,1,'2026-05-18 15:30:05','2026-05-18 15:30:05',0);
SELECT setval('cart_id_seq', (SELECT COALESCE(MAX(id), 0) FROM cart));

COMMIT;
