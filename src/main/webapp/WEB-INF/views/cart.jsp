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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- 导航栏 -->
    <jsp:include page="common/header.jsp" />

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-shopping-cart"></i> 我的购物车</h2>
                <hr>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty cartItems}">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="selectAll">
                                            <label class="form-check-label" for="selectAll">
                                                全选
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <button class="btn btn-outline-danger btn-sm" id="deleteSelected">
                                            <i class="fas fa-trash"></i> 删除选中
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="cart-item" data-cart-id="${item.productId}">
                                        <div class="row align-items-center p-3">
                                            <div class="col-auto">
                                                <div class="form-check">
                                                    <input class="form-check-input item-checkbox" type="checkbox" 
                                                           value="${item.productId}" data-price="${item.product.price}">
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <img src="${pageContext.request.contextPath}/static/images/products/${item.product.image}" 
                                                     class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;"
                                                     alt="${item.product.name}"
                                                     onerror="this.src='${pageContext.request.contextPath}/static/images/products/default.jpg'">
                                            </div>
                                            <div class="col">
                                                <h6 class="mb-1">${item.product.name}</h6>
                                                <p class="text-muted small mb-0">
                                                    <c:choose>
                                                        <c:when test="${fn:length(item.product.description) > 60}">
                                                            ${fn:substring(item.product.description, 0, 60)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${item.product.description}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                            <div class="col-auto">
                                                <span class="price h6">
                                                    <fmt:formatNumber value="${item.product.price}" pattern="¥#,##0.00"/>
                                                </span>
                                            </div>
                                            <div class="col-auto">
                                                <div class="input-group" style="width: 120px;">
                                                    <button class="btn btn-outline-secondary btn-sm quantity-btn" 
                                                            type="button" data-action="decrease" data-cart-id="${item.productId}">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <input type="number" class="form-control form-control-sm text-center quantity-input" 
                                                           value="${item.quantity}" min="1" max="99" data-cart-id="${item.productId}">
                                                    <button class="btn btn-outline-secondary btn-sm quantity-btn" 
                                                            type="button" data-action="increase" data-cart-id="${item.productId}">
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <span class="subtotal h6 text-danger">
                                                    <fmt:formatNumber value="${item.product.price * item.quantity}" pattern="¥#,##0.00"/>
                                                </span>
                                            </div>
                                            <div class="col-auto">
                                                <button class="btn btn-outline-danger btn-sm delete-item" 
                                                        data-cart-id="${item.productId}">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-calculator"></i> 结算信息</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>已选商品：</span>
                                    <span id="selectedCount">0</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>商品总价：</span>
                                    <span id="totalPrice">¥0.00</span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between mb-3">
                                    <strong>应付总额：</strong>
                                    <strong class="text-danger h5" id="finalPrice">¥0.00</strong>
                                </div>
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
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-shopping-cart"></i>
                    <h4>购物车是空的</h4>
                    <p>快去挑选喜欢的商品吧！</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                        <i class="fas fa-shopping-bag"></i> 去购物
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 页脚 -->
    <jsp:include page="common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    
    <script>
    $(document).ready(function() {
        // 全选/取消全选
        $('#selectAll').on('change', function() {
            var checked = $(this).is(':checked');
            $('.item-checkbox').prop('checked', checked);
            updateTotal();
        });
        
        // 单个商品选择
        $('.item-checkbox').on('change', function() {
            updateSelectAll();
            updateTotal();
        });
        
        // 更新全选状态
        function updateSelectAll() {
            var totalItems = $('.item-checkbox').length;
            var checkedItems = $('.item-checkbox:checked').length;
            $('#selectAll').prop('checked', totalItems === checkedItems);
        }
        
        // 更新总价
        function updateTotal() {
            var selectedCount = 0;
            var totalPrice = 0;
            
            $('.item-checkbox:checked').each(function() {
                var cartId = $(this).val();
                var quantity = parseInt($('.quantity-input[data-cart-id="' + cartId + '"]').val());
                var price = parseFloat($(this).data('price'));
                
                selectedCount += quantity;
                totalPrice += price * quantity;
            });
            
            $('#selectedCount').text(selectedCount);
            $('#totalPrice').text(formatPrice(totalPrice));
            $('#finalPrice').text(formatPrice(totalPrice));
            
            $('#checkoutBtn').prop('disabled', selectedCount === 0);
        }
        
        // 数量调整
        $('.quantity-btn').on('click', function() {
            var action = $(this).data('action');
            var cartId = $(this).data('cart-id');
            var input = $('.quantity-input[data-cart-id="' + cartId + '"]');
            var currentValue = parseInt(input.val());
            var newValue = currentValue;
            
            if (action === 'increase') {
                newValue = Math.min(currentValue + 1, 99);
            } else if (action === 'decrease') {
                newValue = Math.max(currentValue - 1, 1);
            }
            
            if (newValue !== currentValue) {
                input.val(newValue);
                updateCartQuantity(cartId, newValue);
            }
        });
        
        // 直接输入数量
        $('.quantity-input').on('change', function() {
            var cartId = $(this).data('cart-id');
            var quantity = parseInt($(this).val());
            
            if (isNaN(quantity) || quantity < 1) {
                quantity = 1;
                $(this).val(quantity);
            } else if (quantity > 99) {
                quantity = 99;
                $(this).val(quantity);
            }
            
            updateCartQuantity(cartId, quantity);
        });
        
        // 更新购物车数量
        function updateCartQuantity(cartId, quantity) {
            $.post('${pageContext.request.contextPath}/cart/update', {
                cartId: cartId,
                quantity: quantity
            }, function(result) {
                if (result.success) {
                    // 更新小计显示
                    var price = parseFloat($('.item-checkbox[value="' + cartId + '"]').data('price'));
                    var subtotal = price * quantity;
                    $('.cart-item[data-cart-id="' + cartId + '"] .subtotal').text(formatPrice(subtotal));
                    
                    // 更新总价
                    updateTotal();
                } else {
                    showMessage(result.message, 'error');
                }
            }).fail(function() {
                showMessage('更新失败，请稍后重试', 'error');
            });
        }
        
        // 删除单个商品
        $('.delete-item').on('click', function() {
            var cartId = $(this).data('cart-id');
            confirmAction('确定要删除这个商品吗？', function() {
                deleteCartItem(cartId);
            });
        });
        
        // 删除选中商品
        $('#deleteSelected').on('click', function() {
            var selectedItems = $('.item-checkbox:checked');
            if (selectedItems.length === 0) {
                showMessage('请先选择要删除的商品', 'warning');
                return;
            }
            
            confirmAction('确定要删除选中的商品吗？', function() {
                var cartIds = [];
                selectedItems.each(function() {
                    cartIds.push($(this).val());
                });
                deleteCartItems(cartIds);
            });
        });
        
        // 删除购物车商品
        function deleteCartItem(cartId) {
            $.post('${pageContext.request.contextPath}/cart/remove', {
                cartId: cartId
            }, function(result) {
                if (result.success) {
                    $('.cart-item[data-cart-id="' + cartId + '"]').fadeOut(function() {
                        $(this).remove();
                        updateTotal();
                        updateSelectAll();
                        
                        // 如果购物车为空，刷新页面
                        if ($('.cart-item').length === 0) {
                            location.reload();
                        }
                    });
                    showMessage('商品已删除', 'success');
                } else {
                    showMessage(result.message, 'error');
                }
            }).fail(function() {
                showMessage('删除失败，请稍后重试', 'error');
            });
        }
        
        // 批量删除购物车商品
        function deleteCartItems(cartIds) {
            $.post('${pageContext.request.contextPath}/cart/removeBatch', {
                cartIds: cartIds.join(',')
            }, function(result) {
                if (result.success) {
                    cartIds.forEach(function(cartId) {
                        $('.cart-item[data-cart-id="' + cartId + '"]').fadeOut(function() {
                            $(this).remove();
                        });
                    });
                    
                    setTimeout(function() {
                        updateTotal();
                        updateSelectAll();
                        
                        // 如果购物车为空，刷新页面
                        if ($('.cart-item').length === 0) {
                            location.reload();
                        }
                    }, 500);
                    
                    showMessage('商品已删除', 'success');
                } else {
                    showMessage(result.message, 'error');
                }
            }).fail(function() {
                showMessage('删除失败，请稍后重试', 'error');
            });
        }
        
        // 去结算
        $('#checkoutBtn').on('click', function() {
            var selectedItems = $('.item-checkbox:checked');
            if (selectedItems.length === 0) {
                showMessage('请先选择要结算的商品', 'warning');
                return;
            }
            
            // 这里可以跳转到结算页面
            showMessage('结算功能开发中...', 'info');
        });
        
        // 初始化
        updateTotal();
    });
    </script>
</body>
</html>