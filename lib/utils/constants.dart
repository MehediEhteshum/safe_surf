// route names
const String homeRoute = "/";
const String ytWebRoute = "/yt-web";

// JS injection strings
const String ytShortsBlockedJS = '''
              // Block/remove Shorts related elements

              setInterval(function() {
                var isShortsPage = window.location.href.includes('shorts');
                if (isShortsPage) {
                  document.querySelector("shorts-page").remove();
                }
              }, 5000);
            ''';
const String ytNoShortsJS = '''
              // Block or hide all Shorts elements

              var shortsTab = document.querySelectorAll("ytm-pivot-bar-item-renderer")[1];
              if (shortsTab.innerText === "Shorts") {
                shortsTab.remove();
              }
                
              setInterval(function() {
                var isShortsPage = window.location.href.includes('shorts');
                if (isShortsPage) {
                  document.querySelector("shorts-page").remove();
                }
              }, 10000);

              setInterval(function() {
                var shortsSections = document.querySelectorAll("ytm-reel-shelf-renderer");
                if (shortsSections) {
                  shortsSections.forEach((shortsSection) => {
                    if(shortsSection.innerText.includes("Shorts")){
                      shortsSection.remove();
                    }
                  });
                }
              }, 5000);

              setInterval(function() {
                var shortsSections = document.querySelectorAll("ytm-rich-section-renderer");
                if (shortsSections) {
                  shortsSections.forEach((shortsSection) => {
                    if(shortsSection.innerText.includes("Shorts")){
                      shortsSection.remove();
                    }
                  });
                }
              }, 5000);
            ''';
