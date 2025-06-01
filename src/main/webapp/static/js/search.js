/**
 * 搜索功能增强 - 自动补全和关键字高亮
 */
class SearchEnhancer {
    constructor(options = {}) {
        this.searchInput = options.searchInput || document.querySelector('#searchKeyword');
        this.searchButton = options.searchButton || document.querySelector('#searchBtn');
        this.contextPath = options.contextPath || '';
        this.debounceDelay = options.debounceDelay || 300;
        this.maxSuggestions = options.maxSuggestions || 8;
        
        this.suggestionContainer = null;
        this.currentKeyword = '';
        this.debounceTimer = null;
        this.selectedIndex = -1;
        
        this.init();
    }
    
    init() {
        if (!this.searchInput) return;
        
        this.createSuggestionContainer();
        this.bindEvents();
        this.loadHotKeywords();
    }
    
    createSuggestionContainer() {
        // 创建建议列表容器
        this.suggestionContainer = document.createElement('div');
        this.suggestionContainer.className = 'search-suggestions';
        this.suggestionContainer.style.cssText = `
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-top: none;
            border-radius: 0 0 4px 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            max-height: 300px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
        `;
        
        // 将容器插入到搜索框的父元素中
        const inputGroup = this.searchInput.closest('.input-group');
        if (inputGroup) {
            inputGroup.style.position = 'relative';
            inputGroup.appendChild(this.suggestionContainer);
        }
    }
    
    bindEvents() {
        // 输入事件 - 防抖处理
        this.searchInput.addEventListener('input', (e) => {
            clearTimeout(this.debounceTimer);
            this.debounceTimer = setTimeout(() => {
                this.handleInput(e.target.value);
            }, this.debounceDelay);
        });
        
        // 键盘导航
        this.searchInput.addEventListener('keydown', (e) => {
            this.handleKeydown(e);
        });
        
        // 失去焦点时隐藏建议
        this.searchInput.addEventListener('blur', () => {
            setTimeout(() => this.hideSuggestions(), 150);
        });
        
        // 获得焦点时显示建议
        this.searchInput.addEventListener('focus', () => {
            if (this.searchInput.value.trim()) {
                this.handleInput(this.searchInput.value);
            } else {
                this.showHotKeywords();
            }
        });
        
        // 点击外部隐藏建议
        document.addEventListener('click', (e) => {
            if (!this.searchInput.contains(e.target) && !this.suggestionContainer.contains(e.target)) {
                this.hideSuggestions();
            }
        });
    }
    
    handleInput(value) {
        const keyword = value.trim();
        this.currentKeyword = keyword;
        
        if (keyword.length === 0) {
            this.showHotKeywords();
            return;
        }
        
        if (keyword.length < 2) {
            this.hideSuggestions();
            return;
        }
        
        this.fetchSuggestions(keyword);
    }
    
    handleKeydown(e) {
        const suggestions = this.suggestionContainer.querySelectorAll('.suggestion-item');
        
        switch (e.key) {
            case 'ArrowDown':
                e.preventDefault();
                this.selectedIndex = Math.min(this.selectedIndex + 1, suggestions.length - 1);
                this.updateSelection(suggestions);
                break;
                
            case 'ArrowUp':
                e.preventDefault();
                this.selectedIndex = Math.max(this.selectedIndex - 1, -1);
                this.updateSelection(suggestions);
                break;
                
            case 'Enter':
                e.preventDefault();
                if (this.selectedIndex >= 0 && suggestions[this.selectedIndex]) {
                    const selectedText = suggestions[this.selectedIndex].textContent;
                    this.selectSuggestion(selectedText);
                } else {
                    this.performSearch();
                }
                break;
                
            case 'Escape':
                this.hideSuggestions();
                this.searchInput.blur();
                break;
        }
    }
    
    updateSelection(suggestions) {
        suggestions.forEach((item, index) => {
            item.classList.toggle('selected', index === this.selectedIndex);
        });
        
        if (this.selectedIndex >= 0 && suggestions[this.selectedIndex]) {
            suggestions[this.selectedIndex].scrollIntoView({
                block: 'nearest'
            });
        }
    }
    
    async fetchSuggestions(keyword) {
        try {
            const response = await fetch(`${this.contextPath}/api/search/suggestions?keyword=${encodeURIComponent(keyword)}&limit=${this.maxSuggestions}`);
            const data = await response.json();
            
            if (data.success && data.suggestions) {
                this.showSuggestions(data.suggestions, keyword);
            } else {
                this.hideSuggestions();
            }
        } catch (error) {
            console.error('获取搜索建议失败:', error);
            this.hideSuggestions();
        }
    }
    
    async loadHotKeywords() {
        try {
            const response = await fetch(`${this.contextPath}/api/search/hot-keywords?limit=6`);
            const data = await response.json();
            
            if (data.success && data.keywords) {
                this.hotKeywords = data.keywords;
            }
        } catch (error) {
            console.error('获取热门关键词失败:', error);
        }
    }
    
