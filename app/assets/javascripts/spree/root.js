$(document).ready(function() {
  console.log("hello");
  tooltipInit();
});
function tooltipInit() {
  $('[data-toggle="tooltip"]').tooltip();
}
