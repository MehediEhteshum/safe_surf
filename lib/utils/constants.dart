// route names
const String homeRoute = "/";
const String ytWebRoute = "/yt-web";

// JS injection strings
const String ytShortsBlockedJS = '''
  // Block/remove Shorts page
  function removeShorts() {
    console.log('Checking for Shorts elements');
    var isShortsPage = window.location.href.includes('shorts');
    if (isShortsPage) {
      var shortsPage = document.querySelector("shorts-video");
      if (shortsPage) {
        shortsPage.remove();
        console.log('Shorts page removed');
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
    console.log('Checking for Shorts elements');
    var isShortsPage = window.location.href.includes('shorts');
    if (isShortsPage) {
      var shortsPage = document.querySelector("shorts-video");
      if (shortsPage) {
        shortsPage.remove();
        console.log('Shorts page removed');
      }
    }

    var shortsTab = document.querySelectorAll("ytm-pivot-bar-item-renderer")[1];
    if (shortsTab && shortsTab.innerText === "Shorts") {
      shortsTab.remove();
      console.log('Shorts tab removed');
    }

    var shortsSections = document.querySelectorAll("ytm-reel-shelf-renderer, ytm-rich-section-renderer");
    shortsSections.forEach((shortsSection) => {
      if(shortsSection.innerText.includes("Shorts")){
        shortsSection.remove();
        console.log('Shorts section removed');
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
