-- 为 order_item 表添加商家头像字段
ALTER TABLE order_item
ADD COLUMN IF NOT EXISTS merchant_logo VARCHAR(500) COMMENT '商家头像' AFTER merchant_phone;

-- 验证字段是否添加成功
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'book_mall'
  AND TABLE_NAME = 'order_item'
  AND COLUMN_NAME = 'merchant_logo';
