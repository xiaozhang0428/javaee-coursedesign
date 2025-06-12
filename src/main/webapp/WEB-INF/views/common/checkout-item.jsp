<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<div>
  <div class="row align-items-center">
    <div class="col-auto">
      <img src="${pageContext.request.contextPath}/static/images/products/${param.image}"
           class="img-thumbnail" style="width: 60px; height: 60px; object-fit: cover;">
    </div>
    <div class="col">
      <h6 class="mb-1">${param.name}</h6>
      <p class="text-muted small mb-0">${param.description}</p>
    </div>
    <div class="col-auto">
      <span class="text-muted">×${param.quantity}</span>
    </div>
    <div class="col-auto">
      <span class="fw-bold">¥<fmt:formatNumber value="${param.subtotal}" pattern="#,##0.00"/></span>
    </div>
  </div>
</div>