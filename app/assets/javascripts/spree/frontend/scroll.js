var lastScrollTop = 0;
var md = new MobileDetect(window.navigator.userAgent);
var searchPlaceholder;
$(document).ready(function() {
  var $keywords = $("#keywords");
  searchPlaceholder = $keywords.attr("placeholder");
  $keywords.focus(function(e) {
    e.preventDefault();
  })
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
    if (st > lastScrollTop){
      hideSearch($navSearchForm, $btnSearch, $keywords);
    } else {
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
