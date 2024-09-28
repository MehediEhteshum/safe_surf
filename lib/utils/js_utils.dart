class JsUtils {
  static String get interceptSearchInput => '''
    (function() {
      const searchInput = document.querySelector('input.YtSearchboxComponentInput');
      const searchForm = document.querySelector('form.YtSearchboxComponentSearchForm');
      
      if (searchInput && searchForm) {
        searchInput.addEventListener('input', function(e) {
          const lastChar = e.target.value.slice(-1);
          if (lastChar === ' ' || lastChar.match(/[.,!?]/)) {
            console.log('Input event triggered: ' + e.target.value);
            window.flutter_inappwebview.callHandler('checkSearchInput', e.target.value);
          }
        });

        searchForm.addEventListener('submit', function(e) {
          e.preventDefault();
          console.log('Submit event triggered: ' + searchInput.value);
          window.flutter_inappwebview.callHandler('checkSearchSubmit', searchInput.value);
        });
      } else {
        console.log('Search input or form not found');
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
      if (searchForm) {
        searchForm.submit();
        console.log('Search submitted');
      } else {
        console.log('Search form not found');
      }
    })();
  ''';
}
