use javaee_shop;

-- 关闭外键检查
SET FOREIGN_KEY_CHECKS = 0;

-- 商品表
CREATE TABLE products
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100)   NOT NULL, -- 商品名称
    description TEXT,                    -- 商品描述
    price       DECIMAL(10, 2) NOT NULL, -- 商品价格
    stock       INT     DEFAULT 0,       -- 库存数量
    sales       INT     DEFAULT 0,       -- 销量
    status      TINYINT DEFAULT 1,       -- 商品状态（1-正常，0-下架）
    category_id INT,                     -- 分类ID
    create_time DATETIME                 -- 上架时间
);

-- 用户表
CREATE TABLE users
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    username    VARCHAR(50) UNIQUE NOT NULL, -- 账号
    password    VARCHAR(100)       NOT NULL, -- 密码
    email       VARCHAR(50),                 -- 邮箱
    phone       VARCHAR(20),                 -- 联系电话
    address     VARCHAR(200),                -- 收货地址
    create_time DATETIME                     -- 注册时间
);

-- 订单表
CREATE TABLE orders
(
    id               INT PRIMARY KEY AUTO_INCREMENT, -- 订单号
    user_id          INT NOT NULL,
    total_amount     DECIMAL(10, 2),                 -- 订单总金额
    status           TINYINT DEFAULT 0,              -- 订单状态（0-待支付，1-已支付，2-已发货，3-已完成）
    shipping_address VARCHAR(200),                   -- 收货地址
    create_time      DATETIME                        -- 下单时间
);

-- 订单明细表
CREATE TABLE order_items
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    order_id   INT            NOT NULL,            -- 修改为INT类型
    product_id INT            NOT NULL,
    quantity   INT            NOT NULL,            -- 购买数量
    price      DECIMAL(10, 2) NOT NULL             -- 商品单价
);

-- 购物车表
CREATE TABLE carts
(
    user_id    INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL, -- 购买数量

    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
);

SET FOREIGN_KEY_CHECKS = 1;
