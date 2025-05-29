# JavaEE 课程设计 - 网上商城系统

基于 Spring + SpringMVC + MyBatis + MariaDB 的在线购物系统

## 项目简介

这是一个完整的电商网站系统，实现了商品浏览、用户管理、购物车、订单管理等核心功能。

## 技术栈

- **后端框架**: Spring 5.3.39 + SpringMVC
- **持久层**: MyBatis 3.5.19 + MyBatis-Spring 2.1.2
- **数据库**: MariaDB 10.6+ (驱动版本 3.5.3)
- **数据源**: Spring DriverManagerDataSource
- **JSON处理**: Jackson 2.19.0
- **前端**: Bootstrap 5.1.3 + jQuery 3.6.0
- **构建工具**: Maven 3.6+
- **JDK版本**: 1.8+

## 功能特性

### 用户功能
- 用户注册/登录
- 个人信息管理
- 商品浏览和搜索
- 购物车管理
- 订单查看

### 商品功能
- 商品列表展示
- 商品详情查看
- 商品搜索
- 热销商品推荐
- 最新商品展示

### 购物车功能
- 添加商品到购物车
- 修改商品数量
- 删除购物车商品
- 购物车总价计算

## 项目结构

```
javaee-coursedesign/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/shop/
│   │   │       ├── controller/     # 控制器层
│   │   │       ├── service/        # 服务层
│   │   │       ├── dao/           # 数据访问层
│   │   │       ├── entity/        # 实体类
│   │   │       └── util/          # 工具类
│   │   ├── resources/
│   │   │   ├── mapper/            # MyBatis映射文件
│   │   │   ├── spring/            # Spring配置文件
│   │   │   ├── sql/               # 数据库脚本
│   │   │   └── database.properties # 数据库配置
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/         # JSP页面
│   │       │   └── web.xml        # Web配置
│   │       └── static/            # 静态资源
│   └── test/                      # 测试代码
└── pom.xml                        # Maven配置
```

## 数据库设计

### 主要表结构

1. **users** - 用户表
   - id, username, password, email, phone, address, create_time

2. **products** - 商品表
   - id, name, description, price, stock, sales, image, status, create_time

3. **cart** - 购物车表
   - id, user_id, product_id, quantity, create_time

4. **orders** - 订单表
   - id, user_id, total_amount, status, shipping_address, create_time

5. **order_items** - 订单项表
   - id, order_id, product_id, product_name, product_price, quantity, subtotal

## 快速开始

### 1. 环境要求

- JDK 1.8+
- Maven 3.6+
- MariaDB 10.6+
- Tomcat 9.0+

### 2. 数据库配置

1. 安装并启动 MariaDB
2. 执行 `src/main/resources/sql/init.sql` 创建数据库和表
3. 修改 `src/main/resources/database.properties` 中的数据库连接信息

```properties
jdbc.driver=org.mariadb.jdbc.Driver
jdbc.url=jdbc:mariadb://localhost:3306/javaee_shop?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
jdbc.username=javaee
jdbc.password=javaee
```

### 3. 编译和部署

```bash
# 编译项目
mvn clean compile

# 打包项目
mvn clean package

# 部署到Tomcat
# 将生成的 war 包复制到 Tomcat 的 webapps 目录
```

### 4. 访问系统

启动 Tomcat 后，访问：`http://localhost:8080/javaee-coursedesign`

### 5. 测试账号

- 管理员：admin / admin
- 普通用户：user1 / 123456
- 普通用户：user2 / 123456

## 主要页面

- **首页** (`/`) - 展示热销商品和最新商品
- **商品列表** (`/products`) - 商品浏览和搜索
- **商品详情** (`/product?id=1`) - 商品详细信息
- **用户登录** (`/user/login`) - 用户登录页面
- **用户注册** (`/user/register`) - 用户注册页面
- **购物车** (`/cart/`) - 购物车管理
- **个人中心** (`/user/profile`) - 用户信息管理

## API 接口

### 用户相关
- `POST /user/doLogin` - 用户登录
- `POST /user/doRegister` - 用户注册
- `GET /user/logout` - 用户退出
- `POST /user/updateProfile` - 更新个人信息

### 购物车相关
- `POST /cart/add` - 添加商品到购物车
- `POST /cart/update` - 更新购物车商品数量
- `POST /cart/remove` - 删除购物车商品
- `POST /cart/clear` - 清空购物车
- `GET /cart/count` - 获取购物车商品数量

## 开发说明

### 配置文件说明

1. **applicationContext.xml** - Spring 核心配置
2. **spring-mvc.xml** - SpringMVC 配置
3. **web.xml** - Web 应用配置
4. **database.properties** - 数据库连接配置

### 代码规范

- 使用 UTF-8 编码
- 遵循 Java 命名规范
- 添加必要的注释
- 使用 Spring 注解进行依赖注入

### 扩展功能

可以继续添加以下功能：
- 订单管理系统
- 商品分类管理
- 用户权限管理
- 商品评价系统
- 支付集成
- 图片上传功能

## 常见问题

1. **数据库连接失败**
   - 检查 MariaDB 是否启动
   - 确认数据库连接信息是否正确
   - 检查数据库用户权限

2. **页面显示异常**
   - 检查 JSP 页面路径
   - 确认静态资源路径正确
   - 查看浏览器控制台错误信息

3. **中文乱码问题**
   - 确保所有文件使用 UTF-8 编码
   - 检查数据库字符集设置
   - 确认 web.xml 中的字符编码过滤器

## 版本更新历史

### v1.1.0 (2025-05-29)
- 升级 Spring Framework 从 5.3.21 到 5.3.39
- 升级 MyBatis 从 3.5.10 到 3.5.19
- 升级 MyBatis-Spring 从 2.0.7 到 2.1.2
- 升级 MariaDB 驱动从 3.0.6 到 3.5.3
- 升级 Jackson 从 2.13.3 到 2.19.0
- 移除 Druid 连接池依赖，使用 Spring 原生 DriverManagerDataSource
- 优化项目结构和配置

### v1.0.0 (2025-05-29)
- 完整的 JavaEE 电商系统实现
- 基于 Spring + SpringMVC + MyBatis 三层架构
- 用户注册登录、商品管理、购物车、订单功能
- 响应式前端界面设计

## 许可证

本项目仅用于学习和教学目的。

## 联系方式

如有问题，请联系开发者。