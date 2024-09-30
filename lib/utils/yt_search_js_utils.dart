class YtSearchJsUtils {
  static String get interceptSearchInput => '''
    (function() {
      const searchInput = document.querySelector('input.YtSearchboxComponentInput');
      const searchForm = document.querySelector('form.YtSearchboxComponentSearchForm');
      const searchButton = document.querySelector('button.YtSearchboxComponentSearchButton');
      
      if (searchInput) {
        let previousValue = '';
        
        // Input event listener
        searchInput.addEventListener('input', function(e) {
          const currentValue = e.target.value;
          const newContent = currentValue.slice(previousValue.length);
          
          if (newContent.includes(' ') || newContent.match(/[.,!?]/)) {
            window.flutter_inappwebview.callHandler('checkSearchInput', currentValue);
          }
          
          previousValue = currentValue;
        });

        // Enter key press listener
        searchInput.addEventListener('keydown', function(e) {
          if (e.key === 'Enter') {
            e.preventDefault();
            window.flutter_inappwebview.callHandler('checkSearchSubmit', searchInput.value);
          }
        });
      }

      if (searchForm) {
        // Form submit listener
        searchForm.addEventListener('submit', function(e) {
          e.preventDefault();
          window.flutter_inappwebview.callHandler('checkSearchSubmit', searchInput.value);
        });
      }

      if (searchButton) {
        // Search button click listener
        searchButton.addEventListener('click', function(e) {
          e.preventDefault();
          window.flutter_inappwebview.callHandler('checkSearchSubmit', searchInput.value);
        });
      }
    })();
  ''';

  static String clearSearchInput = '''
    (function() {
      const searchInput = document.querySelector('input.YtSearchboxComponentInput');
      if (searchInput) {
        searchInput.value = '';
      }
      
      const afterSearchInput = document.querySelector('button.search-bar-text');
      if (afterSearchInput) {
        afterSearchInput.innerText  = '';
      }
    })();
  ''';

  static String submitSearch = '''
    (function() {
      const searchForm = document.querySelector('form.YtSearchboxComponentSearchForm');
      if (searchForm) {
        searchForm.submit();
      }
    })();
  ''';
}
