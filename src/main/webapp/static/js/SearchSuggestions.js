class SearchSuggestions {
    constructor() {
        this.maxSuggestions = 6;
        this.currentKeyword = '';
        this.selectedIndex = -1;
        this.timer = null;

        this.suggestionContainer = document.createElement('div');
        this.suggestionContainer.className = 'search-suggestions';
    }

    bind(searchInput, searchButton) {
        this.searchButton = searchButton;
        this.searchInput = searchInput;
        this.searchInput.addEventListener('blur', () => this.hideSuggestions());
        this.searchInput.addEventListener('focus', () => this.handleInput());
        this.searchInput.addEventListener('input', () => this.handleInput());
        this.searchInput.closest('.input-group').appendChild(this.suggestionContainer);
    }

    handleInput() {
        this.currentKeyword = (this.searchInput.value || "").trim();

        if (this.timer) window.clearTimeout(this.timer);
        this.timer = setTimeout(() => {
            if (this.currentKeyword.length >= 1) {
                getSuggestions(this.currentKeyword, this.maxSuggestions)
                    .then(suggestions => this.showSuggestions(suggestions))
                    .catch(err => showMessage(err.message));
            } else {
                this.hideSuggestions();
            }
        }, 300);
    }

    showSuggestions(suggestions) {
        if (!suggestions || suggestions.length === 0) {
            this.hideSuggestions();
            return;
        }

        this.selectedIndex = -1;
        this.suggestionContainer.innerHTML = '';

        suggestions.forEach((suggestion, index) => {
            const item = document.createElement('div');
            item.className = 'suggestion-item';
            item.textContent = suggestion;

            item.addEventListener('mouseenter', () => {
                this.selectedIndex = index;
                this.suggestionContainer.querySelectorAll('.suggestion-item').forEach((item, index) => {
                    item.classList.toggle('selected', index === this.selectedIndex);
                });
            });

            item.addEventListener('click', () => {
                this.hideSuggestions();
                this.searchInput.value = suggestion;
                this.searchButton.click();
            });

            this.suggestionContainer.appendChild(item);
        });

        this.suggestionContainer.style.display = 'block';
    }

    hideSuggestions() {
        this.suggestionContainer.style.display = 'none';
        this.selectedIndex = -1;
    }
}