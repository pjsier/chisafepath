/* Front-end check on EXIF data if image uploaded */

$(':file').change(function(){
  var file = this.files[0];

  EXIF.getData(file, function() {
    if (EXIF.getTag(file, "GPSLatitude") === undefined) {
      $('#geo-warn').text("Image is not geo-tagged, please enter the location through one of the following fields");
    }
    else {
      var lat = EXIF.getTag(file, "GPSLatitude");
      var latref = EXIF.getTag(file, "GPSLatitudeRef");
      var long = EXIF.getTag(file, "GPSLongitude");
      var longref = EXIF.getTag(file, "GPSLongitudeRef");
      var latlong = dms2dec(lat, latref, long, longref);
      console.log(latlong);
      setLatLong(latlong);
    }
  });
});

function setLatLong(latlong) {
  document.getElementById("issue_lat").value = latlong[0];
  document.getElementById("issue_long").value = latlong[1];
}

/* Form submit main function */
/*
$('form').submit(function(e) {
  e.preventDefault();
  document.getElementsByTagName('submit')[0].innerHTML = "<img src='assets/throbber.gif' />";

  var checked_items = [].slice.call(document.querySelectorAll("input[type='checkbox']:checked"));
  checked_items.map(function(check) {issue_obj.issue.issues.push(check.value)});

  if (document.getElementById('other_issue').value.length != 0) {
    issue_obj.issue.issues.push(document.getElementById('other_issue').value);
  }

  if (issue_obj.issue.issues.length === 0) {
    issue_obj.issue.issues.push("Sidewalk hazard");
  }

  if (document.getElementById("userPhoto").value != "") {
    var file = $(':file').prop('files')[0];
    var lat = EXIF.getTag(file, "GPSLatitude"),
      latref = EXIF.getTag(file, "GPSLatitudeRef"),
      long = EXIF.getTag(file, "GPSLongitude"),
      longref = EXIF.getTag(file, "GPSLongitudeRef");

    // Eventually post to image service or check w/CarrierWave
  }
  else if (issue_obj.issue.lat !== null) {
    $.ajax({
      type: "POST",
      url: '/issue',
      data: JSON.stringify(issue_obj),
      dataType: "json",
      success: function (response) {
        console.log(response);
        window.location.href = '/submitted';
      },
      error: function (e) {
        document.getElementById('geo-submit').innerHTML = "Submit";
        document.getElementById("submit-warn").innerHTML = "<b style='color:red'>Error occurred, please check your connection and try again</b><br><br>";
      },
      contentType: 'application/json'
    });
  }
  else {
    document.getElementById("submit-warn").innerHTML = "<b style='color:red'>Please enter one form of location information</b><br><br>";
    document.getElementById('geo-submit').innerHTML = "Submit";
  }
});
*/
function getLocation() {
  if (navigator.geolocation)
  {
    document.getElementById('loc-button').innerHTML = "<img src='assets/throbber.gif' />";
    navigator.geolocation.getCurrentPosition(function(position) {
      setLatLong([position.coords.latitude, position.coords.longitude]);
      document.getElementById('loc-button').innerHTML = "Get Location";
      document.getElementById('geo-button-res').innerHTML = "Success!";
    });
  }
  else {
    document.getElementById('geo-button-res').innerHTML = "Geolocation is not supported by this browser";
  }
}

var API_RATE_LIMIT = 500;
var inputElement = document.getElementById("addr-search");
var mapzen_key = "search-F2Xk0nk";
var auto_url = 'https://search.mapzen.com/v1/autocomplete';
var search_url = 'https://search.mapzen.com/v1/search';
var addr_matches = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace("name"),
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  local: []
});

$('.typeahead').typeahead({
  highlight: true
},
{
  name: 'addresses',
  displayKey: 'name',
  source: addr_matches
});

function searchAddress(submitAddr) {
  var params = {
    api_key: mapzen_key,
    "focus.point.lon": -87.63,
    "focus.point.lat": 41.88,
    text: inputElement.value
  };
  if (inputElement.value.length > 0) {
    callMapzen(params, auto_url);
  }
  else if (inputElement.value.length > 0) {
    callMapzen(params, search_url);
  }
};

function callMapzen(search_params, url) {
  $.ajax({
    url: url,
    data: search_params,
    dataType: "json",
    success: function(data) {
      if (url === auto_url && data.features.length > 0) {
        addr_matches.clear();
        addr_matches.add(data.features.map(function(addr) {
          addr.name = addr.properties.label;
          return addr;
        }));
      }
      else if (url === search_url) {
        if (data && data.features) {
          setLatLong(data.features[0].geometry.coordinates);
        }
      }
    },
    error: function(e) {
      console.log(e);
    }
  });
}

inputElement.addEventListener('keyup', throttle(searchAddress, API_RATE_LIMIT));
$('.typeahead').bind('typeahead:select', function(e, data) {
  issue_obj.issue.lat = data.geometry.coordinates[0];
  issue_obj.issue.long = data.geometry.coordinates[1];
});

inputElement.addEventListener('keyup', function (e) {
  if (e.keyCode == 13) {
    searchAddress(true);
  }
});

/*
* throttle Utility function (borrowed from underscore)
*/
function throttle (func, wait, options) {
  var context, args, result;
  var timeout = null;
  var previous = 0;
  if (!options) options = {};
  var later = function () {
    previous = options.leading === false ? 0 : new Date().getTime();
    timeout = null;
    result = func.apply(context, args);
    if (!timeout) context = args = null;
  };
  return function () {
    var now = new Date().getTime();
    if (!previous && options.leading === false) previous = now;
    var remaining = wait - (now - previous);
    context = this;
    args = arguments;
    if (remaining <= 0 || remaining > wait) {
      if (timeout) {
        clearTimeout(timeout);
        timeout = null;
      }
      previous = now;
      result = func.apply(context, args);
      if (!timeout) context = args = null;
    } else if (!timeout && options.trailing !== false) {
      timeout = setTimeout(later, remaining);
    }
    return result;
  };
};
