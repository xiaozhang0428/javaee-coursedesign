<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - 网上商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-shopping-cart"></i> 网上商城
            </a>
            
            <div class="navbar-nav me-auto">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/products">商品列表</a>
                    </li>
                </ul>
            </div>
            
            <div class="d-flex align-items-center">
                <form class="d-flex me-3" action="${pageContext.request.contextPath}/products" method="get">
                    <input class="form-control me-2" type="search" name="keyword" placeholder="搜索商品..." 
                           value="${param.keyword}" style="width: 200px;">
                    <button class="btn btn-outline-light" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
                
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" 
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user"></i> ${sessionScope.user.username}
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">个人中心</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/cart/">购物车</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/logout">退出登录</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/user/login">
                                    <i class="fas fa-sign-in-alt"></i> 登录
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/user/register">
                                    <i class="fas fa-user-plus"></i> 注册
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 商品详情 -->
    <div class="container mt-4">
        <!-- 面包屑导航 -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">首页</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">商品列表</a></li>
                <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <div class="row">
            <!-- 商品图片 -->
            <div class="col-md-6">
                <div class="product-image-container">
                    <img src="${pageContext.request.contextPath}/static/images/products/default.jpg" 
                         class="img-fluid rounded" alt="${product.name}">
                </div>
            </div>

            <!-- 商品信息 -->
            <div class="col-md-6">
                <div class="product-info">
                    <h1 class="product-title">${product.name}</h1>
                    
                    <div class="product-price mb-3">
                        <span class="price-current">¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                    </div>
                    
                    <div class="product-meta mb-3">
                        <div class="row">
                            <div class="col-6">
                                <small class="text-muted">库存: ${product.stock}</small>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">销量: ${product.sales}</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="product-description mb-4">
                        <h5>商品描述</h5>
                        <p class="text-muted">${product.description}</p>
                    </div>
                    
                    <!-- 购买选项 -->
                    <div class="purchase-options">
                        <div class="row align-items-center mb-3">
                            <div class="col-3">
                                <label for="quantity" class="form-label">数量:</label>
                            </div>
                            <div class="col-4">
                                <div class="input-group">
                                    <button class="btn btn-outline-secondary" type="button" onclick="decreaseQuantity()">-</button>
                                    <input type="number" class="form-control text-center" id="quantity" value="1" min="1" max="${product.stock}">
                                    <button class="btn btn-outline-secondary" type="button" onclick="increaseQuantity()">+</button>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <c:choose>
                                <c:when test="${product.stock > 0}">
                                    <button class="btn btn-primary btn-lg" onclick="addToCart(${product.id})">
                                        <i class="fas fa-shopping-cart"></i> 加入购物车
                                    </button>
                                    <button class="btn btn-success btn-lg" onclick="buyNow(${product.id})">
                                        <i class="fas fa-bolt"></i> 立即购买
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-secondary btn-lg" disabled>
                                        <i class="fas fa-times"></i> 暂时缺货
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 相关商品推荐 -->
        <c:if test="${not empty relatedProducts}">
            <div class="row mt-5">
                <div class="col-12">
                    <h3 class="mb-4">相关商品推荐</h3>
                    <div class="row">
                        <c:forEach var="relatedProduct" items="${relatedProducts}">
                            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                                <div class="card product-card h-100">
                                    <div class="card-img-top-wrapper">
                                        <img src="${pageContext.request.contextPath}/static/images/products/default.jpg" 
                                             class="card-img-top" alt="${relatedProduct.name}">
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">${relatedProduct.name}</h6>
                                        <p class="card-text text-muted small flex-grow-1">
                                            <c:choose>
                                                <c:when test="${fn:length(relatedProduct.description) > 50}">
                                                    ${fn:substring(relatedProduct.description, 0, 50)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${relatedProduct.description}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <div class="product-price-info d-flex justify-content-between align-items-center">
                                            <div class="price">
                                                <span class="price-current">¥<fmt:formatNumber value="${relatedProduct.price}" pattern="#,##0.00"/></span>
                                            </div>
                                            <div class="sales">
                                                <small class="text-muted">销量: ${relatedProduct.sales}</small>
                                            </div>
                                        </div>
                                        <div class="product-actions mt-2">
                                            <button class="btn btn-primary btn-sm w-100 mb-1" onclick="addToCart(${relatedProduct.id})">
                                                <i class="fas fa-shopping-cart"></i> 加入购物车
                                            </button>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent">
                                        <a href="${pageContext.request.contextPath}/product?id=${relatedProduct.id}" class="btn btn-outline-primary btn-sm w-100">
                                            <i class="fas fa-eye"></i> 查看详情
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- 页脚 -->
    <footer class="bg-dark text-light mt-5 py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>网上商城</h5>
                    <p>基于Spring + SpringMVC + MyBatis的在线购物系统</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p>&copy; 2024 JavaEE课程设计. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- 自定义JavaScript -->
    <script>
        // 增加数量
        function increaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            const maxValue = parseInt(quantityInput.max);
            
            if (currentValue < maxValue) {
                quantityInput.value = currentValue + 1;
            }
        }
        
        // 减少数量
        function decreaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            const minValue = parseInt(quantityInput.min);
            
            if (currentValue > minValue) {
                quantityInput.value = currentValue - 1;
            }
        }
        
        // 添加到购物车
        function addToCart(productId) {
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    const quantity = document.getElementById('quantity').value;
                    
                    fetch('${pageContext.request.contextPath}/cart/add', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'productId=' + productId + '&quantity=' + quantity
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('添加成功！');
                        } else {
                            alert('添加失败：' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('添加失败，请稍后重试');
                    });
                </c:when>
                <c:otherwise>
                    alert('请先登录');
                    window.location.href = '${pageContext.request.contextPath}/user/login';
                </c:otherwise>
            </c:choose>
        }
        
        // 立即购买
        function buyNow(productId) {
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    const quantity = document.getElementById('quantity').value;
                    // 先添加到购物车，然后跳转到购物车页面
                    addToCart(productId);
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/cart/';
                    }, 1000);
                </c:when>
                <c:otherwise>
                    alert('请先登录');
                    window.location.href = '${pageContext.request.contextPath}/user/login';
                </c:otherwise>
            </c:choose>
        }
    </script>
</body>
</html>