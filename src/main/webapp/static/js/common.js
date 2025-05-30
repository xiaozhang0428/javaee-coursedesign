/**
 * 通用JavaScript函数
 */

/**
 * @param type {'success' | 'info' | 'warning' | 'error' | undefined} default: 'info'
 * @param duration {number | undefined} default: 3000
 * @param redirect {string | undefined} default: undefined
 * @param reload {boolean | undefined} default false
 * @param redirectDelay {number | undefined} default: 1500
 */
class MessageOptions {
}

/**
 * 显示消息
 * @param {string} message 消息内容
 * @param {MessageOptions | string} options 消息选项或消息类型
 */
function showMessage(message, options) {
    if (options instanceof String) options = {type: options};
    if (!options.type) options.type = 'info';
    if (!options.duration) options.duration = 3000;
    if (!options.redirectDelay) options.redirectDelay = 1500;
    const {type, duration, redirect, reload, redirectDelay} = options;

    // 检查消息容器
    let container = document.querySelector('.message-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'message-container';
        document.body.appendChild(container);
    }

    // 创建消息
    const messageEl = document.createElement('div');
    messageEl.className = `message ${type}`;
    messageEl.textContent = message;
    container.appendChild(messageEl);

    // 自动移除
    window.setTimeout(() => {
        if (messageEl.parentNode) {
            messageEl.parentNode.removeChild(messageEl);
        }
    }, duration);

    // 重定向
    if (redirect) {
        window.setTimeout(() => {
            window.location.href = redirect;
        }, redirectDelay);
    } else if (reload) {
        window.setTimeout(() => {
            window.location.reload();
        }, redirectDelay);
    }
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

// 加载状态管理
function showLoading(element) {
    const originalText = element.textContent;
    element.setAttribute('data-original-text', originalText);
    element.innerHTML = '<span class="loading"></span> 处理中...';
    element.disabled = true;
}

function hideLoading(element) {
    element.textContent = element.getAttribute('data-original-text');
    element.disabled = false;
    element.removeAttribute('data-original-text');
}

document.addEventListener('DOMContentLoaded', () => {
    // 初始化工具提示
    if (typeof bootstrap !== 'undefined') {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }
})