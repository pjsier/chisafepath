var map = L.map('map');
var osmUrl='http://{s}.tile.thunderforest.com/transport/{z}/{x}/{y}.png';
var osmAttrib='Data from <a href="http://www.openstreetmap.org/" target="_blank">OpenStreetMap</a> and contributors. Tiles from <a href="http://www.thunderforest.com/transport/">Andy Allan</a>';
var osm = new L.TileLayer(osmUrl, {minZoom: 10, maxZoom: 18, attribution: osmAttrib});
var center = new L.LatLng(41.878114, -87.629798);
map.setView(center, 12);
map.addLayer(osm);

var AltIcon = L.Icon.Default.extend({
    options: {
        iconUrl: altIconUrl
    }
});

var altIcon = new AltIcon();

// Set options for geocoder control
var options = {
  latlng: center,
  position: 'topright',
  expanded: true,
  pointIcon: false,
  polygonIcon: false,
  markers: false
};


var geocoder = L.control.geocoder("search-F2Xk0nk", options);
geocoder.addTo(map);

// Move zoom control to top right so doesn't overlap with geocoder
map.zoomControl.setPosition('topright');

// Create container layer group to allow for deleting previously added layers
var all_markers = L.layerGroup().addTo(map);

var group_markers = L.markerClusterGroup();

function handleGeo(geo_resp) {
  var gjLayer = L.geoJson(geo_resp, {
    pointToLayer: function(feature, latlng) {
      return L.marker(latlng, {icon: altIcon});
    },
    // add styling
    onEachFeature: function (feature, layer) {
      var popup_content = "<b>Created:</b> " + feature.properties.create_time + "<br>" +
                          "<b>Updated:</b> " + feature.properties.update_time + "<br>" +
                          "<b>Status:</b> " + feature.properties.status;
      if (feature.properties.status_notes !== undefined) {
        popup_content += "<br><b>Status Notes:</b> " + feature.properties.status_notes;
      }
      if (feature.properties.description !== undefined) {
        popup_content += "<br><b>Description:</b> " + feature.properties.description;
      }
      if (feature.properties.image_url !== undefined) {
        popup_content += "<br><img class='tooltip-img' src='" + feature.properties.image_url + "'>";
      }

      layer.bindPopup(popup_content);
    }
  });
  return gjLayer;
}

function loadMarkerCluster() {
  $.ajax({
    type: "GET",
    url: '/all_issues',
    dataType: "json",
    success: function (response) {
      map.setView(center, 12);
      group_markers.addLayer(handleGeo(response));
      map.addLayer(group_markers);
    },
    error: function (e) {
      console.log(e);
    },
    contentType: 'application/json'
  });
}

loadMarkerCluster();

geocoder.on('select', function (e) {
  var coordinates = e.feature.geometry.coordinates;
  map.setView(new L.LatLng(coordinates[1], coordinates[0]), 17);
});
