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

    function showLoading(element, message = 'Loading...') {
        const originalText = element.innerHTML;
        const originalDisabled = element.disabled;
        element.disabled = true;
        element.innerHTML = `<span class="spinner-grow spinner-grow-sm" role="status" aria-hidden="true"></span>
\${message}`
        return () => {
            element.innerHTML = originalText;
            element.disabled = originalDisabled;
        }
    }

    function showLoadings(elements, message = 'Loading...') {
        const resumes = Array.from(elements).map(showLoading(message));
        return () => resumes.forEach(resume => resume())
    }
</script>