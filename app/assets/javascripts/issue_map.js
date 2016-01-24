var map = L.map('map');
var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
var osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
var osm = new L.TileLayer(osmUrl, {minZoom: 10, maxZoom: 18, attribution: osmAttrib});
map.setView(new L.LatLng(41.8811008, -87.6291208),10);
map.addLayer(osm);

var CustomControl = L.Control.extend({
  options: {
    position: 'topright'
    //control position - allowed: 'topleft', 'topright', 'bottomleft', 'bottomright'
  },
  onAdd: function (map) {
    var container = L.DomUtil.create('button', 'leaflet-custom-button');
    container.innerHTML = "Plan Route";
    container.onclick = function(){
      if (container.innerHTML === "Plan Route") {
        map.removeControl(geocoder);
        router.addTo(map);
        container.innerHTML = "Search";
      }
      else {
        map.removeControl(router);
        geocoder.addTo(map);
        container.innerHTML = "Plan Route";
      }
    };
    return container;
  },
});

map.addControl(new CustomControl());

// Set options for Nominatim geocoder
var n_options = {
  geocodingQueryParams: {
    "viewbox": [
      "-88.021160",
      "42.059420",
      "-87.450328",
      "41.561013"
    ],
    "bounded": 1,
  }
};

// Set options for geocoder control
var options = {
  collapsed: false,
  geocoder: new L.Control.Geocoder.Nominatim(n_options)
};

var geocoder = L.Control.geocoder(options).addTo(map);

var router = L.Routing.control({geocoder: L.Control.Geocoder.nominatim()});

// Create container layer group to allow for deleting previously added layers
var all_markers = L.layerGroup().addTo(map);

// Callback for action when geocoder fires
geocoder.markGeocode = function(result) {
  //zoom to map, call mongo/ajax
  // clear existing layers from previous searches (if any)
  all_markers.clearLayers();

  map.setView(result.center, 16);
  var lat = result.center.lat;
  var lon = result.center.lng;

  function handleGeo(geo_resp) {
    var gjLayer = L.geoJson(geo_resp, {
      // add styling
      onEachFeature: function (feature, layer) {
        //maybe add image later
        layer.bindPopup("<b>Status:</b> " + feature.properties.status_311 +
        "<br><b>Status Notes:</b> " + feature.properties.status_notes_311 +
        "<br><b>Issues:</b> " + feature.properties.issues);
      }
    });
    all_markers.addLayer(gjLayer);
  };

  $.ajax({
    type: "POST",
    url: "/mapdata/" + lat + "/" + lon,
    success: function (response) {
      handleGeo(response);
    },
    contentType: 'application/json'
  });
/* Time query test
  $.ajax({
    type: "POST",
    url: "/timetest",
    success: function (response) {
      handleGeo(response);
    },
    contentType: 'application/json'
  }); */
};
