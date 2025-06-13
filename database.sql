-- 创建数据库
drop database if exists javaee_shop;
CREATE DATABASE javaee_shop;

-- 使用数据库
USE javaee_shop;

-- 创建用户表
CREATE TABLE IF NOT EXISTS users
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    username    VARCHAR(50)  NOT NULL UNIQUE COMMENT '用户名',
    password    VARCHAR(100) NOT NULL COMMENT '密码(MD5加密)',
    email       VARCHAR(100) COMMENT '邮箱',
    phone       VARCHAR(20) COMMENT '手机号',
    address     TEXT COMMENT '地址',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '用户表';

-- 创建商品表
CREATE TABLE IF NOT EXISTS products
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(200)   NOT NULL COMMENT '商品名称',
    description TEXT COMMENT '商品描述',
    price       DECIMAL(10, 2) NOT NULL COMMENT '价格',
    stock       INT            NOT NULL DEFAULT 0 COMMENT '库存',
    sales       INT            NOT NULL DEFAULT 0 COMMENT '销量',
    image       VARCHAR(500) COMMENT '商品图片',
    create_time DATETIME                DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '商品表';

-- 创建购物车表
CREATE TABLE IF NOT EXISTS carts
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    user_id     INT NOT NULL COMMENT '用户ID',
    product_id  INT NOT NULL COMMENT '商品ID',
    quantity    INT NOT NULL DEFAULT 1 COMMENT '数量',
    create_time DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_product (user_id, product_id)
) COMMENT '购物车表';

-- 创建订单表
CREATE TABLE IF NOT EXISTS orders
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    user_id      INT            NOT NULL COMMENT '用户ID',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT '总金额',
    status       VARCHAR(20)    NOT NULL COMMENT '订单状态',
    username     VARCHAR(50)    NOT NULL COMMENT '订单镜像 用户名',
    address      TEXT           NOT NULL COMMENT '订单镜像 收货地址',
    phone        VARCHAR(20)    NOT NULL COMMENT '订单镜像 手机号',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users (id)
) COMMENT '订单表';

-- 创建订单项表
CREATE TABLE IF NOT EXISTS order_items
(
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    oid                 INT            NOT NULL COMMENT '订单ID',
    pid                 INT            NOT NULL COMMENT '商品ID',
    price               DECIMAL(10, 2) NOT NULL COMMENT '购买价格',
    quantity            INT            NOT NULL COMMENT '数量',
    subtotal            DECIMAL(10, 2) NOT NULL COMMENT '小计',

    product_name        VARCHAR(200)   NOT NULL COMMENT '订单镜像 商品名称',
    product_description TEXT COMMENT '订单镜像 商品描述',
    product_price       DECIMAL(10, 2) NOT NULL COMMENT '订单镜像 价格',
    product_image       VARCHAR(500) COMMENT '订单镜像 商品图片'
) COMMENT '订单项表';

-- 插入商品数据
INSERT INTO products (name, description, price, stock, sales, image)
VALUES ('iPhone 16 Pro', '苹果最新旗舰手机，搭载A18 Pro仿生芯片，支持5G网络', 7999.00, 50, 120, 'iphone16pro.jpg'),
       ('MacBook Pro', '苹果笔记本电脑，M3芯片，14英寸Liquid Retina XDR显示屏', 15999.00, 30, 85, 'macbookpro.jpg'),
       ('iPad Air', '轻薄便携的平板电脑，10.9英寸屏幕，支持Apple Pencil', 4399.00, 80, 200, 'ipadair.jpg'),
       ('AirPods Pro 2', '主动降噪无线耳机，空间音频技术', 1899.00, 100, 350, 'airpodspro2.jpg'),
       ('Apple Watch Series 10', '智能手表，健康监测，GPS定位', 2999.00, 60, 180, 'applewatch10.jpg'),
       ('华为Mate 70 Pro', '华为旗舰手机，麒麟9010芯片，超感知徕卡摄影', 6999.00, 40, 95, 'huaweimate70pro.jpg'),
       ('小米15S Pro', '小米影像旗舰，徕卡光学镜头，骁龙8 Gen 3', 5999.00, 70, 150, 'xiaomi15spro.png'),
       ('戴尔XPS 13', '轻薄笔记本，13.4英寸InfinityEdge显示屏', 8999.00, 25, 60, 'dellxps13.jpg'),
       ('索尼WH-1000XM6', '无线降噪耳机，30小时续航', 2299.00, 90, 280, 'sonywh1000xm6.jpg'),
       ('任天堂Switch', '便携式游戏机，支持掌机和主机模式', 2099.00, 120, 400, 'nintendoswitch.jpg'),
       ('三星Galaxy S25', '三星旗舰手机，骁龙8 Gen 3处理器', 5499.00, 55, 110, 'samsungs25.jpg'),
       ('联想ThinkPad X1', '商务笔记本，14英寸2.8K显示屏', 12999.00, 20, 45, 'thinkpadx1.jpg');
