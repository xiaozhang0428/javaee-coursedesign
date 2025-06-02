-- 修复购物车图片显示问题
-- 为products表添加image字段并更新数据

USE javaee_shop;

-- 1. 添加image字段（如果不存在）
ALTER TABLE products ADD COLUMN IF NOT EXISTS image VARCHAR(500) COMMENT '商品图片';

-- 2. 更新现有商品的图片信息
-- 根据商品名称匹配对应的图片文件
UPDATE products SET image = 'iphone16pro.jpg' WHERE name LIKE '%iPhone%' OR name LIKE '%iphone%';
UPDATE products SET image = 'macbookpro.jpg' WHERE name LIKE '%MacBook%' OR name LIKE '%macbook%';
UPDATE products SET image = 'ipadair.jpg' WHERE name LIKE '%iPad%' OR name LIKE '%ipad%';
UPDATE products SET image = 'airpodspro2.jpg' WHERE name LIKE '%AirPods%' OR name LIKE '%airpods%';
UPDATE products SET image = 'applewatch10.jpg' WHERE name LIKE '%Apple Watch%' OR name LIKE '%apple watch%';
UPDATE products SET image = 'huaweimate70pro.jpg' WHERE name LIKE '%华为%' OR name LIKE '%Mate%';
UPDATE products SET image = 'xiaomi15spro.png' WHERE name LIKE '%小米%' OR name LIKE '%xiaomi%';
UPDATE products SET image = 'dellxps13.jpg' WHERE name LIKE '%戴尔%' OR name LIKE '%Dell%' OR name LIKE '%XPS%';
UPDATE products SET image = 'sonywh1000xm6.jpg' WHERE name LIKE '%索尼%' OR name LIKE '%Sony%' OR name LIKE '%WH-%';
UPDATE products SET image = 'nintendoswitch.jpg' WHERE name LIKE '%任天堂%' OR name LIKE '%Nintendo%' OR name LIKE '%Switch%';
UPDATE products SET image = 'samsungs25.jpg' WHERE name LIKE '%三星%' OR name LIKE '%Samsung%' OR name LIKE '%Galaxy%';
UPDATE products SET image = 'thinkpadx1.jpg' WHERE name LIKE '%联想%' OR name LIKE '%ThinkPad%' OR name LIKE '%Lenovo%';

-- 3. 为没有匹配到的商品设置默认图片
UPDATE products SET image = 'default.jpg' WHERE image IS NULL OR image = '';

-- 4. 验证更新结果
SELECT id, name, image FROM products ORDER BY id;