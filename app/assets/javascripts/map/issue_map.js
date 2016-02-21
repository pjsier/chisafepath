var map = L.map('map');
var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
var osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
var osm = new L.TileLayer(osmUrl, {minZoom: 10, maxZoom: 18, attribution: osmAttrib});
var center = new L.LatLng(41.8811008, -87.6291208);
map.setView(center, 10);
map.addLayer(osm);

// Set options for geocoder control
var options = {
  latlng: center,
  position: 'topright',
  expanded: true
};

var geocoder = L.control.geocoder("search-F2Xk0nk", options);
geocoder.addTo(map);

// Create container layer group to allow for deleting previously added layers
var all_markers = L.layerGroup().addTo(map);

function handleGeo(geo_resp) {
  var gjLayer = L.geoJson(geo_resp, {
    // add styling
    onEachFeature: function (feature, layer) {
      //maybe add image later
      var popup_content = "<b>Created:</b> " + feature.properties.create_time + "<br>" +
                          "<b>Updated:</b> " + feature.properties.update_time + "<br>" +
                          "<b>Status:</b> " + feature.properties.api_status;
      if (feature.properties.image_url !== null) {
        popup_content += "<br><img src='" + feature.properties.image_url + "'>";
      }
      layer.bindPopup(popup_content);
    }
  });
  all_markers.addLayer(gjLayer);
}

geocoder.on('select', function (e) {
  // clear existing layers from previous searches (if any)
  all_markers.clearLayers();
  var coordinates = e.feature.geometry.coordinates;
  console.log(coordinates);
  var query_obj = {
    coords: coordinates
  };
  $.ajax({
    type: "POST",
    url: '/map_query',
    data: JSON.stringify(query_obj),
    dataType: "json",
    success: function (response) {
      console.log(response);
      map.setView(new L.LatLng(coordinates[1], coordinates[0]), 14);
      handleGeo(response);
    },
    error: function (e) {
      console.log(e);
    },
    contentType: 'application/json'
  });
});
