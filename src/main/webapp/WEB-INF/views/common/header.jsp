<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-shopping-cart"></i> 网上商城
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/">首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">商品列表</a>
                </li>
            </ul>
            
            <!-- 搜索框 -->
            <form class="d-flex me-3" action="${pageContext.request.contextPath}/products" method="get">
                <input class="form-control me-2" type="search" name="keyword" placeholder="搜索商品..." 
                       value="${param.keyword}" autocomplete="off" id="searchInput">
                <button class="btn btn-outline-light" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </form>
            
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <!-- 已登录用户 -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/cart/">
                                <i class="fas fa-shopping-cart"></i> 购物车 
                                <span class="badge bg-warning text-dark" id="cartCount">0</span>
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" 
                               data-bs-toggle="dropdown">
                                <i class="fas fa-user"></i> ${sessionScope.user.username}
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                                    <i class="fas fa-user-cog"></i> 个人中心</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/logout">
                                    <i class="fas fa-sign-out-alt"></i> 退出登录</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- 未登录用户 -->
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

<script>
// 更新购物车数量
function updateCartCount() {
    <c:if test="${not empty sessionScope.user}">
    $.get('${pageContext.request.contextPath}/cart/count', function(result) {
        if (result.success) {
            $('#cartCount').text(result.data);
        }
    });
    </c:if>
}

// 页面加载时更新购物车数量
$(document).ready(function() {
    updateCartCount();
});

// 搜索自动补全
$('#searchInput').on('input', function() {
    var keyword = $(this).val();
    if (keyword.length > 1) {
        // 这里可以实现搜索建议功能
        // 暂时省略具体实现
    }
});
</script>