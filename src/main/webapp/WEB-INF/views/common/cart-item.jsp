<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<div class="cart-item" data-cart-id="${param.productId}">
  <div class="row align-items-center p-3">
    <div class="col-auto">
      <div class="form-check">
        <input class="form-check-input item-checkbox" type="checkbox"
               value="${param.productId}" data-price="${param.price}">
      </div>
    </div>
    <div class="col-auto">
      <img src="${pageContext.request.contextPath}/static/images/products/${param.image}"
           class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;"
           alt="${param.name}">
    </div>
    <div class="col">
      <h6 class="mb-1">${param.name}</h6>
      <p class="text-muted small mb-0">
        <c:choose>
          <c:when test="${fn:length(param.description) > 60}">
            ${fn:substring(param.description, 0, 60)}...
          </c:when>
          <c:otherwise>
            ${param.description}
          </c:otherwise>
        </c:choose>
      </p>
    </div>
    <div class="col-auto">
    <span class="price h6">
      <fmt:formatNumber value="${param.price}" pattern="¥#,##0.00"/>
    </span>
    </div>
    <div class="col-auto">
      <div class="input-group" style="width: 120px;">
        <button class="btn btn-outline-secondary btn-sm quantity-btn"
                type="button" data-delta="-1" data-cart-id="${param.productId}">
          <i class="fas fa-minus"></i>
        </button>
        <input type="number" class="form-control form-control-sm text-center quantity-input"
               value="${param.quantity}" data-original-value="${param.quantity}" data-cart-id="${param.productId}">
        <button class="btn btn-outline-secondary btn-sm quantity-btn"
                type="button" data-delta="1" data-cart-id="${param.productId}">
          <i class="fas fa-plus"></i>
        </button>
      </div>
    </div>
    <div class="col-auto">
    <span class="subtotal h6 text-danger">
      <fmt:formatNumber value="${param.price * param.quantity}" pattern="¥#,##0.00"/>
    </span>
    </div>
    <div class="col-auto">
      <button class="btn btn-outline-danger btn-sm delete-item" data-cart-id="${param.productId}">
        <i class="fas fa-trash"></i>
      </button>
    </div>
  </div>
</div>