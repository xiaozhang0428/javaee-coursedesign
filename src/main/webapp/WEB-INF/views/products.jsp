<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品列表 - 网上商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- 导航栏 -->
    <jsp:include page="common/header.jsp" />

    <div class="container mt-4">
        <!-- 搜索和筛选区域 -->
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="input-group">
                    <input type="text" class="form-control" id="searchKeyword" 
                           placeholder="搜索商品..." value="${param.keyword}">
                    <button class="btn btn-primary" type="button" id="searchBtn">
                        <i class="fas fa-search"></i> 搜索
                    </button>
                </div>
            </div>
            <div class="col-md-4">
                <select class="form-select" id="sortSelect">
                    <option value="default">默认排序</option>
                    <option value="price_asc">价格从低到高</option>
                    <option value="price_desc">价格从高到低</option>
                    <option value="sales_desc">销量从高到低</option>
                    <option value="create_time_desc">最新商品</option>
                </select>
            </div>
        </div>

        <!-- 商品列表 -->
        <div class="row" id="productList">
            <c:forEach var="product" items="${products}">
                <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="card product-card h-100">
                        <div class="card-img-top-wrapper">
                            <img src="${pageContext.request.contextPath}/static/images/products/${product.image}" 
                                 class="card-img-top" alt="${product.name}"
                                 onerror="this.src='${pageContext.request.contextPath}/static/images/products/default.jpg'">
                        </div>
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title">${product.name}</h6>
                            <p class="card-text text-muted small flex-grow-1">
                                <c:choose>
                                    <c:when test="${fn:length(product.description) > 50}">
                                        ${fn:substring(product.description, 0, 50)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${product.description}
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="price h5 mb-0">
                                    <fmt:formatNumber value="${product.price}" pattern="¥#,##0.00"/>
                                </span>
                                <small class="text-muted">销量: ${product.sales}</small>
                            </div>
                            <div class="mt-2">
                                <c:choose>
                                    <c:when test="${product.stock > 0}">
                                        <button class="btn btn-primary btn-sm w-100 add-to-cart" 
                                                data-product-id="${product.id}">
                                            <i class="fas fa-cart-plus"></i> 加入购物车
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-secondary btn-sm w-100" disabled>
                                            <i class="fas fa-times"></i> 暂时缺货
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent">
                            <a href="${pageContext.request.contextPath}/product?id=${product.id}" 
                               class="btn btn-outline-primary btn-sm w-100">
                                <i class="fas fa-eye"></i> 查看详情
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 空状态 -->
        <c:if test="${empty products}">
            <div class="empty-state">
                <i class="fas fa-search"></i>
                <h4>没有找到相关商品</h4>
                <p>请尝试其他关键词或浏览所有商品</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    <i class="fas fa-list"></i> 浏览所有商品
                </a>
            </div>
        </c:if>

        <!-- 分页 -->
        <c:if test="${not empty products}">
            <nav aria-label="商品分页">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&sort=${param.sort}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&keyword=${param.keyword}&sort=${param.sort}">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&sort=${param.sort}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- 页脚 -->
    <jsp:include page="common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    
    <script>
    $(document).ready(function() {
        // 搜索功能
        $('#searchBtn').on('click', function() {
            performSearch();
        });
        
        $('#searchKeyword').on('keypress', function(e) {
            if (e.which === 13) {
                performSearch();
            }
        });
        
        function performSearch() {
            var keyword = $('#searchKeyword').val().trim();
            var sort = $('#sortSelect').val();
            var url = '${pageContext.request.contextPath}/products';
            var params = [];
            
            if (keyword) {
                params.push('keyword=' + encodeURIComponent(keyword));
            }
            if (sort && sort !== 'default') {
                params.push('sort=' + sort);
            }
            
            if (params.length > 0) {
                url += '?' + params.join('&');
            }
            
            window.location.href = url;
        }
        
        // 排序功能
        $('#sortSelect').on('change', function() {
            performSearch();
        });
        
        // 设置当前排序选项
        var currentSort = '${param.sort}';
        if (currentSort) {
            $('#sortSelect').val(currentSort);
        }
        
        // 加入购物车
        $('.add-to-cart').on('click', function() {
            var productId = $(this).data('product-id');
            var button = $(this);
            
            showLoading(button[0]);
            
            $.post('${pageContext.request.contextPath}/cart/add', {
                productId: productId,
                quantity: 1
            }, function(result) {
                hideLoading(button[0]);
                if (result.success) {
                    showMessage('商品已加入购物车', 'success');
                    // 更新购物车数量显示
                    updateCartCount();
                } else {
                    showMessage(result.message, 'error');
                }
            }).fail(function() {
                hideLoading(button[0]);
                showMessage('加入购物车失败，请稍后重试', 'error');
            });
        });
        
        // 更新购物车数量
        function updateCartCount() {
            $.get('${pageContext.request.contextPath}/cart/count', function(result) {
                if (result.success) {
                    $('.cart-count').text(result.data);
                }
            });
        }
    });
    </script>
</body>
</html>