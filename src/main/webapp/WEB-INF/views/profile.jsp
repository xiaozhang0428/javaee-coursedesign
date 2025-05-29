<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 在线商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #6c757d;
            margin: 0 auto 1rem;
        }
        .profile-card {
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            border-radius: 0.5rem;
        }
        .profile-card .card-header {
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            font-weight: 600;
        }
        .info-item {
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f3f4;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            width: 120px;
            display: inline-block;
        }
        .info-value {
            color: #6c757d;
        }
        .edit-form {
            display: none;
        }
        .btn-edit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-edit:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
    </style>
</head>
<body>
    <!-- 引入头部 -->
    <jsp:include page="common/header.jsp"/>
    
    <!-- 个人中心头部 -->
    <div class="profile-header">
        <div class="container">
            <div class="row">
                <div class="col-md-12 text-center">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h2 class="mb-1">${user.username}</h2>
                    <p class="mb-0">
                        <i class="fas fa-calendar-alt me-2"></i>
                        注册时间：<fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/>
                    </p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 个人信息内容 -->
    <div class="container my-5">
        <div class="row">
            <!-- 左侧导航 -->
            <div class="col-md-3">
                <div class="card profile-card">
                    <div class="card-header">
                        <i class="fas fa-user-cog me-2"></i>个人中心
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="#" class="list-group-item list-group-item-action active">
                            <i class="fas fa-user me-2"></i>基本信息
                        </a>
                        <a href="${pageContext.request.contextPath}/user/orders" class="list-group-item list-group-item-action">
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
                <div class="card profile-card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span><i class="fas fa-user me-2"></i>基本信息</span>
                        <button type="button" class="btn btn-edit btn-sm text-white" onclick="toggleEdit()">
                            <i class="fas fa-edit me-1"></i>编辑
                        </button>
                    </div>
                    <div class="card-body">
                        <!-- 显示模式 -->
                        <div id="info-display">
                            <div class="info-item">
                                <span class="info-label">用户名：</span>
                                <span class="info-value">${user.username}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">邮箱：</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty user.email}">${user.email}</c:when>
                                        <c:otherwise><span class="text-muted">未设置</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">手机号：</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty user.phone}">${user.phone}</c:when>
                                        <c:otherwise><span class="text-muted">未设置</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">地址：</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty user.address}">${user.address}</c:when>
                                        <c:otherwise><span class="text-muted">未设置</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">注册时间：</span>
                                <span class="info-value">
                                    <fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </span>
                            </div>
                        </div>
                        
                        <!-- 编辑模式 -->
                        <div id="info-edit" class="edit-form">
                            <form id="profileForm">
                                <div class="mb-3">
                                    <label for="username" class="form-label">用户名</label>
                                    <input type="text" class="form-control" id="username" value="${user.username}" readonly>
                                    <div class="form-text">用户名不可修改</div>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">邮箱</label>
                                    <input type="email" class="form-control" id="email" value="${user.email}" placeholder="请输入邮箱">
                                </div>
                                <div class="mb-3">
                                    <label for="phone" class="form-label">手机号</label>
                                    <input type="tel" class="form-control" id="phone" value="${user.phone}" placeholder="请输入手机号">
                                </div>
                                <div class="mb-3">
                                    <label for="address" class="form-label">地址</label>
                                    <textarea class="form-control" id="address" rows="3" placeholder="请输入地址">${user.address}</textarea>
                                </div>
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-success" onclick="saveProfile()">
                                        <i class="fas fa-save me-1"></i>保存
                                    </button>
                                    <button type="button" class="btn btn-secondary" onclick="cancelEdit()">
                                        <i class="fas fa-times me-1"></i>取消
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 引入底部 -->
    <jsp:include page="common/footer.jsp"/>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        // 切换编辑模式
        function toggleEdit() {
            $('#info-display').hide();
            $('#info-edit').show();
        }
        
        // 取消编辑
        function cancelEdit() {
            $('#info-edit').hide();
            $('#info-display').show();
            // 重置表单
            $('#profileForm')[0].reset();
            $('#email').val('${user.email}');
            $('#phone').val('${user.phone}');
            $('#address').val('${user.address}');
        }
        
        // 保存个人信息
        function saveProfile() {
            const email = $('#email').val().trim();
            const phone = $('#phone').val().trim();
            const address = $('#address').val().trim();
            
            // 简单的邮箱格式验证
            if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                showMessage('请输入正确的邮箱格式', 'error');
                return;
            }
            
            // 简单的手机号格式验证
            if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
                showMessage('请输入正确的手机号格式', 'error');
                return;
            }
            
            $.post('${pageContext.request.contextPath}/user/updateProfile', {
                email: email,
                phone: phone,
                address: address
            }, function(result) {
                if (result.success) {
                    showMessage('更新成功', 'success');
                    // 刷新页面显示最新信息
                    setTimeout(function() {
                        location.reload();
                    }, 1000);
                } else {
                    showMessage(result.message, 'error');
                }
            }).fail(function() {
                showMessage('更新失败，请稍后重试', 'error');
            });
        }
        
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
        
        // 显示消息
        function showMessage(message, type) {
            const alertClass = type === 'success' ? 'alert-success' : 
                              type === 'error' ? 'alert-danger' : 
                              type === 'warning' ? 'alert-warning' : 'alert-info';
            
            const alertHtml = `
                <div class="alert ${alertClass} alert-dismissible fade show position-fixed" 
                     style="top: 20px; right: 20px; z-index: 9999; min-width: 300px;" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            $('body').append(alertHtml);
            
            // 3秒后自动消失
            setTimeout(function() {
                $('.alert').alert('close');
            }, 3000);
        }
    </script>

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
</body>
</html>