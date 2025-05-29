-- 创建数据库
drop database if exists javaee_shop;
CREATE DATABASE javaee_shop DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE javaee_shop;

-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码(MD5加密)',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    address TEXT COMMENT '地址',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '用户表';

-- 创建商品表
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL COMMENT '商品名称',
    description TEXT COMMENT '商品描述',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    stock INT NOT NULL DEFAULT 0 COMMENT '库存',
    sales INT NOT NULL DEFAULT 0 COMMENT '销量',
    image VARCHAR(500) COMMENT '商品图片',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态(1:上架 0:下架)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '商品表';

-- 创建购物车表
CREATE TABLE IF NOT EXISTS cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '用户ID',
    product_id INT NOT NULL COMMENT '商品ID',
    quantity INT NOT NULL DEFAULT 1 COMMENT '数量',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_product (user_id, product_id)
) COMMENT '购物车表';

-- 创建订单表
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '用户ID',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '总金额',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '订单状态(1:待付款 2:已付款 3:已发货 4:已完成 5:已取消)',
    shipping_address TEXT NOT NULL COMMENT '收货地址',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT '订单表';

-- 创建订单项表
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL COMMENT '订单ID',
    product_id INT NOT NULL COMMENT '商品ID',
    product_name VARCHAR(200) NOT NULL COMMENT '商品名称',
    product_price DECIMAL(10,2) NOT NULL COMMENT '商品价格',
    quantity INT NOT NULL COMMENT '数量',
    subtotal DECIMAL(10,2) NOT NULL COMMENT '小计',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
) COMMENT '订单项表';

-- 插入示例数据

-- 插入用户数据
INSERT INTO users (username, password, email, phone, address) VALUES
('admin', '21232f297a57a5a743894a0e4a801fc3', 'admin@example.com', '13800138000', '北京市朝阳区'),
('user1', 'e10adc3949ba59abbe56e057f20f883e', 'user1@example.com', '13800138001', '上海市浦东新区'),
('user2', 'e10adc3949ba59abbe56e057f20f883e', 'user2@example.com', '13800138002', '广州市天河区');

-- 插入商品数据
INSERT INTO products (name, description, price, stock, sales, image, status) VALUES
('iPhone 14 Pro', '苹果最新旗舰手机，搭载A16仿生芯片，支持5G网络', 7999.00, 50, 120, 'iphone14pro.jpg', 1),
('MacBook Pro 14', '苹果笔记本电脑，M2芯片，14英寸Liquid Retina XDR显示屏', 15999.00, 30, 85, 'macbookpro14.jpg', 1),
('iPad Air', '轻薄便携的平板电脑，10.9英寸屏幕，支持Apple Pencil', 4399.00, 80, 200, 'ipadair.jpg', 1),
('AirPods Pro', '主动降噪无线耳机，空间音频技术', 1899.00, 100, 350, 'airpodspro.jpg', 1),
('Apple Watch Series 8', '智能手表，健康监测，GPS定位', 2999.00, 60, 180, 'applewatch8.jpg', 1),
('华为Mate 50 Pro', '华为旗舰手机，麒麟9000S芯片，超感知徕卡摄影', 6999.00, 40, 95, 'huaweimate50pro.jpg', 1),
('小米13 Ultra', '小米影像旗舰，徕卡光学镜头，骁龙8 Gen 2', 5999.00, 70, 150, 'xiaomi13ultra.jpg', 1),
('戴尔XPS 13', '轻薄笔记本，13.4英寸InfinityEdge显示屏', 8999.00, 25, 60, 'dellxps13.jpg', 1),
('索尼WH-1000XM4', '无线降噪耳机，30小时续航', 2299.00, 90, 280, 'sonywh1000xm4.jpg', 1),
('任天堂Switch', '便携式游戏机，支持掌机和主机模式', 2099.00, 120, 400, 'nintendoswitch.jpg', 1),
('三星Galaxy S23', '三星旗舰手机，骁龙8 Gen 2处理器', 5499.00, 55, 110, 'samsungs23.jpg', 1),
('联想ThinkPad X1', '商务笔记本，14英寸2.8K显示屏', 12999.00, 20, 45, 'thinkpadx1.jpg', 1);

-- 插入购物车示例数据
INSERT INTO cart (user_id, product_id, quantity) VALUES
(2, 1, 1),
(2, 4, 2),
(3, 2, 1),
(3, 5, 1);

-- 插入订单示例数据
INSERT INTO orders (user_id, total_amount, status, shipping_address) VALUES
(2, 9898.00, 2, '上海市浦东新区张江高科技园区'),
(3, 18998.00, 1, '广州市天河区珠江新城');

-- 插入订单项示例数据
INSERT INTO order_items (order_id, product_id, product_name, product_price, quantity, subtotal) VALUES
(1, 1, 'iPhone 14 Pro', 7999.00, 1, 7999.00),
(1, 4, 'AirPods Pro', 1899.00, 1, 1899.00),
(2, 2, 'MacBook Pro 14', 15999.00, 1, 15999.00),
(2, 5, 'Apple Watch Series 8', 2999.00, 1, 2999.00);

-- 创建数据库用户（可选）
-- CREATE USER 'javaee'@'localhost' IDENTIFIED BY 'javaee';
-- GRANT ALL PRIVILEGES ON javaee_shop.* TO 'javaee'@'localhost';
-- FLUSH PRIVILEGES;