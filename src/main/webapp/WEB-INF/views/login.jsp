<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 网上商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <!-- 导航栏 -->
    <jsp:include page="common/header.jsp" />

    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-6 col-lg-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white text-center">
                        <h4><i class="fas fa-sign-in-alt"></i> 用户登录</h4>
                    </div>
                    <div class="card-body">
                        <form id="loginForm">
                            <div class="mb-3">
                                <label for="username" class="form-label">用户名</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           placeholder="请输入用户名" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">密码</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           placeholder="请输入密码" required>
                                </div>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-sign-in-alt"></i> 登录
                                </button>
                            </div>
                        </form>
                        
                        <div class="text-center mt-3">
                            <p class="mb-0">还没有账号？ 
                                <a href="${pageContext.request.contextPath}/user/register" class="text-decoration-none">
                                    立即注册
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
        $('#loginForm').on('submit', function(e) {
            e.preventDefault();
            
            var username = $('#username').val().trim();
            var password = $('#password').val();
            
            if (!username) {
                showMessage('请输入用户名', 'warning');
                return;
            }
            
            if (!password) {
                showMessage('请输入密码', 'warning');
                return;
            }
            
            // 提交登录请求
            $.post('${pageContext.request.contextPath}/user/doLogin', {
                username: username,
                password: password
            }, function(result) {
                if (result.success) {
                    showMessage('登录成功', 'success');
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/';
                    }, 1500);
                } else {
                    showMessage(result.message, 'error');
                }
            }).fail(function() {
                showMessage('登录失败，请稍后重试', 'error');
            });
        });
        
        // 回车键登录
        $('#username, #password').on('keypress', function(e) {
            if (e.which === 13) {
                $('#loginForm').submit();
            }
        });
    });
    </script>
</body>
</html>