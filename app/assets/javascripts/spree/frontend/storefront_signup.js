$(document).ready(function() {
  var windowPath = window.location.pathname;
  if (windowPath === "/signup") {
    var storefront = $.urlParam('storefront');
    if (storefront) {
      var newStorefrontHeader = "<h6>New Shop</h6>";
      $("#create-new-account").html(newStorefrontHeader);
      $("#spree_user_storefront").val("true");
      $("#login-as-existing").attr("href", "http://www.flea.boutique/admin/login")
      $("#login-as-existing").html("Login as Existing Shop")
    }
  }
});

$.urlParam = function(name){
  var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
  if (results === null){
    return null;
  } else{
    return results[1] || 0;
  }
};
