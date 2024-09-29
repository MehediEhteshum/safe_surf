class YtSearchJsUtils {
  static String get interceptSearchInput => '''
    (function() {
      const searchInput = document.querySelector('input.YtSearchboxComponentInput');
      const searchForm = document.querySelector('form.YtSearchboxComponentSearchForm');
      const searchButton = document.querySelector('button.YtSearchboxComponentSearchButton');
      
      if (searchInput && searchForm && searchButton) {
        // Input event listener
        searchInput.addEventListener('input', function(e) {
          const lastChar = e.target.value.slice(-1);
          if (lastChar === ' ' || lastChar.match(/[.,!?]/)) {
            console.log('Input event triggered: ' + e.target.value);
            window.flutter_inappwebview.callHandler('checkSearchInput', e.target.value);
          }
        });

        // Enter key press listener
        searchInput.addEventListener('keypress', function(e) {
          if (e.key === 'Enter') {
            e.preventDefault();
            console.log('Enter key pressed: ' + searchInput.value);
            window.flutter_inappwebview.callHandler('checkSearchSubmit', searchInput.value);
          }
        }, { passive: false });

        // Form submit listener
        searchForm.addEventListener('submit', function(e) {
          e.preventDefault();
          console.log('Form submit triggered: ' + searchInput.value);
          window.flutter_inappwebview.callHandler('checkSearchSubmit', searchInput.value);
        }, { passive: false });

        // Search button click listener
        searchButton.addEventListener('click', function(e) {
          e.preventDefault();
          console.log('Search button clicked: ' + searchInput.value);
          window.flutter_inappwebview.callHandler('checkSearchSubmit', searchInput.value);
        }, { passive: false });
      } else {
        console.log('Search input, form, or button not found');
      }
    })();
  ''';

  static String clearSearchInput = '''
    (function() {
      const searchInput = document.querySelector('input.YtSearchboxComponentInput');
      if (searchInput) {
        searchInput.value = '';
        console.log('Search input cleared');
      } else {
        console.log('Search input not found');
      }
    })();
  ''';

  static String submitSearch = '''
    (function() {
      const searchForm = document.querySelector('form.YtSearchboxComponentSearchForm');
      const searchButton = document.querySelector('button.YtSearchboxComponentSearchButton');
      if (searchForm && searchButton) {
        searchButton.click();
        console.log('Search submitted');
      } else {
        console.log('Search form or button not found');
      }
    })();
  ''';
}