    showSuggestions(suggestions, keyword = '') {
        if (!suggestions || suggestions.length === 0) {
            this.hideSuggestions();
            return;
        }
        
        this.selectedIndex = -1;
        this.suggestionContainer.innerHTML = '';
        
        suggestions.forEach((suggestion, index) => {
            const item = document.createElement('div');
            item.className = 'suggestion-item';
            item.style.cssText = `
                padding: 8px 12px;
                cursor: pointer;
                border-bottom: 1px solid #f0f0f0;
                transition: background-color 0.2s;
            `;
            
            // 高亮关键字
            if (keyword) {
                item.innerHTML = this.highlightKeyword(suggestion, keyword);
            } else {
                item.textContent = suggestion;
            }
            
            // 鼠标事件
            item.addEventListener('mouseenter', () => {
                this.selectedIndex = index;
                this.updateSelection(this.suggestionContainer.querySelectorAll('.suggestion-item'));
            });
            
            item.addEventListener('click', () => {
                this.selectSuggestion(suggestion);
            });
            
            this.suggestionContainer.appendChild(item);
        });
        
        this.suggestionContainer.style.display = 'block';
    }
    
    showHotKeywords() {
        if (!this.hotKeywords || this.hotKeywords.length === 0) {
            this.hideSuggestions();
            return;
        }
        
        this.selectedIndex = -1;
        this.suggestionContainer.innerHTML = '';
        
        // 添加标题
        const title = document.createElement('div');
        title.className = 'suggestion-title';
        title.textContent = '热门搜索';
        title.style.cssText = `
            padding: 8px 12px;
            font-size: 12px;
            color: #666;
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        `;
        this.suggestionContainer.appendChild(title);
        
        this.hotKeywords.forEach((keyword, index) => {
            const item = document.createElement('div');
            item.className = 'suggestion-item hot-keyword';
            item.style.cssText = `
                padding: 8px 12px;
                cursor: pointer;
                border-bottom: 1px solid #f0f0f0;
                transition: background-color 0.2s;
                display: flex;
                align-items: center;
            `;
            
            item.innerHTML = `
                <i class="fas fa-fire" style="color: #ff6b6b; margin-right: 8px; font-size: 12px;"></i>
                <span>${keyword}</span>
            `;
            
            item.addEventListener('mouseenter', () => {
                this.selectedIndex = index;
                this.updateSelection(this.suggestionContainer.querySelectorAll('.suggestion-item'));
            });
            
            item.addEventListener('click', () => {
                this.selectSuggestion(keyword);
            });
            
            this.suggestionContainer.appendChild(item);
        });
        
        this.suggestionContainer.style.display = 'block';
    }
    
    hideSuggestions() {
        this.suggestionContainer.style.display = 'none';
        this.selectedIndex = -1;
    }
    
    selectSuggestion(suggestion) {
        this.searchInput.value = suggestion;
        this.hideSuggestions();
        this.performSearch();
    }
    
    performSearch() {
        const keyword = this.searchInput.value.trim();
        if (keyword) {
            // 触发搜索
            if (this.searchButton) {
                this.searchButton.click();
            }
        }
    }
    
    highlightKeyword(text, keyword) {
        if (!keyword) return text;
        
        const regex = new RegExp(`(${keyword})`, 'gi');
        return text.replace(regex, '<mark style="background-color: #fff3cd; padding: 0 2px;">$1</mark>');
    }
    
    // 在搜索结果中高亮关键字
    static highlightSearchResults(keyword) {
        if (!keyword) return;
        
        const productCards = document.querySelectorAll('.product-card');
        productCards.forEach(card => {
            const nameElement = card.querySelector('.product-name');
            const descElement = card.querySelector('.product-description');
            
            if (nameElement) {
                const originalText = nameElement.getAttribute('data-original-text') || nameElement.textContent;
                nameElement.setAttribute('data-original-text', originalText);
                nameElement.innerHTML = SearchEnhancer.prototype.highlightKeyword(originalText, keyword);
            }
            
            if (descElement) {
                const originalText = descElement.getAttribute('data-original-text') || descElement.textContent;
                descElement.setAttribute('data-original-text', originalText);
                descElement.innerHTML = SearchEnhancer.prototype.highlightKeyword(originalText, keyword);
            }
        });
    }
}

// 添加样式
const style = document.createElement('style');
style.textContent = `
    .suggestion-item:hover,
    .suggestion-item.selected {
        background-color: #f8f9fa !important;
    }
    
    .suggestion-item:last-child {
        border-bottom: none !important;
    }
    
    .search-suggestions {
        font-size: 14px;
    }
    
    .search-suggestions mark {
        background-color: #fff3cd !important;
        padding: 0 2px !important;
        border-radius: 2px;
    }
`;
document.head.appendChild(style);

// 导出类
window.SearchEnhancer = SearchEnhancer;