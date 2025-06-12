<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>订单详情 - 网上商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
  <style>
      .section-content {
          padding: 20px;
      }

      .product-item {
          border-bottom: 1px solid #e9ecef;
          padding: 15px 0;
      }

      .product-item:last-child {
          border-bottom: none;
      }

      .order-actions {
          position: sticky;
          top: 20px;
      }
  </style>
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<div class="container mt-4">
  <!-- 订单头部信息 -->
  <div class="card text-bg-info p-4 mb-3">
    <div class="row align-items-center">
      <div class="col-md-8">
        <h3 class="mb-2">订单详情</h3>
        <p class="mb-1">订单号：${order.id}</p>
        <p class="mb-0">下单时间：<fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
      </div>
      <div class="col-md-4 text-md-end">
        <c:choose>
          <c:when test="${order.status == 'pending'}">
            <span class="badge bg-warning fs-6">待支付</span>
          </c:when>
          <c:when test="${order.status == 'paid'}">
            <span class="badge bg-success fs-6">已支付</span>
          </c:when>
          <c:when test="${order.status == 'shipped'}">
            <span class="badge bg-info fs-6">已发货</span>
          </c:when>
          <c:when test="${order.status == 'completed'}">
            <span class="badge bg-primary fs-6">已完成</span>
          </c:when>
          <c:when test="${order.status == 'cancelled'}">
            <span class="badge bg-danger fs-6">已取消</span>
          </c:when>
          <c:otherwise>
            <span class="badge bg-secondary fs-6">未知状态</span>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-8">
      <!-- 收货信息 -->
      <div class="card">
        <div class="card-header">
          <h5 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>收货信息</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <p class="mb-1"><strong>收货人：</strong>${order.username}</p>
              <p class="mb-1"><strong>联系电话：</strong>${order.phone}</p>
            </div>
            <div class="col-md-6">
              <p class="mb-1"><strong>收货地址：</strong></p>
              <p class="mb-0">${order.address}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- 商品信息 -->
      <div class="card mt-4">
        <div class="card-header">
          <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>商品信息</h5>
        </div>
        <div class="card-body">
          <c:forEach var="item" items="${order.orderItems}">
            <div class="product-item">
              <div class="row align-items-center">
                <div class="col-auto">
                  <img src="${pageContext.request.contextPath}/static/images/products/${item.productImage}"
                       class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;">
                </div>
                <div class="col">
                  <h6 class="mb-1">${item.productName}</h6>
                  <p class="text-muted small mb-0">${item.productDescription}</p>
                </div>
                <div class="col-auto">
                  <span class="text-muted">×${item.quantity}</span>
                </div>
                <div class="col-auto">
                  <span class="fw-bold">
                    <fmt:formatNumber value="${item.price}" pattern="¥#,##0.00"/>
                  </span>
                </div>
                <div class="col-auto">
                  <span class="fw-bold text-danger">
                    <fmt:formatNumber value="${item.price * item.quantity}" pattern="¥#,##0.00"/>
                  </span>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>

    </div>

    <div class="col-lg-4">
      <!-- 订单摘要 -->
      <div class="order-actions">
        <div class="card">
          <div class="card-header">
            <h5 class="mb-0"><i class="fas fa-file-invoice me-2"></i>订单摘要</h5>
          </div>
          <div class="card-body">
            <div class="d-flex justify-content-between mb-2">
              <span>商品总价：</span>
              <span><fmt:formatNumber value="${order.totalAmount}" pattern="¥#,##0.00"/></span>
            </div>
            <div class="d-flex justify-content-between mb-2">
              <span>运费：</span>
              <span class="text-success">免运费</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
              <span>优惠：</span>
              <span class="text-success">-¥0.00</span>
            </div>
            <hr>
            <div class="d-flex justify-content-between">
              <span class="fw-bold">实付金额：</span>
              <span class="fw-bold text-danger fs-5">
                <fmt:formatNumber value="${order.totalAmount}" pattern="¥#,##0.00"/>
              </span>
            </div>
          </div>
        </div>

        <div class="card mt-4">
          <div class="section-content">
            <c:choose>
              <c:when test="${order.status == 'pending'}">
                <button class="btn btn-primary btn-lg w-100 mb-2"
                        onclick="updateOrderState(Math.random() >= 0.5 ? 'paid' : 'shipped')">
                  <i class="fas fa-credit-card me-2"></i>立即支付
                </button>
                <button class="btn btn-danger btn-lg w-100 mb-2" onclick="updateOrderState('cancelled')">
                  <i class="fas fa-x me-2"></i>取消订单
                </button>
              </c:when>
              <c:when test="${order.status == 'paid' || order.status == 'shipped'}">
                <button class="btn btn-success btn-lg w-100 mb-2" onclick="updateOrderState('completed')">
                  <i class="fas fa-check me-2"></i>确认收货
                </button>
                <button class="btn btn-danger btn-lg w-100 mb-2" onclick="updateOrderState('cancelled')">
                  <i class="fas fa-x me-2"></i>取消订单
                </button>
              </c:when>
            </c:choose>

            <div class="mt-3">
              <a href="${pageContext.request.contextPath}/order/orders" class="btn btn-outline-secondary w-100">
                <i class="fas fa-arrow-left me-2"></i>返回订单列表
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    function updateOrderState(state) {
        updateStatus(${order.id}, state)
            .then(() => showMessage('成功', {type: 'success', reload: true}))
            .catch(showError);
    }
</script>
</body>
</html>