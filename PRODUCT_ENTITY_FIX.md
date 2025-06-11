# 🔧 Product实体类字段映射修复

## 🚨 问题描述

用户点击"我的订单"页面时出现以下错误：

```
jakarta.servlet.ServletException: Request processing failed: org.mybatis.spring.MyBatisSystemException: 
### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: 
Could not set property 'categoryId' of 'class com.shop.entity.Product' with value '1' 
Cause: org.apache.ibatis.reflection.ReflectionException: 
There is no setter for property named 'categoryId' in 'class com.shop.entity.Product'
```

## 🔍 根本原因

1. **实体类字段缺失**: Product.java中的`categoryId`字段被注释掉了
2. **映射配置错误**: OrderMapper.xml中仍然尝试映射不存在的`categoryId`字段
3. **SQL查询不匹配**: 查询语句包含了实体类中不存在的字段

## 🛠️ 修复方案

### 1. 检查Product实体类

```java
@Data
public class Product {
    private int id;
    private String name;
    private String description;
    private BigDecimal price;
    private int stock;
    private int sales;
    private String image;
    private int status;
    // 注释掉数据库中不存在的字段
    // private int categoryId;  ← 这个字段被注释掉了
    // private Date createTime;
}
```

### 2. 修复OrderMapper.xml映射

#### ❌ 修复前 - 包含不存在的字段
```xml
<association property="product" javaType="Product">
    <id property="id" column="product_id"/>
    <result property="name" column="p_name"/>
    <result property="description" column="p_description"/>
    <result property="price" column="p_price"/>
    <result property="image" column="p_image"/>
    <result property="categoryId" column="p_category_id"/>  ← 错误：字段不存在
    <result property="stock" column="p_stock"/>
</association>
```

#### ✅ 修复后 - 只映射存在的字段
```xml
<association property="product" javaType="Product">
    <id property="id" column="product_id"/>
    <result property="name" column="p_name"/>
    <result property="description" column="p_description"/>
    <result property="price" column="p_price"/>
    <result property="image" column="p_image"/>
    <result property="stock" column="p_stock"/>
    <result property="sales" column="p_sales"/>
    <result property="status" column="p_status"/>
</association>
```

### 3. 更新SQL查询语句

#### ❌ 修复前 - 查询不存在的字段
```sql
SELECT o.id, o.user_id, o.total_amount, o.status, o.shipping_address, o.create_time,
       u.username, u.email, u.phone, u.address,
       oi.id as item_id, oi.order_id, oi.product_id, oi.quantity, 
       oi.product_name, oi.product_price, oi.subtotal, oi.price as item_price,
       p.name as p_name, p.description as p_description, p.price as p_price,
       p.image as p_image, p.category_id as p_category_id, p.stock as p_stock  ← 错误字段
FROM orders o
LEFT JOIN users u ON o.user_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
WHERE o.user_id = #{userId}
ORDER BY o.create_time DESC, oi.id
```

#### ✅ 修复后 - 只查询存在的字段
```sql
SELECT o.id, o.user_id, o.total_amount, o.status, o.shipping_address, o.create_time,
       u.username, u.email, u.phone, u.address,
       oi.id as item_id, oi.order_id, oi.product_id, oi.quantity, 
       oi.product_name, oi.product_price, oi.subtotal, oi.price as item_price,
       p.name as p_name, p.description as p_description, p.price as p_price,
       p.image as p_image, p.stock as p_stock, p.sales as p_sales, p.status as p_status
FROM orders o
LEFT JOIN users u ON o.user_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
WHERE o.user_id = #{userId}
ORDER BY o.create_time DESC, oi.id
```

## 📊 修复对比

| 项目 | 修复前 | 修复后 | 状态 |
|------|--------|--------|------|
| **categoryId字段** | 尝试映射不存在的字段 | 移除映射 | ✅ 修复 |
| **sales字段** | 未映射 | 正确映射 | ✅ 新增 |
| **status字段** | 未映射 | 正确映射 | ✅ 新增 |
| **SQL查询** | 包含错误字段 | 只查询存在字段 | ✅ 修复 |
| **编译状态** | 运行时错误 | 编译成功 | ✅ 修复 |

## 🔧 修改的文件

### 1. src/main/resources/mapper/OrderMapper.xml

#### 修改内容：
- 移除Product映射中的`categoryId`字段
- 添加`sales`和`status`字段映射
- 更新findById和findByUserId查询语句
- 确保SQL查询与实体类字段完全匹配

#### 影响的查询：
- `findById` - 根据订单ID查询订单详情
- `findByUserId` - 根据用户ID查询订单列表

## ✅ 验证结果

### 1. 编译验证
```bash
mvn clean compile
# [INFO] BUILD SUCCESS - 编译成功
```

### 2. 字段映射验证
- ✅ 移除了不存在的`categoryId`字段映射
- ✅ 添加了存在的`sales`和`status`字段映射
- ✅ SQL查询与实体类字段完全匹配

### 3. 功能验证
- ✅ "我的订单"页面应该能正常加载
- ✅ 订单详情页面应该能正常显示
- ✅ 商品信息应该能正确显示（除了categoryId）

## 🎯 预期效果

修复后，用户应该能够：
- ✅ 正常访问"我的订单"页面
- ✅ 查看订单列表和详情
- ✅ 看到商品的基本信息（名称、描述、价格、图片、库存、销量、状态）
- ✅ 进行订单相关操作（支付、取消、确认收货等）

## 🚨 注意事项

### 1. 数据库字段检查
如果将来需要添加categoryId字段，需要：
1. 确认数据库表中存在category_id字段
2. 在Product.java中取消注释categoryId字段
3. 在OrderMapper.xml中添加相应的映射

### 2. 向后兼容性
- ✅ 此修复不影响现有功能
- ✅ 只是移除了错误的字段映射
- ✅ 保持了所有正确的字段映射

### 3. 性能影响
- ✅ 减少了无效的字段查询
- ✅ 提高了查询效率
- ✅ 避免了运行时反射错误

---

**修复类型**: Critical Bug Fix - Entity Field Mapping  
**优先级**: High - 阻塞用户核心功能  
**影响范围**: 订单查询功能  
**风险等级**: Low - 只移除错误映射，不影响正确功能  
**测试状态**: 编译通过，待功能验证  

这个修复解决了Product实体类字段映射不匹配导致的运行时错误，确保"我的订单"页面能够正常工作。