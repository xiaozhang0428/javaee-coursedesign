<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>我的订单 - 网上商城</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
  <style>
      .order-card {
          border: 1px solid #e0e0e0;
          border-radius: 8px;
          margin-bottom: 20px;
          transition: box-shadow 0.3s ease;
      }

      .order-card:hover {
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }

      .order-header {
          background-color: #f8f9fa;
          padding: 15px;
          border-bottom: 1px solid #e0e0e0;
          border-radius: 8px 8px 0 0;
      }

      .order-status {
          font-weight: bold;
      }

      .status-pending {
          color: #ffc107;
      }

      .status-paid {
          color: #28a745;
      }

      .status-shipped {
          color: #17a2b8;
      }

      .status-delivered {
          color: #6f42c1;
      }

      .status-cancelled {
          color: #dc3545;
      }

      .empty-orders {
          text-align: center;
          padding: 60px 20px;
          color: #6c757d;
      }

      .empty-orders i {
          font-size: 4rem;
          margin-bottom: 20px;
          color: #dee2e6;
      }
  </style>
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>
<jsp:include page="common/profile_nav.jsp">
  <jsp:param name="selected_item" value="1"/>
</jsp:include>

<div class="container mt-4">
  <div class="row">
    <div class="col-md-10">
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0"><i class="fas fa-shopping-bag me-2"></i>我的订单</h5>
          <div class="btn-group" role="group">
            <input type="radio" class="btn-check" name="orderStatus" id="all" value="" checked>
            <label class="btn btn-outline-primary" for="all">全部</label>

            <input type="radio" class="btn-check" name="orderStatus" id="pending" value="pending">
            <label class="btn btn-outline-warning" for="pending">待付款</label>

            <input type="radio" class="btn-check" name="orderStatus" id="paid" value="paid">
            <label class="btn btn-outline-success" for="paid">已付款</label>

            <input type="radio" class="btn-check" name="orderStatus" id="shipped" value="shipped">
            <label class="btn btn-outline-info" for="shipped">已发货</label>

            <input type="radio" class="btn-check" name="orderStatus" id="delivered" value="delivered">
            <label class="btn btn-outline-secondary" for="delivered">已完成</label>
          </div>
        </div>
        <div class="card-body">
          <!-- 订单列表 -->
          <div id="orderList">
            <c:choose>
              <c:when test="${empty orders}">
                <!-- 暂无订单 -->
                <div class="empty-orders">
                  <i class="fas fa-shopping-bag"></i>
                  <h4>暂无订单</h4>
                  <p class="mb-3">您还没有任何订单，快去购买商品吧！</p>
                  <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    <i class="fas fa-shopping-cart me-2"></i>去购物
                  </a>
                </div>
              </c:when>
              <c:otherwise>
                <!-- 订单列表 -->
                <c:forEach var="order" items="${orders}">
                  <div class="order-card" data-status="${order.status}">
                    <div class="order-header">
                      <div class="row align-items-center">
                        <div class="col-md-3">
                          <strong>订单号：</strong>${order.id}
                        </div>
                        <div class="col-md-3">
                          <strong>下单时间：</strong>
                          <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>
                        <div class="col-md-3">
                          <strong>订单金额：</strong>
                          <fmt:formatNumber value="${order.totalAmount}" pattern="¥#,##0.00"/>
                        </div>
                        <div class="col-md-3 text-end">
                          <c:choose>
                            <c:when test="${order.status == 0}">
                              <span class="order-status status-pending">待支付</span>
                            </c:when>
                            <c:when test="${order.status == 1}">
                              <span class="order-status status-paid">已支付</span>
                            </c:when>
                            <c:when test="${order.status == 2}">
                              <span class="order-status status-shipped">已发货</span>
                            </c:when>
                            <c:when test="${order.status == 3}">
                              <span class="order-status status-delivered">已完成</span>
                            </c:when>
                            <c:when test="${order.status == -1}">
                              <span class="order-status status-cancelled">已取消</span>
                            </c:when>
                          </c:choose>
                        </div>
                      </div>
                    </div>
                    <div class="card-body">
                      <c:forEach var="item" items="${order.orderItems}" varStatus="status">
                        <c:if test="${status.index < 3}">
                          <div class="row align-items-center mb-3">
                            <div class="col-md-2">
                              <img src="${pageContext.request.contextPath}/static/images/products/${empty item.product.image ? 'default.jpg' : item.product.image}" 
                                   class="img-fluid rounded" style="width: 80px; height: 80px; object-fit: cover;"
                                   alt="${item.product.name}"
                                   onerror="this.src='${pageContext.request.contextPath}/static/images/products/default.jpg'">
                            </div>
                            <div class="col-md-6">
                              <h6 class="mb-1">${item.product.name}</h6>
                              <p class="text-muted mb-1">
                                <c:choose>
                                  <c:when test="${fn:length(item.product.description) > 50}">
                                    ${fn:substring(item.product.description, 0, 50)}...
                                  </c:when>
                                  <c:otherwise>
                                    ${item.product.description}
                                  </c:otherwise>
                                </c:choose>
                              </p>
                              <small class="text-muted">数量：${item.quantity}</small>
                            </div>
                            <div class="col-md-2">
                              <strong>
                                <fmt:formatNumber value="${item.price * item.quantity}" pattern="¥#,##0.00"/>
                              </strong>
                            </div>
                            <div class="col-md-2 text-end">
                              <c:if test="${status.index == 0}">
                                <a href="${pageContext.request.contextPath}/order/detail/${order.id}" 
                                   class="btn btn-sm btn-outline-primary mb-1">查看详情</a><br>
                                <c:choose>
                                  <c:when test="${order.status == 0}">
                                    <button class="btn btn-sm btn-primary mb-1" onclick="payOrder(${order.id})">立即支付</button><br>
                                    <button class="btn btn-sm btn-outline-danger" onclick="cancelOrder(${order.id})">取消订单</button>
                                  </c:when>
                                  <c:when test="${order.status == 2}">
                                    <button class="btn btn-sm btn-success" onclick="confirmReceive(${order.id})">确认收货</button>
                                  </c:when>
                                  <c:when test="${order.status == 3}">
                                    <button class="btn btn-sm btn-outline-secondary" onclick="buyAgain(${order.id})">再次购买</button>
                                  </c:when>
                                </c:choose>
                              </c:if>
                            </div>
                          </div>
                        </c:if>
                      </c:forEach>
                      <c:if test="${fn:length(order.orderItems) > 3}">
                        <div class="text-center">
                          <small class="text-muted">还有 ${fn:length(order.orderItems) - 3} 件商品...</small>
                        </div>
                      </c:if>
                    </div>
                  </div>
                </c:forEach>
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
    // 设置应用上下文路径
    window.APP_CONTEXT_PATH = '${pageContext.request.contextPath}';

    document.addEventListener('DOMContentLoaded', function() {
        // 订单状态筛选
        document.querySelectorAll('input[name="orderStatus"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                filterOrders(this.value);
            });
        });
    });

    function filterOrders(status) {
        const orderCards = document.querySelectorAll('.order-card');
        
        if (status === '') {
            // 显示所有订单
            orderCards.forEach(card => card.style.display = 'block');
        } else {
            // 根据状态筛选订单
            let statusValue;
            switch(status) {
                case 'pending': statusValue = 0; break;
                case 'paid': statusValue = 1; break;
                case 'shipped': statusValue = 2; break;
                case 'delivered': statusValue = 3; break;
                default: statusValue = -1;
            }
            
            orderCards.forEach(card => {
                if (card.dataset.status == statusValue) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    }

    async function payOrder(orderId) {
        if (!confirm('确认支付此订单吗？')) {
            return;
        }

        try {
            const formData = new FormData();
            formData.append('orderId', orderId);
            formData.append('status', 1);

            const response = await fetch('${pageContext.request.contextPath}/order/updateStatus', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            
            if (result.success) {
                showMessage('支付成功！', {type: 'success', reload: true, redirectDelay: 1500});
            } else {
                showMessage('支付失败：' + result.message, {type: 'danger'});
            }
        } catch (error) {
            showMessage('网络错误，请重试', {type: 'danger'});
        }
    }

    async function confirmReceive(orderId) {
        if (!confirm('确认已收到商品吗？')) {
            return;
        }

        try {
            const formData = new FormData();
            formData.append('orderId', orderId);
            formData.append('status', 3);

            const response = await fetch('${pageContext.request.contextPath}/order/updateStatus', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            
            if (result.success) {
                showMessage('确认收货成功！', {type: 'success', reload: true, redirectDelay: 1500});
            } else {
                showMessage('操作失败：' + result.message, {type: 'danger'});
            }
        } catch (error) {
            showMessage('网络错误，请重试', {type: 'danger'});
        }
    }

    async function cancelOrder(orderId) {
        if (!confirm('确认取消此订单吗？')) {
            return;
        }

        try {
            const formData = new FormData();
            formData.append('orderId', orderId);
            formData.append('status', -1);

            const response = await fetch('${pageContext.request.contextPath}/order/updateStatus', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            
            if (result.success) {
                showMessage('订单已取消', {type: 'success', reload: true, redirectDelay: 1500});
            } else {
                showMessage('取消失败：' + result.message, {type: 'danger'});
            }
        } catch (error) {
            showMessage('网络错误，请重试', {type: 'danger'});
        }
    }

    async function buyAgain(orderId) {
        try {
            showMessage('正在添加到购物车...', {type: 'primary'});
            
            const response = await fetch('${pageContext.request.contextPath}/order/buyAgain', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({orderId: orderId})
            });

            const result = await response.json();
            
            if (result.success) {
                showMessage('商品已添加到购物车', {type: 'success'});
                // 更新购物车数量显示
                updateCartCount();
            } else {
                showMessage('添加失败：' + result.message, {type: 'danger'});
            }
        } catch (error) {
            showMessage('网络错误，请重试', {type: 'danger'});
        }
    }

    // 更新购物车数量显示
    async function updateCartCount() {
        try {
            const count = await getCartCount();
            const cartCountElement = document.querySelector('.cart-count');
            if (cartCountElement) {
                cartCountElement.textContent = count;
                cartCountElement.style.display = count > 0 ? 'inline' : 'none';
            }
        } catch (error) {
            console.error('更新购物车数量失败:', error);
        }
    }
</script>
</body>
</html>