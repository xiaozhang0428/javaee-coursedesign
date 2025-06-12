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
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/product-card.css" rel="stylesheet">
</head>
<body>
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<!-- 商品详情 -->
<div class="container mt-4">
  <nav aria-label="breadcrumb">
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">首页</a></li>
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">商品列表</a></li>
      <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
    </ol>
  </nav>

  <div class="row">
    <div class="col-md-6 product-image-container">
      <img src="${pageContext.request.contextPath}/static/images/products/${product.image}" class="img-fluid rounded">
    </div>

    <div class="col-md-6">
      <div class="product-info">
        <h1 class="product-title">${product.name}</h1>

        <div class="product-price mb-3">
          <span class="price-current">¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
        </div>

        <div class="product-meta mb-3">
          <div class="row">
            <small class="col-6 text-muted">库存: ${product.stock}</small>
            <small class="col-6 text-muted">销量: ${product.sales}</small>
          </div>
        </div>

        <p class="text-muted product-description mb-4">${product.description}</p>

        <div class="purchase-options mt-5">
          <div class="row align-items-center mb-3">
            <label for="quantity" class="col-3 form-label">数量:</label>
            <div class="col-4">
              <div class="input-group">
                <button class="btn btn-outline-secondary" type="button" onclick="decreaseQuantity()">-</button>
                <input type="number" class="form-control text-center" id="quantity" value="1" min="1"
                       max="${product.stock}">
                <button class="btn btn-outline-secondary" type="button" onclick="increaseQuantity()">+</button>
              </div>
            </div>
          </div>

          <div class="d-grid gap-2">
            <c:choose>
              <c:when test="${product.stock > 0}">
                <button class="btn btn-primary btn-lg" onclick="addOrBuy(undefined)">
                  <i class="fas fa-shopping-cart"></i> 加入购物车
                </button>
                <button class="btn btn-success btn-lg" onclick="addOrBuy('${pageContext.request.contextPath}/cart/')">
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
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    // +
    function increaseQuantity() {
        const quantityInput = document.querySelector("#quantity");
        quantityInput.value = Math.min(parseInt(quantityInput.value) + 1, parseInt(quantityInput.max));
    }

    // -
    function decreaseQuantity() {
        const quantityInput = document.querySelector("#quantity");
        quantityInput.value = Math.max(parseInt(quantityInput.value) - 1, 1);
    }

    function addOrBuy(redirect) {
        <c:choose>
        <c:when test="${sessionScope.user != null}">
        addToCart(${product.id}, document.querySelector('#quantity').value)
            .then(message => showMessage(message, {type: 'success', redirect}))
            .catch(showError);
        </c:when>
        <c:otherwise>
        showMessage('请先登录', {type: 'warning', redirect: '${pageContext.request.contextPath}/user/login'});
        </c:otherwise>
        </c:choose>
    }
</script>
</body>
</html>