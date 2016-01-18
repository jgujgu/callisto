var lastScrollTop = 0;
var md = new MobileDetect(window.navigator.userAgent);

if (md.phone()) {
  $(window).scroll(function(event){
    var st = $(this).scrollTop();
    $navSearchForm = $(".nav-search-form");
    if (st > lastScrollTop){
      $navSearchForm.addClass("shrunken-search");
      console.log("down");
    } else {
      console.log("up");
      $navSearchForm.removeClass("shrunken-search");
    }
    lastScrollTop = st;
  });
}
