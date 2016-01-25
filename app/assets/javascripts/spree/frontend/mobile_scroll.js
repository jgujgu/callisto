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
    searchPlaceholder = $keywords.attr("placeholder");
    $keywords.bind('focusin focus', function(e){
      e.preventDefault();
      $navSearchForm.removeClass("shrunken-search");
      showSearch($navSearchForm, $btnSearch, $keywords);
    });

    $interval = setHideInterval($navSearchForm, $btnSearch, $keywords);
  });
  $(window).scroll(function(event){
    var st = $(this).scrollTop();
    var $navSearchForm = $("#nav-search-form");
    var $btnSearch = $("#btn-search");
    var $keywords = $("#keywords");
    if (st < lastScrollTop){
      $navSearchForm.removeClass("shrunken-search");
      clearInterval($interval);
      $interval = setHideInterval($navSearchForm, $btnSearch, $keywords);
      setTimeout(function() {
        showSearch($navSearchForm, $btnSearch, $keywords);
      },showSeconds);
    }
    lastScrollTop = st;
  });
}

function setHideInterval($navSearchForm, $btnSearch, $keywords) {
  return setInterval(function() {
    if (!$keywords.is(':focus')) {
      hideSearch($navSearchForm, $btnSearch, $keywords);
    }
  }, hideSeconds);
}

function hideSearch($navSearchForm, $btnSearch, $keywords) {
  $navSearchForm.addClass("shrunken-search");
  $btnSearch.addClass("transparent");
  $keywords.addClass("transparent");
  $keywords.attr("placeholder", "");
}

function showSearch($navSearchForm, $btnSearch, $keywords) {
  $btnSearch.removeClass("transparent");
  $keywords.removeClass("transparent");
  $keywords.attr("placeholder", searchPlaceholder);
}
