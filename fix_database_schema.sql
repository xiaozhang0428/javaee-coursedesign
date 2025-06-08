-- 修复数据库表结构 - 添加缺失的列
USE javaee_shop;

-- 检查并添加 category_id 列到 products 表
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS category_id INT COMMENT '分类ID';

-- 检查并添加 create_time 列到 products 表（如果也缺失的话）
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS create_time DATETIME COMMENT '创建时间';

-- 为现有数据设置默认值
UPDATE products SET category_id = 1 WHERE category_id IS NULL;
UPDATE products SET create_time = NOW() WHERE create_time IS NULL;

-- 显示表结构确认修改
DESCRIBE products;