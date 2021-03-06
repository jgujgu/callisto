// styles from  https://snazzymaps.com/style/8381/even-lighter
styles = [{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#6195a0"}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2f2f2"}]},{"featureType":"landscape","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#e6f3d6"},{"visibility":"on"}]},{"featureType":"road","elementType":"all","stylers":[{"saturation":-100},{"lightness":45},{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#f4d2c5"},{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"labels.text","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.arterial","elementType":"geometry.fill","stylers":[{"color":"#f4f4f4"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#787878"}]},{"featureType":"road.arterial","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#eaf6f8"},{"visibility":"on"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#eaf6f8"}]}];

$(document).ready(function() {
  var adminEditReg = /^\/admin\/stores\/\d+\/edit$/;
  var windowPath = window.location.pathname;
  if (adminEditReg.test(windowPath)) {
    var storeLatLng = new google.maps.LatLng(parseFloat(storeLat),parseFloat(storeLon));

    var mapOptions = {
      center: storeLatLng,
      zoom: 15,
      styles: styles,
    };

    handler = Gmaps.build('Google');

    handler.buildMap({ provider: mapOptions, internal: {id: 'admin-store-map'}}, function(){
      markers = handler.addMarkers([
        {
          "lat": parseFloat(storeLat),
          "lng": parseFloat(storeLon),
        }
      ]);
      handler.bounds.extendWith(markers);
    });
  }
});
