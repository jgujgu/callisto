//= require jquery.payment
//= require_self
//= require spree/frontend/checkout/address
//= require spree/frontend/checkout/payment

Spree.disableSaveOnClick = function() {
  return $(".continue.button.primary").click(function(e) {
    $(this).attr('disabled', true).removeClass('primary').addClass('disabled');
  });
};

Spree.ready(function($) {
  return Spree.Checkout = {};
});

$(document).ready(function() {
  $("#order-submit").click(function() {
    $(this).prop('disabled', true);
  });
});

