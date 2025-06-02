# 购物车图片显示问题修复指南

## 问题描述
购物车页面中商品图片无法显示，显示为空白或破损图片图标。

## 问题原因
1. **数据库表缺少image字段**：`products`表中没有`image`字段来存储商品图片路径
2. **图片文件名不匹配**：数据库中的图片文件名与实际存储的图片文件名不一致

## 解决方案

### 1. 数据库修复
执行以下SQL脚本来修复数据库：

```bash
# 方法1：使用修复脚本
mysql -u shop -pshop123 javaee_shop < fix_cart_images.sql

# 方法2：重新初始化数据库（会清空现有数据）
mysql -u shop -pshop123 < src/main/resources/sql/init.sql
```

### 2. 文件修改说明

#### 已修复的文件：
1. **database.sql** - 添加了image字段定义
2. **init.sql** - 更新了商品数据，图片文件名与实际文件匹配
3. **购物车相关页面** - 添加了图片错误处理：
   - `cart.jsp` - 购物车页面
   - `product-detail.jsp` - 商品详情页面
   - `product-card.jsp` - 商品卡片组件
   - `order-detail.jsp` - 订单详情页面
   - `orders.jsp` - 订单列表页面
   - `checkout.jsp` - 结算页面

#### 图片错误处理机制：
- 当image字段为空时，自动使用默认图片
- 当图片文件不存在时，通过`onerror`事件自动切换到默认图片
- 默认图片：`/static/images/products/default.jpg`

### 3. 图片文件映射

| 商品类型 | 图片文件名 |
|---------|-----------|
| iPhone 16 Pro | iphone16pro.jpg |
| MacBook Pro | macbookpro.jpg |
| iPad Air | ipadair.jpg |
| AirPods Pro 2 | airpodspro2.jpg |
| Apple Watch Series 10 | applewatch10.jpg |
| 华为Mate 70 Pro | huaweimate70pro.jpg |
| 小米15S Pro | xiaomi15spro.png |
| 戴尔XPS 13 | dellxps13.jpg |
| 索尼WH-1000XM6 | sonywh1000xm6.jpg |
| 任天堂Switch | nintendoswitch.jpg |
| 三星Galaxy S25 | samsungs25.jpg |
| 联想ThinkPad X1 | thinkpadx1.jpg |

### 4. 验证修复

1. **启动应用**：
   ```bash
   mvn clean package
   # 部署到Tomcat并启动
   ```

2. **测试步骤**：
   - 登录系统
   - 浏览商品列表，确认商品图片正常显示
   - 添加商品到购物车
   - 查看购物车页面，确认图片正常显示
   - 进行结算，确认结算页面图片正常显示

3. **检查数据库**：
   ```sql
   USE javaee_shop;
   SELECT id, name, image FROM products LIMIT 5;
   ```

### 5. 技术细节

#### Entity类
`Product.java`中已包含image字段：
```java
private String image;
```

#### MyBatis映射
`ProductMapper.xml`中已包含image字段映射：
```xml
<result property="image" column="image"/>
```

#### JSP页面
所有相关页面都使用了以下模式：
```jsp
<img src="${pageContext.request.contextPath}/static/images/products/${empty item.product.image ? 'default.jpg' : item.product.image}"
     onerror="this.src='${pageContext.request.contextPath}/static/images/products/default.jpg'">
```

## 注意事项
1. 确保数据库用户有ALTER TABLE权限
2. 备份数据库后再执行修复脚本
3. 确认图片文件存在于`src/main/webapp/static/images/products/`目录
4. 如果添加新商品，确保设置正确的image字段值

## 相关文件
- `fix_cart_images.sql` - 数据库修复脚本
- `database.sql` - 更新后的数据库结构
- `src/main/resources/sql/init.sql` - 完整的初始化脚本
- 所有包含商品图片显示的JSP页面