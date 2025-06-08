<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单结算 - 网上商城</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
    <style>
        .checkout-section {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .section-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            border-radius: 8px 8px 0 0;
        }

        .section-content {
            padding: 20px;
        }

        .address-item {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .address-item:hover {
            border-color: #007bff;
        }

        .address-item.selected {
            border-color: #007bff;
            background-color: #f8f9ff;
        }

        .product-item {
            border-bottom: 1px solid #e9ecef;
            padding: 15px 0;
        }

        .product-item:last-child {
            border-bottom: none;
        }

        .payment-method {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-method:hover {
            border-color: #007bff;
        }

        .payment-method.selected {
            border-color: #007bff;
            background-color: #f8f9ff;
        }

        .order-summary {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            position: sticky;
            top: 20px;
        }

        .summary-item {
            display: flex;
            justify-content: between;
            margin-bottom: 10px;
        }

        .total-amount {
            font-size: 1.2rem;
            font-weight: bold;
            color: #dc3545;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<div class="container mt-4">
    <div class="row">
        <div class="col-lg-8">
            <!-- 收货地址 -->
            <div class="checkout-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>收货地址</h5>
                </div>
                <div class="section-content">
                    <div class="address-item selected" data-address="${user.address}">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${user.username}</h6>
                                <p class="mb-1">${user.phone}</p>
                                <p class="mb-0 text-muted">${user.address}</p>
                            </div>
                            <span class="badge bg-primary">默认</span>
                        </div>
                    </div>
                    
                    <!-- 新增地址 -->
                    <div class="mt-3">
                        <button class="btn btn-outline-primary" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#newAddressForm">
                            <i class="fas fa-plus me-2"></i>使用新地址
                        </button>
                        <div class="collapse mt-3" id="newAddressForm">
                            <div class="card card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="form-label">收货人</label>
                                        <input type="text" class="form-control" id="newReceiverName" 
                                               value="${user.username}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">联系电话</label>
                                        <input type="text" class="form-control" id="newReceiverPhone" 
                                               value="${user.phone}">
                                    </div>
                                </div>
                                <div class="mt-3">
                                    <label class="form-label">详细地址</label>
                                    <textarea class="form-control" id="newAddress" rows="3" 
                                              placeholder="请输入详细的收货地址"></textarea>
                                </div>
                                <div class="mt-3">
                                    <button class="btn btn-primary" onclick="useNewAddress()">使用此地址</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 商品信息 -->
            <div class="checkout-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>商品信息</h5>
                </div>
                <div class="section-content" id="productList">
                    <!-- 商品列表将通过JavaScript动态加载 -->
                    <div class="text-center py-4">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">加载中...</span>
                        </div>
                        <p class="mt-2 text-muted">正在加载商品信息...</p>
                    </div>
                </div>
            </div>

            <!-- 支付方式 -->
            <div class="checkout-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-credit-card me-2"></i>支付方式</h5>
                </div>
                <div class="section-content">
                    <div class="payment-method selected" data-method="alipay">
                        <div class="d-flex align-items-center">
                            <i class="fab fa-alipay fa-2x text-primary me-3"></i>
                            <div>
                                <h6 class="mb-0">支付宝</h6>
                                <small class="text-muted">推荐使用支付宝快捷支付</small>
                            </div>
                        </div>
                    </div>
                    <div class="payment-method" data-method="wechat">
                        <div class="d-flex align-items-center">
                            <i class="fab fa-weixin fa-2x text-success me-3"></i>
                            <div>
                                <h6 class="mb-0">微信支付</h6>
                                <small class="text-muted">微信安全支付</small>
                            </div>
                        </div>
                    </div>
                    <div class="payment-method" data-method="bank">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-university fa-2x text-info me-3"></i>
                            <div>
                                <h6 class="mb-0">银行卡支付</h6>
                                <small class="text-muted">支持各大银行卡</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- 订单摘要 -->
            <div class="order-summary">
                <h5 class="mb-3"><i class="fas fa-file-invoice me-2"></i>订单摘要</h5>
                
                <div class="summary-item">
                    <span>商品总价：</span>
                    <span id="subtotal">¥0.00</span>
                </div>
                <div class="summary-item">
                    <span>运费：</span>
                    <span class="text-success">免运费</span>
                </div>
                <div class="summary-item">
                    <span>优惠：</span>
                    <span class="text-success">-¥0.00</span>
                </div>
                <hr>
                <div class="summary-item">
                    <span class="fw-bold">应付总额：</span>
                    <span class="total-amount" id="totalAmount">¥0.00</span>
                </div>

                <div class="mt-4">
                    <button class="btn btn-danger btn-lg w-100" id="submitOrderBtn" disabled>
                        <i class="fas fa-lock me-2"></i>提交订单
                    </button>
                </div>

                <div class="mt-3 text-center">
                    <small class="text-muted">
                        <i class="fas fa-shield-alt me-1"></i>
                        您的支付信息将被加密保护
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    // 设置应用上下文路径
    window.APP_CONTEXT_PATH = '${pageContext.request.contextPath}';
    
    let selectedProducts = [];
    let selectedAddress = '${user.address}';
    let selectedPaymentMethod = 'alipay';
    let totalAmount = 0;

    document.addEventListener('DOMContentLoaded', function() {
        // 获取商品ID列表
        const urlParams = new URLSearchParams(window.location.search);
        const productIds = urlParams.getAll('productIds').map(id => parseInt(id));
        console.log('Product IDs:', productIds);
        
        if (productIds.length === 0) {
            showMessage('没有选择商品', {type: 'danger'});
            return;
        }
        
        // 加载商品信息
        loadProducts(productIds);
        
        // 地址选择
        document.querySelectorAll('.address-item').forEach(function(item) {
            item.addEventListener('click', function() {
                document.querySelectorAll('.address-item').forEach(el => el.classList.remove('selected'));
                this.classList.add('selected');
                selectedAddress = this.dataset.address;
            });
        });
        
        // 支付方式选择
        document.querySelectorAll('.payment-method').forEach(function(method) {
            method.addEventListener('click', function() {
                document.querySelectorAll('.payment-method').forEach(el => el.classList.remove('selected'));
                this.classList.add('selected');
                selectedPaymentMethod = this.dataset.method;
            });
        });
        
        // 提交订单
        document.getElementById('submitOrderBtn').addEventListener('click', function() {
            submitOrder();
        });
    });

    async function loadProducts(productIds) {
        console.log('Loading products for IDs:', productIds);
        
        try {
            // 构建表单数据
            const formData = new FormData();
            productIds.forEach(function(id) {
                formData.append('productIds', id);
            });
            
            const response = await fetch('${pageContext.request.contextPath}/cart/getSelectedItems', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            console.log('Response:', result);
            
            if (result.success) {
                displayProducts(result.data);
                calculateTotal();
            } else {
                showMessage('加载商品信息失败：' + result.message, {type: 'danger'});
            }
        } catch (error) {
            console.error('Error:', error);
            showMessage('网络错误，请重试', {type: 'danger'});
        }
    }

    function displayProducts(products) {
        selectedProducts = products;
        let html = '';
        
        products.forEach(function(item) {
            const imageSrc = item.product.image || 'default.jpg';
            const subtotal = (item.product.price * item.quantity).toFixed(2);
            
            html += '<div class="product-item">' +
                    '<div class="row align-items-center">' +
                    '<div class="col-auto">' +
                    '<img src="${pageContext.request.contextPath}/static/images/products/' + imageSrc + '" ' +
                    'class="img-thumbnail" style="width: 60px; height: 60px; object-fit: cover;" ' +
                    'onerror="this.src=\'${pageContext.request.contextPath}/static/images/products/default.jpg\'">' +
                    '</div>' +
                    '<div class="col">' +
                    '<h6 class="mb-1">' + item.product.name + '</h6>' +
                    '<p class="text-muted small mb-0">' + item.product.description + '</p>' +
                    '</div>' +
                    '<div class="col-auto">' +
                    '<span class="text-muted">×' + item.quantity + '</span>' +
                    '</div>' +
                    '<div class="col-auto">' +
                    '<span class="fw-bold">¥' + subtotal + '</span>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
        });
        
        document.getElementById('productList').innerHTML = html;
    }

    function calculateTotal() {
        let subtotal = 0;
        selectedProducts.forEach(function(item) {
            subtotal += item.product.price * item.quantity;
        });
        
        totalAmount = subtotal;
        document.getElementById('subtotal').textContent = '¥' + subtotal.toFixed(2);
        document.getElementById('totalAmount').textContent = '¥' + totalAmount.toFixed(2);
        
        // 启用提交按钮
        document.getElementById('submitOrderBtn').disabled = false;
    }

    function useNewAddress() {
        const receiverName = document.getElementById('newReceiverName').value.trim();
        const receiverPhone = document.getElementById('newReceiverPhone').value.trim();
        const newAddress = document.getElementById('newAddress').value.trim();
        
        if (!receiverName || !receiverPhone || !newAddress) {
            showMessage('请填写完整的地址信息', {type: 'danger'});
            return;
        }
        
        selectedAddress = newAddress;
        
        // 更新地址显示
        document.querySelectorAll('.address-item').forEach(el => el.classList.remove('selected'));
        const newAddressHtml = '<div class="address-item selected" data-address="' + newAddress + '">' +
            '<div class="d-flex justify-content-between align-items-start">' +
            '<div>' +
            '<h6 class="mb-1">' + receiverName + '</h6>' +
            '<p class="mb-1">' + receiverPhone + '</p>' +
            '<p class="mb-0 text-muted">' + newAddress + '</p>' +
            '</div>' +
            '<span class="badge bg-success">新地址</span>' +
            '</div>' +
            '</div>';
        
        const sectionContent = document.querySelector('.section-content');
        sectionContent.insertAdjacentHTML('afterbegin', newAddressHtml);
        
        // 隐藏新地址表单
        const newAddressForm = document.getElementById('newAddressForm');
        const collapse = new bootstrap.Collapse(newAddressForm, {toggle: false});
        collapse.hide();
        
        showMessage('地址已更新', {type: 'success'});
    }

    async function submitOrder() {
        if (!selectedAddress) {
            showMessage('请选择收货地址', {type: 'danger'});
            return;
        }
        
        if (selectedProducts.length === 0) {
            showMessage('没有选择商品', {type: 'danger'});
            return;
        }
        
        const submitBtn = document.getElementById('submitOrderBtn');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>提交中...';
        
        try {
            const productIds = selectedProducts.map(item => item.productId);
            
            const formData = new FormData();
            productIds.forEach(id => formData.append('productIds', id));
            formData.append('shippingAddress', selectedAddress);
            
            const response = await fetch('${pageContext.request.contextPath}/order/create', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            
            if (result.success) {
                showMessage('订单创建成功，正在跳转到支付...', {type: 'success'});
                // 进入支付流程
                setTimeout(function() {
                    processPayment(result.data.id);
                }, 1000);
            } else {
                showMessage('订单创建失败：' + result.message, {type: 'danger'});
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fas fa-lock me-2"></i>提交订单';
            }
        } catch (error) {
            showMessage('网络错误，请重试', {type: 'danger'});
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-lock me-2"></i>提交订单';
        }
    }

    async function processPayment(orderId) {
        const submitBtn = document.getElementById('submitOrderBtn');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>支付中...';
        
        console.log('开始支付处理，订单ID:', orderId, '支付方式:', selectedPaymentMethod);
        
        try {
            const formData = new FormData();
            formData.append('orderId', orderId);
            formData.append('paymentMethod', selectedPaymentMethod);
            
            console.log('发送支付请求...');
            const response = await fetch('${pageContext.request.contextPath}/user/payment/status', {
                method: 'POST',
                body: formData
            });

            if (!response.ok) {
                throw new Error('HTTP ' + response.status + ': ' + response.statusText);
            }

            const result = await response.json();
            console.log('支付响应:', result);
            
            if (result.success) {
                const paymentResult = result.data;
                
                if (paymentResult.success) {
                    // 支付成功，更新订单状态
                    console.log('支付成功，更新订单状态...');
                    const updateSuccess = await updateOrderStatus(orderId, 1);
                    
                    if (updateSuccess) {
                        showMessage('支付成功！订单已完成', {type: 'success'});
                        
                        // 跳转到我的订单页面
                        setTimeout(function() {
                            window.location.href = '${pageContext.request.contextPath}/order/orders';
                        }, 2000);
                    } else {
                        showMessage('支付成功，但订单状态更新失败，请联系客服', {type: 'warning'});
                        setTimeout(function() {
                            window.location.href = '${pageContext.request.contextPath}/order/orders';
                        }, 3000);
                    }
                } else {
                    // 支付失败
                    console.log('支付失败:', paymentResult.message);
                    showMessage('支付失败：' + paymentResult.message, {type: 'danger'});
                    submitBtn.innerHTML = '<i class="fas fa-redo me-2"></i>重新支付';
                    submitBtn.disabled = false;
                    
                    // 重新绑定点击事件进行重新支付
                    submitBtn.onclick = function() {
                        processPayment(orderId);
                    };
                }
            } else {
                console.error('支付处理失败:', result.message);
                showMessage('支付处理失败：' + result.message, {type: 'danger'});
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fas fa-redo me-2"></i>重新支付';
            }
        } catch (error) {
            console.error('Payment error:', error);
            showMessage('网络错误，请重试：' + error.message, {type: 'danger'});
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-redo me-2"></i>重新支付';
        }
    }

    async function updateOrderStatus(orderId, status) {
        try {
            console.log('更新订单状态，订单ID:', orderId, '状态:', status);
            
            const formData = new FormData();
            formData.append('orderId', orderId);
            formData.append('status', status);
            
            const response = await fetch('${pageContext.request.contextPath}/order/updateStatus', {
                method: 'POST',
                body: formData
            });

            if (!response.ok) {
                console.error('HTTP错误:', response.status, response.statusText);
                return false;
            }

            const result = await response.json();
            console.log('订单状态更新响应:', result);
            
            if (result.success) {
                console.log('订单状态更新成功');
                return true;
            } else {
                console.error('订单状态更新失败:', result.message);
                return false;
            }
        } catch (error) {
            console.error('Update order status error:', error);
            return false;
        }
    }
</script>
</body>
</html>