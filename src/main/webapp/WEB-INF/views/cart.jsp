<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>购物车 - 网上商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/cart-item.css" rel="stylesheet">
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>
<jsp:include page="common/profile-nav.jsp">
  <jsp:param name="selected_item" value="2"/>
</jsp:include>

<div class="container mt-4">
  <div class="row">
    <div class="col-lg-10">
      <div class="card">
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col">
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="selectAll">
                <label class="form-check-label" for="selectAll">全选</label>
              </div>
            </div>
            <div class="col-auto">
              <button class="btn btn-outline-danger btn-sm" id="deleteSelected">删除选中</button>
            </div>
          </div>
        </div>
        <div class="card-body p-0">
          <c:forEach var="item" items="${cartItems}">
            <jsp:include page="common/cart-item.jsp">
              <jsp:param name="productId" value="${item.productId}"/>
              <jsp:param name="price" value="${item.product.price}"/>
              <jsp:param name="image" value="${item.product.image}"/>
              <jsp:param name="name" value="${item.product.name}"/>
              <jsp:param name="description" value="${item.product.description}"/>
              <jsp:param name="quantity" value="${item.quantity}"/>
            </jsp:include>
          </c:forEach>
        </div>
      </div>
    </div>

    <div class="col-lg-2 position-fixed top-10" style="right: 8%">
      <div class="card">
        <div class="card-header">
          <h5 class="mb-0"><i class="fas fa-calculator"></i> 结算信息</h5>
        </div>
        <div class="card-body">
          <div class="d-flex justify-content-between mb-2">
            <strong>已选商品：</strong>
            <strong id="selectedCount">0</strong>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <strong>商品总价：</strong>
            <strong id="totalPrice">¥0.00</strong>
          </div>
          <hr>
          <div class="d-grid">
            <button class="btn btn-primary btn-lg" id="checkoutBtn" disabled>
              <i class="fas fa-credit-card"></i> 去结算
            </button>
          </div>
        </div>
      </div>

      <div class="card mt-3">
        <div class="card-body text-center">
          <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left"></i> 继续购物
          </a>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>
<script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
</body>
</html>