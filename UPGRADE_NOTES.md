# Java 17 + Spring 6 升级说明

## 升级内容

### 1. Java版本升级
- **从**: Java 8
- **到**: Java 17

### 2. Spring Framework升级
- **从**: Spring 5.3.21
- **到**: Spring 6.2.7 (最新稳定版)

### 3. 主要依赖升级

#### 核心框架
- Spring Framework: 5.3.21 → 6.2.7
- MyBatis: 3.5.10 → 3.5.19
- MyBatis-Spring: 2.0.7 → 3.0.4

#### Jakarta EE迁移
- Servlet API: javax.servlet → jakarta.servlet 6.1.0
- JSP API: javax.servlet.jsp → jakarta.servlet.jsp 4.0.0
- JSTL: javax.servlet.jstl → org.glassfish.web.jakarta.servlet.jsp.jstl 3.0.1

#### 其他依赖
- Jackson: 2.13.3 → 2.18.2
- MariaDB Driver: 3.0.6 → 3.5.3
- SLF4J: 1.7.36 → 2.0.16
- Logback: 1.2.11 → 1.5.15
- JUnit: 4.13.2 → JUnit Jupiter 5.11.4

#### 构建工具
- Maven Compiler Plugin: 3.8.1 → 3.13.0
- Maven WAR Plugin: 3.2.3 → 3.4.0
- Maven Surefire Plugin: 新增 3.5.2

## 重要变更

### 1. 包名变更 (javax → jakarta)
所有使用 `javax.servlet` 的代码已更新为 `jakarta.servlet`：
- `javax.servlet.http.HttpSession` → `jakarta.servlet.http.HttpSession`

### 2. Web.xml更新
- 命名空间从 `http://xmlns.jcp.org/xml/ns/javaee` 更新为 `https://jakarta.ee/xml/ns/jakartaee`
- 版本从 4.0 更新为 6.0
- 添加了multipart配置支持

### 3. JSP标签库更新
所有JSP文件中的JSTL标签库URI已更新：
- `http://java.sun.com/jsp/jstl/core` → `jakarta.tags.core`
- `http://java.sun.com/jsp/jstl/fmt` → `jakarta.tags.fmt`

### 4. 文件上传配置
- 从 `CommonsMultipartResolver` 更改为 `StandardServletMultipartResolver`
- 在web.xml中添加了multipart配置

### 5. 测试框架
- 从JUnit 4迁移到JUnit 5 Jupiter

## 兼容性要求

### 运行时要求
- **Java**: 17或更高版本
- **Servlet容器**: 支持Jakarta EE 9+的容器
  - Tomcat 10.0+
  - Jetty 11+
  - 或其他支持Jakarta EE 9+的容器

### 开发环境
- **IDE**: 确保IDE支持Java 17和Jakarta EE
- **Maven**: 3.6.3或更高版本

## 构建和运行

### 编译项目
```bash
mvn clean compile
```

### 运行测试
```bash
mvn test
```

### 打包项目
```bash
mvn clean package
```

### 部署
生成的WAR文件需要部署到支持Jakarta EE 9+的Servlet容器中。

## 注意事项

1. **容器兼容性**: 确保使用的Servlet容器支持Jakarta EE 9+
2. **第三方库**: 如果项目使用了其他第三方库，请确保它们也兼容Jakarta EE
3. **IDE配置**: 更新IDE的项目设置以使用Java 17
4. **CI/CD**: 更新构建管道以使用Java 17

## 升级后的优势

1. **性能提升**: Java 17和Spring 6带来的性能优化
2. **安全性**: 最新版本的安全修复和改进
3. **现代化**: 使用最新的Java特性和Spring功能
4. **长期支持**: Java 17是LTS版本，Spring 6有长期支持
5. **生态系统**: 更好的与现代Java生态系统集成