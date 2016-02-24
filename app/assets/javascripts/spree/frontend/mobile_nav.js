var md = new MobileDetect(window.navigator.userAgent);
var searchPlaceholder;
var searchToggle = true;
var showSeconds = 1000;
var hideSeconds = 8000;


if (md.phone()) {
  $(document).ready(function() {
    var $navSearchForm = $("#nav-search-form");
    var $btnSearch = $("#btn-search");
    var $keywords = $("#keywords");
    var $wrapper = $("#wrapper");
    var $toggleSearch = $("#toggle-search");

    searchPlaceholder = $keywords.attr("placeholder");
    $wrapper.addClass("long-wrapper");
    $toggleSearch.show();
    $toggleSearch.css({display: "block"});
    $toggleSearch.addClass("full");


    var $timeout = setTimeout(function() {
      hideSearch($navSearchForm, $btnSearch, $keywords, $wrapper, $toggleSearch);
    },hideSeconds);

    $keywords.focus(function() {
      clearTimeout($timeout);
    });

    $toggleSearch.click(function(e) {
      e.preventDefault();
      if (searchToggle) {
        searchToggle = false;
        $navSearchForm.removeClass("shrunken-search");
        $toggleSearch.addClass("full");
        setTimeout(function() {
          showSearch($navSearchForm, $btnSearch, $keywords, $wrapper);
        },showSeconds);
      } else {
        searchToggle = true;
        hideSearch($navSearchForm, $btnSearch, $keywords, $wrapper, $toggleSearch);
      }
    });
  });
}

function hideSearch($navSearchForm, $btnSearch, $keywords, $wrapper, $toggle) {
  $wrapper.removeClass("long-wrapper");
  $navSearchForm.addClass("shrunken-search");
  $btnSearch.addClass("transparent");
  $keywords.addClass("transparent");
  $keywords.attr("placeholder", "");
  $toggle.removeClass("full");
  $keywords.blur();
}

function showSearch($navSearchForm, $btnSearch, $keywords, $wrapper) {
  $wrapper.addClass("long-wrapper");
  $btnSearch.removeClass("transparent");
  $keywords.removeClass("transparent");
  $keywords.attr("placeholder", searchPlaceholder);
  $keywords.focus();
}
