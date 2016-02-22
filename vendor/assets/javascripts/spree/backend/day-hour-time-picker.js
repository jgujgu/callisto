$(document).ready(function() {
  $('.time').timepicker({
    step: function(i) {
      return (i%2) ? 15 : 45;
    }
  });
});
