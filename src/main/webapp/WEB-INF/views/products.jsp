<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>商品列表 - 网上商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/product-card.css" rel="stylesheet">
</head>
<body>
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<div class="container mt-4">
  <!-- 搜索 -->
  <form class="row mb-4" id="search-form" action="${pageContext.request.contextPath}/products" method="GET">
    <div class="col-md-10">
      <div id="search-group" class="input-group">
        <input type="search" class="form-control" name="keyword" placeholder="搜索商品" value="${param.keyword}"
               autocomplete="off">
        <button class="btn btn-primary" type="submit">
          <i class="fas fa-search"></i> 搜索
        </button>
      </div>
    </div>
    <div class="col-md-2">
      <select class="form-select" id="sortSelect" name="sort">
        <option value="default">默认</option>
        <option value="price_asc">价格升序</option>
        <option value="price_desc">价格降序</option>
        <option value="sales_desc">销量降序</option>
        <option value="create_time_desc">最新</option>
      </select>
    </div>
  </form>

  <!-- 商品列表 -->
  <div class="row" id="productList">
    <c:forEach var="product" items="${products}">
      <jsp:include page="common/product-card.jsp">
        <jsp:param name="id" value="${product.id}"/>
        <jsp:param name="name" value="${product.name}"/>
        <jsp:param name="description" value="${product.description}"/>
        <jsp:param name="price" value="${product.price}"/>
        <jsp:param name="sales" value="${product.sales}"/>
        <jsp:param name="stock" value="${product.stock}"/>
        <jsp:param name="image" value="${product.image}"/>
        <jsp:param name="showSales" value="true"/>
      </jsp:include>
    </c:forEach>
  </div>

  <!-- 无商品 -->
  <c:if test="${empty products}">
    <h4><i class="fas fa-search"></i> 没有找到相关商品</h4>
    <p>请尝试其他关键词或浏览所有商品</p>
    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
      <i class="fas fa-list"></i> 浏览所有商品
    </a>
  </c:if>

  <!-- 分页 -->
  <c:if test="${not empty products}">
    <nav>
      <ul class="pagination justify-content-center">
        <c:if test="${currentPage > 1}">
          <li class="page-item">
            <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&sort=${param.sort}">
              <span aria-hidden="true">&laquo;</span>
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
              <span aria-hidden="true">&raquo;</span>
            </a>
          </li>
        </c:if>
      </ul>
    </nav>
  </c:if>
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    function highlight(reg, element) {
        const text = element.getAttribute('data-original-text') || element.textContent;
        element.setAttribute('data-original-text', text);
        element.innerHTML = text.replaceAll(reg, '<mark style="background-color: #fff3cd; padding: 0 2px;">$1</mark>');
    }

    document.addEventListener('DOMContentLoaded', () => {
        new SearchSuggestions().bind(document.querySelector('#search-group'));

        const sortSelect = document.querySelector('#sortSelect');
        sortSelect.value = '${param.sort}' || 'default';
        sortSelect.addEventListener('change', () => document.querySelector('#search-form').submit());

        // 高亮关键字
        const keyword = '${param.keyword}';
        if (keyword) {
            const reg = new RegExp(`(\${keyword})`, 'ig');
            document.querySelectorAll('.product-card').forEach(card => {
                highlight(reg, card.querySelector('.product-name'));
                highlight(reg, card.querySelector('.product-description'));
            });
        }
    });
</script>
</body>
</html>