<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
        .status-pending { color: #ffc107; }
        .status-paid { color: #28a745; }
        .status-shipped { color: #17a2b8; }
        .status-delivered { color: #6f42c1; }
        .status-cancelled { color: #dc3545; }
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
    <jsp:include page="common/header.jsp" />

    <div class="container mt-4">
        <div class="row">
            <!-- 左侧导航 -->
            <div class="col-md-3">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-user me-2"></i>个人中心</h5>
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/user/profile" class="list-group-item list-group-item-action">
                            <i class="fas fa-user me-2"></i>基本信息
                        </a>
                        <a href="${pageContext.request.contextPath}/user/orders" class="list-group-item list-group-item-action active">
                            <i class="fas fa-shopping-bag me-2"></i>我的订单
                        </a>
                        <a href="${pageContext.request.contextPath}/cart/" class="list-group-item list-group-item-action">
                            <i class="fas fa-shopping-cart me-2"></i>购物车
                        </a>
                        <a href="#" class="list-group-item list-group-item-action" onclick="changePassword()">
                            <i class="fas fa-key me-2"></i>修改密码
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- 右侧内容 -->
            <div class="col-md-9">
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
                            <!-- 暂无订单 -->
                            <div class="empty-orders">
                                <i class="fas fa-shopping-bag"></i>
                                <h4>暂无订单</h4>
                                <p class="mb-3">您还没有任何订单，快去购买商品吧！</p>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                                    <i class="fas fa-shopping-cart me-2"></i>去购物
                                </a>
                            </div>
                            
                            <!-- 示例订单（实际应该从后端获取） -->
                            <!--
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <strong>订单号：</strong>202312010001
                                        </div>
                                        <div class="col-md-3">
                                            <strong>下单时间：</strong>2023-12-01 10:30
                                        </div>
                                        <div class="col-md-3">
                                            <strong>订单金额：</strong>￥299.00
                                        </div>
                                        <div class="col-md-3 text-end">
                                            <span class="order-status status-paid">已付款</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-2">
                                            <img src="${pageContext.request.contextPath}/static/images/products/default.jpg" 
                                                 class="img-fluid rounded" alt="商品图片">
                                        </div>
                                        <div class="col-md-6">
                                            <h6>商品名称</h6>
                                            <p class="text-muted mb-1">商品描述信息</p>
                                            <small class="text-muted">数量：1</small>
                                        </div>
                                        <div class="col-md-2">
                                            <strong>￥299.00</strong>
                                        </div>
                                        <div class="col-md-2 text-end">
                                            <button class="btn btn-sm btn-outline-primary mb-1">查看详情</button><br>
                                            <button class="btn btn-sm btn-outline-secondary">申请退款</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改密码模态框 -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-key me-2"></i>修改密码</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="changePasswordForm">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="oldPassword" class="form-label">原密码</label>
                            <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">新密码</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            <div class="form-text">密码长度不能少于6位</div>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">确认新密码</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">确认修改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        // 修改密码
        function changePassword() {
            $('#changePasswordModal').modal('show');
        }

        // 修改密码表单提交
        $('#changePasswordForm').on('submit', function(e) {
            e.preventDefault();
            
            var oldPassword = $('#oldPassword').val();
            var newPassword = $('#newPassword').val();
            var confirmPassword = $('#confirmPassword').val();
            
            if (!oldPassword || !newPassword || !confirmPassword) {
                showMessage('请填写完整信息', 'warning');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showMessage('两次密码输入不一致', 'warning');
                return;
            }
            
            if (newPassword.length < 6) {
                showMessage('新密码长度不能少于6位', 'warning');
                return;
            }
            
            $.post('${pageContext.request.contextPath}/user/changePassword', {
                oldPassword: oldPassword,
                newPassword: newPassword,
                confirmPassword: confirmPassword
            }, function(result) {
                if (result.success) {
                    showMessage(result.message, 'success');
                    $('#changePasswordModal').modal('hide');
                    $('#changePasswordForm')[0].reset();
                } else {
                    showMessage(result.message, 'error');
                }
            });
        });

        // 订单状态筛选
        $('input[name="orderStatus"]').on('change', function() {
            var status = $(this).val();
            filterOrders(status);
        });

        function filterOrders(status) {
            // 这里应该发送AJAX请求获取对应状态的订单
            console.log('筛选订单状态：', status);
        }

        // 显示消息
        function showMessage(message, type) {
            var alertClass = 'alert-info';
            switch(type) {
                case 'success': alertClass = 'alert-success'; break;
                case 'error': alertClass = 'alert-danger'; break;
                case 'warning': alertClass = 'alert-warning'; break;
            }
            
            var alertHtml = '<div class="alert ' + alertClass + ' alert-dismissible fade show" role="alert">' +
                           message +
                           '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                           '</div>';
            
            $('.container').prepend(alertHtml);
            
            setTimeout(function() {
                $('.alert').fadeOut();
            }, 3000);
        }
    </script>
</body>
</html>