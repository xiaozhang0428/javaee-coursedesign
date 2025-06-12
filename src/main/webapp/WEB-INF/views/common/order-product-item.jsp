<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<div class="row align-items-center mb-3">
  <div class="col-md-2">
    <img
        src="${pageContext.request.contextPath}/static/images/products/${param.image}"
        class="img-fluid rounded" style="width: 80px; height: 80px; object-fit: cover;"
        alt="${param.name}"
        onerror="this.src='${pageContext.request.contextPath}/static/images/products/default.jpg'">
  </div>
  <div class="col-md-6">
    <h6 class="mb-1">${param.name}</h6>
    <p class="text-muted mb-1">
      <c:choose>
        <c:when test="${fn:length(param.description) > 50}">
          ${fn:substring(param.description, 0, 50)}...
        </c:when>
        <c:otherwise>
          ${param.description}
        </c:otherwise>
      </c:choose>
    </p>
    <small class="text-muted">数量：${param.quantity}</small>
  </div>
  <div class="col-md-2">
    <strong>
      <fmt:formatNumber value="${param.price * param.quantity}" pattern="¥#,##0.00"/>
    </strong>
  </div>
  <div class="col-md-2 text-end">
    <c:if test="${param.index == 0}">
      <a href="${pageContext.request.contextPath}/order/detail/${param.order_id}"
         class="btn btn-sm btn-outline-primary mb-1">查看详情</a><br>
    </c:if>
  </div>
</div>