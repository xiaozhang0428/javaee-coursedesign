function showMessage(message, options) {
    if (_showMessage) {
        _showMessage(message, options);
    } else {
        alert(message);
        console.error("找不到 Bootstrap Toast", message, options);
    }
}

function showLoading(element, message = 'loading...') {
    const originalText = element.textContent;
    element.setAttribute('data-original-text', originalText);
    element.innerHTML = `<span class="loading"></span> ${message}`;
    element.disabled = true;
}

function hideLoading(element) {
    element.textContent = element.getAttribute('data-original-text');
    element.disabled = false;
    element.removeAttribute('data-original-text');
}

// 防抖函数
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// 节流函数
function throttle(func, limit) {
    let inThrottle;
    return function () {
        const args = arguments;
        const context = this;
        if (!inThrottle) {
            func.apply(context, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    }
}
