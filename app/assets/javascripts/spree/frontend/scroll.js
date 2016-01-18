var lastScrollTop = 0;
$(window).scroll(function(event){
  var md = new MobileDetect(window.navigator.userAgent);

  if (!md.phone()) {
    console.log("this is a phone");
  }

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
