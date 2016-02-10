var lastScrollTop = 0;
var md = new MobileDetect(window.navigator.userAgent);
var searchPlaceholder;
var hideSeconds = 4500;
var showSeconds = 1000;
var $interval;


if (md.phone()) {
  $(document).ready(function() {
    var $navSearchForm = $("#nav-search-form");
    var $btnSearch = $("#btn-search");
    var $keywords = $("#keywords");
    var $wrapper = $("#wrapper");

    searchPlaceholder = $keywords.attr("placeholder");
    $wrapper.addClass("long-wrapper");
    $keywords.bind('focusin focus', function(e){
      e.preventDefault();
      $navSearchForm.removeClass("shrunken-search");
      showSearch($navSearchForm, $btnSearch, $keywords, $wrapper);
    });

    $interval = setHideInterval($navSearchForm, $btnSearch, $keywords, $wrapper);
  });
  $(window).scroll(function(event){
    var st = $(this).scrollTop();
    var $navSearchForm = $("#nav-search-form");
    var $btnSearch = $("#btn-search");
    var $keywords = $("#keywords");
    var $wrapper = $("#wrapper");

    if (st < lastScrollTop){
      $navSearchForm.removeClass("shrunken-search");
      clearInterval($interval);
      $interval = setHideInterval($navSearchForm, $btnSearch, $keywords, $wrapper);
      setTimeout(function() {
        showSearch($navSearchForm, $btnSearch, $keywords, $wrapper);
      },showSeconds);
    }
    lastScrollTop = st;
  });
}

function setHideInterval($navSearchForm, $btnSearch, $keywords, $wrapper) {
  return setInterval(function() {
    if (!$keywords.is(':focus')) {
      hideSearch($navSearchForm, $btnSearch, $keywords, $wrapper);
    }
  }, hideSeconds);
}

function hideSearch($navSearchForm, $btnSearch, $keywords, $wrapper) {
  $wrapper.removeClass("long-wrapper");
  $navSearchForm.addClass("shrunken-search");
  $btnSearch.addClass("transparent");
  $keywords.addClass("transparent");
  $keywords.attr("placeholder", "");
}

function showSearch($navSearchForm, $btnSearch, $keywords, $wrapper) {
  $wrapper.addClass("long-wrapper");
  $btnSearch.removeClass("transparent");
  $keywords.removeClass("transparent");
  $keywords.attr("placeholder", searchPlaceholder);
}
