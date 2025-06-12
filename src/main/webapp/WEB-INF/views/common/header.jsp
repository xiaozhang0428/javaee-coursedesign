<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">
      <i class="fas fa-shopping-cart"></i> 网上商城
    </a>

    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/">首页</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/products">商品列表</a>
        </li>
      </ul>

      <!-- 搜索框 -->
      <form class="d-flex me-3" action="${pageContext.request.contextPath}/products" method="get">
        <div id="header-search" class="input-group" style="position: relative;">
          <input class="form-control" type="search" name="keyword" placeholder="搜索商品..." value="${param.keyword}" autocomplete="off">
          <button class="btn btn-light" type="submit">
            <i class="fas fa-search"></i>
          </button>
        </div>
      </form>

      <ul class="navbar-nav">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <!-- 已登录 -->
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/cart/">
                <i class="fas fa-shopping-cart"></i> 购物车
                <span class="badge bg-warning text-dark" id="cartCount">0</span>
              </a>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                <i class="fas fa-user"></i> ${sessionScope.user.username}
              </a>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                  <i class="fas fa-user-cog"></i> 个人中心</a></li>
                <li>
                  <hr class="dropdown-divider">
                </li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/logout">
                  <i class="fas fa-sign-out-alt"></i> 退出登录</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/user/login">
                <i class="fas fa-sign-in-alt"></i> 登录
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/user/register">
                <i class="fas fa-user-plus"></i> 注册
              </a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<style>
    .search-suggestions {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: white;
        border: 1px solid #ddd;
        z-index: 1000;
    }

    .suggestion-item {
        padding: 8px 12px;
        cursor: pointer;
        border-bottom: 1px solid #f0f0f0;
    }

    .suggestion-item:last-child {
        border-bottom: none !important;
    }

    .suggestion-item:hover {
        background-color: #f8f9fa !important;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        updateCartCount();
        new SearchSuggestions().bind(document.querySelector('#header-search'));
    });

    function updateCartCount(message = undefined) {
        <c:if test="${not empty sessionScope.user}">
        getCartCount().then(count => document.querySelector('#cartCount').innerHTML = count + '');
        if (message) {
            showMessage(message, 'success')
        }
        </c:if>
    }

    class SearchSuggestions {
        constructor() {
            this.suggestionCount = 6;
            this.timer = null;
            this.suggestionContainer = document.createElement('div');
            this.suggestionContainer.className = 'search-suggestions';
        }

        bind(inputGroup) {
            this.searchButton = inputGroup.querySelector('button');
            this.searchInput = inputGroup.querySelector('input');
            this.searchInput.addEventListener('blur', () => this.hideSuggestions());
            this.searchInput.addEventListener('focus', () => this.handleInput());
            this.searchInput.addEventListener('input', () => this.handleInput());
            inputGroup.appendChild(this.suggestionContainer);
        }

        handleInput() {
            const keyword = (this.searchInput.value || "").trim();
            if (keyword.length === 0) return;

            if (this.timer) window.clearTimeout(this.timer);
            this.timer = setTimeout(() => {
                if (keyword.length >= 1) {
                    getSuggestions(keyword, this.suggestionCount)
                        .then(suggestions => this.showSuggestions(suggestions))
                        .catch(showError);
                } else {
                    this.hideSuggestions();
                }
            }, 300);
        }

        showSuggestions(suggestions) {
            if (!suggestions || suggestions.length === 0) {
                this.hideSuggestions();
            } else {
                this.suggestionContainer.innerHTML = '';
                this.suggestionContainer.style.display = 'block';

                for (let suggestion of suggestions) {
                    const item = document.createElement('div');

                    item.className = 'suggestion-item';
                    item.textContent = suggestion;
                    item.addEventListener('click', () => {
                        this.hideSuggestions();
                        this.searchInput.value = suggestion;
                        this.searchButton.click();
                    });

                    this.suggestionContainer.appendChild(item)
                }
            }
        }

        hideSuggestions() {
            this.suggestionContainer.style.display = 'none';
        }
    }
</script>