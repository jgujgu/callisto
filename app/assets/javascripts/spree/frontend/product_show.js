$(document).ready(function() {
  $(".spinner").spinner({
    icons: { down: "flea-cart-arrow flea-cart-down-arrow", up: "flea-cart-arrow flea-cart-up-arrow" }
  });
  $(".ui-spinner-button").click(function(e) { e.preventDefault(); });
  $(".flea-cart-arrow").removeClass("ui-icon");
  var $up = $(".flea-cart-up-arrow");
  var $down = $(".flea-cart-down-arrow");
  $up.html('<i class="fa fa-arrow-up"></i>');
  $down.html('<i class="fa fa-arrow-down"></i>');
});
