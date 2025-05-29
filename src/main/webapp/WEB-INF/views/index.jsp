<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>网上商城 - 首页</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- 导航栏 -->
    <jsp:include page="common/header.jsp" />

    <!-- 轮播图 -->
    <div id="carouselExample" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <div class="bg-primary text-white text-center py-5">
                    <div class="container">
                        <h1 class="display-4">欢迎来到网上商城</h1>
                        <p class="lead">精选商品，优质服务，让购物更简单</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-light btn-lg">
                            立即购物
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-5">
        <!-- 热销商品 -->
        <section class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-fire text-danger"></i> 热销商品</h2>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
                    查看更多 <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            
            <div class="row">
                <c:forEach items="${hotProducts}" var="product" varStatus="status">
                    <c:if test="${status.index < 4}">
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="card h-100 product-card">
                                <div class="card-img-top-wrapper">
                                    <img src="${pageContext.request.contextPath}/static/images/products/default.jpg" 
                                         class="card-img-top" alt="${product.name}">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">${product.name}</h5>
                                    <p class="card-text text-muted small">${product.description}</p>
                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="h5 text-danger mb-0">
                                                ¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
                                            </span>
                                            <small class="text-muted">销量: ${product.sales}</small>
                                        </div>
                                        <div class="mt-2">
                                            <a href="${pageContext.request.contextPath}/product?id=${product.id}" 
                                               class="btn btn-primary btn-sm me-2">查看详情</a>
                                            <button class="btn btn-outline-primary btn-sm" 
                                                    onclick="addToCart(${product.id})">
                                                <i class="fas fa-cart-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </section>

        <!-- 最新商品 -->
        <section>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-star text-warning"></i> 最新商品</h2>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
                    查看更多 <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            
            <div class="row">
                <c:forEach items="${latestProducts}" var="product" varStatus="status">
                    <c:if test="${status.index < 4}">
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="card h-100 product-card">
                                <div class="card-img-top-wrapper">
                                    <img src="${pageContext.request.contextPath}/static/images/products/default.jpg" 
                                         class="card-img-top" alt="${product.name}">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">${product.name}</h5>
                                    <p class="card-text text-muted small">${product.description}</p>
                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="h5 text-danger mb-0">
                                                ¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
                                            </span>
                                            <small class="text-muted">库存: ${product.stock}</small>
                                        </div>
                                        <div class="mt-2">
                                            <a href="${pageContext.request.contextPath}/product?id=${product.id}" 
                                               class="btn btn-primary btn-sm me-2">查看详情</a>
                                            <button class="btn btn-outline-primary btn-sm" 
                                                    onclick="addToCart(${product.id})">
                                                <i class="fas fa-cart-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </section>
    </div>

    <!-- 页脚 -->
    <jsp:include page="common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    
    <script>
    // 添加到购物车
    function addToCart(productId) {
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                $.post('${pageContext.request.contextPath}/cart/add', {
                    productId: productId,
                    quantity: 1
                }, function(result) {
                    if (result.success) {
                        showMessage('添加成功', 'success');
                        updateCartCount();
                    } else {
                        showMessage(result.message, 'error');
                    }
                });
            </c:when>
            <c:otherwise>
                showMessage('请先登录', 'warning');
                setTimeout(function() {
                    window.location.href = '${pageContext.request.contextPath}/user/login';
                }, 1500);
            </c:otherwise>
        </c:choose>
    }
    </script>
</body>
</html>