// styles from  https://snazzymaps.com/style/8381/even-lighter
styles = [{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#6195a0"}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2f2f2"}]},{"featureType":"landscape","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#e6f3d6"},{"visibility":"on"}]},{"featureType":"road","elementType":"all","stylers":[{"saturation":-100},{"lightness":45},{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#f4d2c5"},{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"labels.text","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.arterial","elementType":"geometry.fill","stylers":[{"color":"#f4f4f4"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#787878"}]},{"featureType":"road.arterial","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#eaf6f8"},{"visibility":"on"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#eaf6f8"}]}];

var RichMarkerBuilder,
handler,
extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; }, hasProp = {}.hasOwnProperty;

RichMarkerBuilder = (function(superClass) {
  extend(RichMarkerBuilder, superClass);

  function RichMarkerBuilder() {
    return RichMarkerBuilder.__super__.constructor.apply(this, arguments);
  }

  RichMarkerBuilder.prototype.create_marker = function() {
    var options;
    options = _.extend(this.marker_options(), this.rich_marker_options());
    return this.serviceObject = new RichMarker(options);
  };

  RichMarkerBuilder.prototype.rich_marker_options = function() {
    var marker;
    marker = document.createElement("div");
    marker.setAttribute('class', 'marker_container');
    //marker.innerHTML = this.args.marker;
    marker.innerHTML = "hello";
    return {
      content: marker
    };
  };

  return RichMarkerBuilder;

})(Gmaps.Google.Builders.Marker);

$(document).ready(function() {
  console.log(markers);

  //user always the last marker
  var userMarker = markers[markers.length - 1];

  var mapOptions = {
    center: userMarker,
    zoom: 13,
    styles: styles,
  };

  handler = Gmaps.build('Google', {
    builders: {
      Marker: RichMarkerBuilder
    }
  });

  handler.buildMap({
    provider: mapOptions,
    internal: {id: 'store-map'}
  },

  function(){
    handler.addMarkers(markers);
  });
  $indexStoreCarousel.on('slide.bs.carousel', function (e) {
    var $slideElement = $(e.relatedTarget);
    var index = $slideElement.data('index');
    var result = google.maps.event.trigger(markers[index], 'click');
    console.log(result);
  });
});
