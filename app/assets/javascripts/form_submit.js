$(':file').change(function(){
  var file = this.files[0];

  EXIF.getData(file, function() {
    if (EXIF.getTag(file, "GPSLatitude") === undefined) {
      $('#geo_warn').text("Image is not geo-tagged, please enter the location through one of the following fields");
    }
    else {
      console.log("geotags");
    }
  });
});

//var ospry = new Ospry('pk-test-fd9aw1cgfeei0u7rivobfggf');

$('#uploadForm').submit(function(e) {
  e.preventDefault();
  document.getElementById('geo-submit').innerHTML = "<img src='/stylesheets/images/throbber.gif' />";
  var checkArr = ['broke_box', 'curb_box', 'construction_box'];
  var issueArr = [];
  checkArr.forEach(function(box) {
    box_el = document.getElementById(box);
    if (box_el.checked === true) {
      issueArr.push(box_el.value);
    }
  });

  if (document.getElementById('other_issue').value.length != 0) {
    issueArr.push(document.getElementById('other_issue').value);
  }

  if (issueArr.length === 0) {
    issueArr.push("Sidewalk hazard");
  }

  if (document.getElementById("userPhoto").value != "") {
    var file = $(':file').prop('files')[0];
    var lat = EXIF.getTag(file, "GPSLatitude"),
      latref = EXIF.getTag(file, "GPSLatitudeRef"),
      lon = EXIF.getTag(file, "GPSLongitude"),
      lonref = EXIF.getTag(file, "GPSLongitudeRef");

    /* Add description information and other fields as well to post when added
    ospry.up({
      form: this,
      imageReady: function(err, metadata, i) {
        if (err === null) {
          var geotag_data = JSON.stringify({
              "img_id": metadata.id,
              "img_url": metadata.url,
              "latitude": lat,
              "longitude": lon,
              "latitude_ref": latref,
              "longitude_ref": lonref,
              "issues": issueArr
          });
          $.ajax({
            type: "POST",
            url: '/photo',
            data: geotag_data,
            success: function (response) {
              console.log(response);
              window.location.href = '/submitted';
            },
            contentType: 'application/json'
          });
        }
      },
    });*/
  }
  else if (document.getElementById('lat_hide').value != "") {
    var lat_val = document.getElementById('lat_hide').value;
    var lon_val = document.getElementById('lon_hide').value;
    var geo_data = JSON.stringify({
        "img_id": "n/a",
        "img_url": "n/a",
        "latitude": lat_val,
        "longitude": lon_val,
        "issues": issueArr
    });
    $.ajax({
      type: "POST",
      url: '/geopost',
      data: geo_data,
      success: function (response) {
        console.log(response);
        window.location.href = '/submitted';
      },
      error: function (e) {
        document.getElementById('geo-submit').innerHTML = "Submit";
        document.getElementById("submit_warn").innerHTML = "<b style='color:red'>Error occurred, please check your connection and try again</b><br><br>";
      },
      contentType: 'application/json'
    });
  }
  else {
    document.getElementById("submit_warn").innerHTML = "<b style='color:red'>Please enter one form of location information</b><br><br>";
    document.getElementById('geo-submit').innerHTML = "Submit";
  }
});

//add button that calls this.
function getLocation() {
  if (navigator.geolocation)
  {
    document.getElementById('loc-button').innerHTML = "<img src='/stylesheets/images/throbber.gif' />";
    navigator.geolocation.getCurrentPosition(bindPosition);
  }
  else {
    document.getElementById('geo_button_res').innerHTML = "Geolocation is not supported by this browser";
  }
};

function bindPosition(position) {
  lat = position.coords.latitude;
  lon = position.coords.longitude;
  document.getElementById('lat_hide').value = lat;
  document.getElementById('lon_hide').value = lon;
  document.getElementById('loc-button').innerHTML = "Get Location";
  document.getElementById('geo_button_res').innerHTML = "Success!";
};

var mapDiv = document.getElementById("geocode");
if (mapDiv !== null) {
  $(document).ready(function() {
    var map = L.map('geocode', {zoomControl: false});
    var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    var osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
    var osm = new L.TileLayer(osmUrl, {minZoom: 9, maxZoom: 16, attribution: osmAttrib});
    map.setView(new L.LatLng(41.8811008, -87.6291208),9);
    map.addLayer(osm);
    map.dragging.disable();
    map.touchZoom.disable();
    map.doubleClickZoom.disable();
    map.scrollWheelZoom.disable();

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

    // Callback for action when geocoder fires
    geocoder.markGeocode = function(result) {
      map.setView(result.center, 16);
      var lat = result.center.lat;
      var lon = result.center.lng;
      document.getElementById('lat_hide').value = lat;
      document.getElementById('lon_hide').value = lon;
      hasGeo = true;
      L.marker([lat, lon]).addTo(map);
    };
  });
}
