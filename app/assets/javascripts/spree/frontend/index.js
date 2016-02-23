$(document).ready(function() {
  $('#product-hero').slick({
    dots: true,
    arrows: false,
    infinite: true,
    speed: 500,
    fade: true,
    autoplay: true,
    autoplaySpeed: 4000,
    asNavFor: '#store-hero',
    cssEase: 'linear'
  });

  $('#store-hero').slick({
    infinite: true,
    arrows: false,
    speed: 500,
    fade: true,
    asNavFor: '#product-hero',
    cssEase: 'linear'
  });
});
