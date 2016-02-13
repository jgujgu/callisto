$(document).ready(function() {
  var $indexStoreCarousel = $('#index-store-carousel');
  var $indexProductCarousel = $('.index-product-carousel');
  $indexStoreCarousel.carousel({
    interval: 5000
  });
  $indexStoreCarousel.on('slide.bs.carousel', function (e) {
    var $slideElement = $(e.relatedTarget);
    var index = $slideElement.data('index');
    $indexProductCarousel.carousel(parseInt(index));
  });
});
