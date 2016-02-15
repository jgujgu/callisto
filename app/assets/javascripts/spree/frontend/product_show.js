$(document).ready(function() {
  var $plus = $("#qty-plus");
  var $minus = $("#qty-minus");

  $plus.click(function(e) {
    increment();
  });
  $minus.click(function(e) {
    decrement();
  });
});

function increment() {
  $("#quantity").val(function(i, oldval) {
    var oldval = parseInt(oldval);
    if (oldval === 99) {
      return 99;
    } else {
      return ++oldval;
    }
  });
}

function decrement() {
  $("#quantity").val(function(i, oldval) {
    var oldval = parseInt(oldval);
    if (oldval === 1) {
      return 1;
    } else {
      return --oldval;
    }
  });
}
