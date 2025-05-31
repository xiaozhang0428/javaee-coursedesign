<div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1000;">
  <!-- Then put toasts within -->
</div>

<script>

    /**
     * 显示消息
     * @param {string} message 消息内容
     * @param {object | string} options 消息选项或消息类型
     *
     * @param options.type {'primary' | 'success' | 'warning' | 'danger' | undefined} default: 'primary'
     * @param options.duration {number | undefined} default: 5000
     * @param options.redirect {string | undefined} default: undefined
     * @param options.reload {boolean | undefined} default false
     * @param options.redirectDelay {number | undefined} default: 1000
     */
    function _showMessage(message, options) {
        if (typeof(options) === 'string') options = {type: options};
        // 检查无效属性，方便调试
        for (const key in options) {
            if (!['type', 'duration', 'redirect', 'reload', 'redirectDelay'].includes(key)) {
                console.warn(`showMessage: 未知参数 \${key}=\${options[key]}`);
            }
        }

        options.type ||= 'primary';
        options.duration ||= 5000;
        options.redirectDelay ||= 1000;

        const {type, duration, redirect, reload, redirectDelay} = options;
        const container = document.querySelector('.toast-container');
        const messageEl = document.createElement('div');
        messageEl.className = `toast align-items-center border-0 text-bg-\${type}`;
        messageEl.role = 'alert';
        messageEl.textContent = message;
        messageEl.innerHTML = `
<div>
  <div class="toast-body">\${message}</div>
  <button type="button" class="btn-close btn-close-white me-2 float-end" data-bs-dismiss="toast" aria-label="Close"></button>
</div>
`;
        container.appendChild(messageEl);
        console.log(options)
        new bootstrap.Toast(messageEl, {
            delay: duration
        }).show();

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
</script>