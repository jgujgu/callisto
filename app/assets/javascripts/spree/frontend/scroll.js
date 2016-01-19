var lastScrollTop = 0;
var md = new MobileDetect(window.navigator.userAgent);
var searchPlaceholder;
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
  setInterval(function() {
    if (!$keywords.is(':focus')) {
      hideSearch($navSearchForm, $btnSearch, $keywords);
    }
  }, 5000);
});


if (md.phone()) {
  $(window).scroll(function(event){
    var st = $(this).scrollTop();
    var $navSearchForm = $("#nav-search-form");
    var $btnSearch = $("#btn-search");
    var $keywords = $("#keywords");
    if (st === 0) {
      $navSearchForm.removeClass("shrunken-search");
      setTimeout(function() {
        showSearch($navSearchForm, $btnSearch, $keywords);
      },1000);
    }
    if (st < lastScrollTop){
      $navSearchForm.removeClass("shrunken-search");
      setTimeout(function() {
        showSearch($navSearchForm, $btnSearch, $keywords);
      },1000);
    }
    lastScrollTop = st;
  });
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
