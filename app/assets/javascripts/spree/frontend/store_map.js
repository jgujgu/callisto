// styles from  https://snazzymaps.com/style/8381/even-lighter
styles = [{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#6195a0"}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2f2f2"}]},{"featureType":"landscape","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#e6f3d6"},{"visibility":"on"}]},{"featureType":"road","elementType":"all","stylers":[{"saturation":-100},{"lightness":45},{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#f4d2c5"},{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"labels.text","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.arterial","elementType":"geometry.fill","stylers":[{"color":"#f4f4f4"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#787878"}]},{"featureType":"road.arterial","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#eaf6f8"},{"visibility":"on"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#eaf6f8"}]}];

var RichMarkerBuilder,
handler,
extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; }, hasProp = {}.hasOwnProperty;

$(document).ready(function() {
  var windowPath = window.location.pathname;
  var subdomain = window.location.host.split('.')[0];
  var mainDomain = subdomain === "www" || subdomain === "flea" || subdomain ==="lvh";
  var rootPath = windowPath === "/";
  if (rootPath && mainDomain) {

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
        var marker = document.createElement("div");
        if (typeof this.args.id === 'number') {
          marker.setAttribute('id', 'marker-store-' + this.args.id.toString());
          if (this.args.id === 0) {
            marker.setAttribute('class', 'marker-container brand-square marker-focused');
          } else {
            marker.setAttribute('class', 'marker-container brand-square');
          }
        } else {
          marker.setAttribute('class', 'marker-user');
          var userIcon = "<i class='fa fa-user fa-3'></i>";
          marker.innerHTML = userIcon;
        }
        return {
          content: marker,
          shadow: "none"
        };
      };

      return RichMarkerBuilder;

    })(Gmaps.Google.Builders.Marker);

    var lastIndex = markers.length - 1;
    var userMarker = markers[lastIndex]; //user is always the last marker
    var defaultZoom = 13;
    var closeupZoom = 15;

    var mapOptions = {
      center: userMarker,
      zoom: defaultZoom,
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
      _.each(markers, function(marker, index) {
        if (index === lastIndex) {
          handler.addMarker(marker);
        } else {
          var googleMarker = handler.addMarker(marker);
          google.maps.event.addListener(googleMarker.serviceObject, 'click', function() {
            handler.getMap().setZoom(closeupZoom);
            handler.getMap().setCenter(googleMarker.serviceObject.getPosition());
            $('#product-hero').slick('slickGoTo', marker.id);
            $indexStoreCarousel.carousel(marker.id);
            updateMarkers(marker.id);
          });
        }
      });
    });

    $('#product-hero').on('afterChange', function(event, slick, currentSlide, nextSlide){
      updateMarkers(currentSlide);
    });
  } else if (rootPath) {
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
        var marker = document.createElement("div");
        marker.setAttribute('id', 'marker-store-' + this.args.id.toString());
        marker.setAttribute('class', 'marker-container brand-square marker-focused');
        return {
          content: marker,
          shadow: "none"
        };
      };

      return RichMarkerBuilder;

    })(Gmaps.Google.Builders.Marker);

    var defaultZoom = 13;

    var mapOptions = {
      center: markers[0],
      zoom: defaultZoom,
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
      _.each(markers, function(marker, index) {
        handler.addMarker(marker);
      });
    });
  }

  function updateMarkers(index) {
    var $marker = $('#marker-store-' + index);
    $('.marker-container').removeClass('marker-focused');
    $marker.addClass('marker-focused');
  }
});
