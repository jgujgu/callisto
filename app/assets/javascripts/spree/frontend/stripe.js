$(document).ready(function() {
  var windowPath = window.location.pathname;
  if (windowPath === "/checkout/payment" || windowPath === "/checkout/update/payment") {
    var $tripeButton = $('#stripeButton');
    $tripeButton.prop('disabled', false);
    var $paymentSubmit = $("#payment-submit");
    if (paymentSubmitDisabled) {
      $paymentSubmit.prop('disabled', true);
    } else {
      $paymentSubmit.prop('disabled', false);
    }
    var updateStripeButton = $('#updateStripeButton');
    var keepPriorInformation = $('#keepPriorInformation');

    var handler = StripeCheckout.configure({
      key: 'pk_test_fads0ZlNqu7ZE4dh5Ko3U4Mr',
      image: 'https://s3.amazonaws.com/stripe-uploads/acct_16RqArF0tqdkC24nmerchant-icon-1456718573239-Screen%20Shot%202016-02-28%20at%209.03.00%20PM.png',
      locale: 'auto',
      token: function(token) {
        $tripeButton.prop('disabled', true);
        $("#stripe_token").val(token.id);
        $paymentSubmit.prop('disabled', false);
      }
    });

    $tripeButton.on('click', function(e) {
      handler.open({
        name: 'Flea',
        email: email,
        panelLabel: 'Use Card',
      });
      e.preventDefault();
    });

    $('#payment_choice_prior').on('ifChecked', function(){
      $("#stripe_token").val(stripe_customer_id);
      $paymentSubmit.prop('disabled', false);
    });

    $('#payment_choice_update').on('ifChecked', function(){
      handler.open({
        name: 'Flea',
        email: email,
        panelLabel: 'Update Card',
      });
    });

    $(window).on('popstate', function() {
      handler.close();
    });
  }
});
