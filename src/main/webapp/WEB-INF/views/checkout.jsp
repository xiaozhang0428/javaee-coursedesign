<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>订单结算 - 网上商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<div class="container mt-4">
  <div class="row">
    <div class="col-lg-8">
      <!-- 收货地址 -->
      <div class="card">
        <div class="card-header">
          <h5 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>收货地址</h5>
        </div>
        <div class="card-body">
          <h6 class="mb-1">${sessionScope.user.username}</h6>
          <p class="mb-1">${sessionScope.user.phone}</p>
          <p class="mb-0 text-muted">${sessionScope.user.address}</p>
        </div>
      </div>

      <!-- 商品信息 -->
      <div class="card mt-4">
        <div class="card-header">
          <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>商品信息</h5>
        </div>
        <div class="card-body" id="productList">
          <c:forEach items="${carts}" var="cart">
            <jsp:include page="common/checkout-item.jsp">
              <jsp:param name="image" value="${cart.product.image}"/>
              <jsp:param name="name" value="${cart.product.name}"/>
              <jsp:param name="description" value="${cart.product.description}"/>
              <jsp:param name="quantity" value="${cart.quantity}"/>
              <jsp:param name="subtotal" value="${cart.quantity * cart.product.price}"/>
            </jsp:include>
          </c:forEach>
        </div>
      </div>
    </div>

    <div class="col-lg-4">
      <!-- 订单摘要 -->
      <div class="card p-3">
        <h5 class="mb-3"><i class="fas fa-file-invoice me-2"></i>订单摘要</h5>

        <div class="mt-2">
          <span>商品总价：</span>
          <span id="subtotal">¥${subtotal}</span>
        </div>
        <div class="mt-2">
          <span>运费：</span>
          <span class="text-success">免运费</span>
        </div>
        <div class="mt-2">
          <span>优惠：</span>
          <span class="text-success">-¥0.00</span>
        </div>
        <hr>
        <div class="mt-2">
          <span class="fw-bold">应付总额：</span>
          <span class="fw-bold fs-1 text-danger" id="totalAmount">¥${subtotal}</span>
        </div>

        <div class="mt-4">
          <button class="btn btn-danger btn-lg w-100" id="submit">
            <i class="fas fa-lock me-2"></i>提交订单
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelector('#submit').addEventListener('click', event => {
            // 提交订单
            const productIds = new URLSearchParams(window.location.search).getAll('productIds');
            const resume = showLoading(event.target);
            createOrder(productIds)
                .then(() => showMessage('订单创建成功', {
                    type: 'success',
                    redirect: '${pageContext.request.contextPath}/order/orders'
                }))
                .catch(e => showError(e, {type: 'danger', redirect: '${pageContext.request.contextPath}/order/orders'}))
                .finally(resume);
        })
    });
</script>
</body>
</html>