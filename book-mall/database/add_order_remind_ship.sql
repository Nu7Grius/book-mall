-- 为订单表添加催促发货相关的字段
-- 用于标记用户是否催促商家发货

ALTER TABLE order_info
ADD COLUMN remind_ship INT DEFAULT 0 COMMENT '是否催促发货：0否，1是';

ALTER TABLE order_info
ADD COLUMN remind_time DATETIME COMMENT '催促发货时间';

-- 创建索引提高查询效率
CREATE INDEX idx_remind_ship ON order_info(remind_ship);

-- 查看修改结果
SELECT id, order_number, order_status, remind_ship, remind_time
FROM order_info
WHERE remind_ship = 1;
