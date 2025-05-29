<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 网上商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <!-- 导航栏 -->
    <jsp:include page="common/header.jsp" />

    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow">
                    <div class="card-header bg-success text-white text-center">
                        <h4><i class="fas fa-user-plus"></i> 用户注册</h4>
                    </div>
                    <div class="card-body">
                        <form id="registerForm">
                            <div class="mb-3">
                                <label for="username" class="form-label">用户名 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           placeholder="请输入用户名" required>
                                </div>
                                <div class="form-text">用户名长度为3-20个字符</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">密码 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           placeholder="请输入密码" required>
                                </div>
                                <div class="form-text">密码长度不少于6位</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">确认密码 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                           placeholder="请再次输入密码" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">邮箱</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           placeholder="请输入邮箱地址">
                                </div>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-user-plus"></i> 注册
                                </button>
                            </div>
                        </form>
                        
                        <div class="text-center mt-3">
                            <p class="mb-0">已有账号？ 
                                <a href="${pageContext.request.contextPath}/user/login" class="text-decoration-none">
                                    立即登录
                                </a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 页脚 -->
    <jsp:include page="common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    
    <script>
    $(document).ready(function() {
        $('#registerForm').on('submit', function(e) {
            e.preventDefault();
            
            var username = $('#username').val().trim();
            var password = $('#password').val();
            var confirmPassword = $('#confirmPassword').val();
            var email = $('#email').val().trim();
            
            // 客户端验证
            if (!username) {
                showMessage('请输入用户名', 'warning');
                return;
            }
            
            if (username.length < 3 || username.length > 20) {
                showMessage('用户名长度必须在3-20个字符之间', 'warning');
                return;
            }
            
            if (!password) {
                showMessage('请输入密码', 'warning');
                return;
            }
            
            if (password.length < 6) {
                showMessage('密码长度不能少于6位', 'warning');
                return;
            }
            
            if (password !== confirmPassword) {
                showMessage('两次密码输入不一致', 'warning');
                return;
            }
            
            if (email && !validateEmail(email)) {
                showMessage('邮箱格式不正确', 'warning');
                return;
            }
            
            // 提交注册请求
            var submitBtn = $(this).find('button[type="submit"]');
            showLoading(submitBtn[0]);
            
            $.post('${pageContext.request.contextPath}/user/doRegister', {
                username: username,
                password: password,
                confirmPassword: confirmPassword,
                email: email
            }, function(result) {
                hideLoading(submitBtn[0]);
                if (result.success) {
                    showMessage('注册成功，即将跳转到登录页面', 'success');
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/user/login';
                    }, 2000);
                } else {
                    showMessage(result.message, 'error');
                }
            }).fail(function() {
                hideLoading(submitBtn[0]);
                showMessage('注册失败，请稍后重试', 'error');
            });
        });
        
        // 实时验证用户名
        $('#username').on('blur', function() {
            var username = $(this).val().trim();
            if (username && (username.length < 3 || username.length > 20)) {
                showMessage('用户名长度必须在3-20个字符之间', 'warning');
            }
        });
        
        // 实时验证密码
        $('#password').on('blur', function() {
            var password = $(this).val();
            if (password && password.length < 6) {
                showMessage('密码长度不能少于6位', 'warning');
            }
        });
        
        // 实时验证确认密码
        $('#confirmPassword').on('blur', function() {
            var password = $('#password').val();
            var confirmPassword = $(this).val();
            if (password && confirmPassword && password !== confirmPassword) {
                showMessage('两次密码输入不一致', 'warning');
            }
        });
        
        // 实时验证邮箱
        $('#email').on('blur', function() {
            var email = $(this).val().trim();
            if (email && !validateEmail(email)) {
                showMessage('邮箱格式不正确', 'warning');
            }
        });
    });
    </script>
</body>
</html>