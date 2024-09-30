// route names
const String homeRoute = "/";
const String ytWebRoute = "/yt-web";

// JS injection strings
const String ytShortsBlockedJS = '''
  // Block/remove Shorts page
  function removeShorts() {
    var isShortsPage = window.location.href.includes('shorts');
    if (isShortsPage) {
      var shortsPage = document.querySelector("shorts-carousel");
      if (shortsPage) {
        shortsPage.remove();
      }
    }
  }

  // Initial removal
  removeShorts();

  // Set up a MutationObserver to watch for changes in the DOM
  var observer = new MutationObserver(function(mutations) {
    removeShorts();
  });

  // Start observing the document with the configured parameters
  observer.observe(document.body, { childList: true, subtree: true });
''';
const String ytNoShortsJS = '''
  // Block/remove Shorts related elements
  function removeShorts() {
    var isShortsPage = window.location.href.includes('shorts');
    if (isShortsPage) {
      var shortsPage = document.querySelector("shorts-carousel");
      if (shortsPage) {
        shortsPage.remove();
      }
    }

    var shortsTab = document.querySelectorAll("ytm-pivot-bar-item-renderer")[1];
    if (shortsTab && shortsTab.innerText === "Shorts") {
      shortsTab.remove();
    }

    var shortsSections = document.querySelectorAll("ytm-reel-shelf-renderer, ytm-rich-section-renderer");
    shortsSections.forEach((shortsSection) => {
      if(shortsSection.innerText.includes("Shorts")){
        shortsSection.remove();
      }
    });
  }

  // Initial removal
  removeShorts();

  // Set up a MutationObserver to watch for changes in the DOM
  var observer = new MutationObserver(function(mutations) {
    removeShorts();
  });

  // Start observing the document with the configured parameters
  observer.observe(document.body, { childList: true, subtree: true });
''';
