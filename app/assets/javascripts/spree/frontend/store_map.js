var styles = [
  {
    "featureType": "administrative",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "landscape",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "simplified"
      },
      {
        "hue": "#0066ff"
      },
      {
        "saturation": 74
      },
      {
        "lightness": 100
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "off"
      },
      {
        "weight": 0.6
      },
      {
        "saturation": -85
      },
      {
        "lightness": 61
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "visibility": "on"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "on"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "simplified"
      },
      {
        "color": "#5f94ff"
      },
      {
        "lightness": 26
      },
      {
        "gamma": 5.86
      }
    ]
  }
];

var center = {lat: 39.7367626, lng: -104.9789276};

var mapOptions = {
  center: center,
  zoom: 15,
  styles: styles,
};

$(document).ready(function() {
  handler = Gmaps.build('Google');
  handler.buildMap({ provider: mapOptions, internal: {id: 'store-map'}}, function(){
    console.log("function goes here");
  });
});
