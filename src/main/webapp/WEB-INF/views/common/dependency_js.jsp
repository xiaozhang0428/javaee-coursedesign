<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="${pageContext.request.contextPath}/static/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/all.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/api.js"></script>

<script>
    window.APP_CONTEXT_PATH = '${pageContext.request.contextPath}';

    function showMessage(message, options) {
        if (_showMessage) {
            _showMessage(message, options);
        } else {
            alert(message);
            console.error("找不到 Bootstrap Toast", message, options);
        }
    }

    function showError(error, options = 'danger') {
        showMessage(error.message, options);
        console.error(error);
    }

    function showLoading(element, message = 'loading...') {
        const originalText = element.textContent;
        element.setAttribute('data-original-text', originalText);
        element.innerHTML = `<span class="loading"></span> \${message}`;
        element.disabled = true;
    }

    function hideLoading(element) {
        element.textContent = element.getAttribute('data-original-text');
        element.disabled = false;
        element.removeAttribute('data-original-text');
    }
</script>