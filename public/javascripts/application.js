var initialLocation;
var siberia = new google.maps.LatLng(60, 105);
var newyork = new google.maps.LatLng(40.69847032728747, -73.9514422416687);
var browserSupportFlag =  new Boolean();
var map;
var infowindow = new google.maps.InfoWindow();
  
function initialize_map(points) {
  var myOptions = {
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  for(var i=0; i < points.length; i++) {
	  var marker = new google.maps.Marker({
	      position: points[i], 
	      map: map
	  });
  }
  google.maps.event.addListener(map, 'click', function(event) {
	$( "#dialog" ).dialog({modal:true});
	var form = $("new_location_form");
	$("#location_lon").val(event.latLng.lng());
	$("#location_lat").val(event.latLng.lat());	
    placeMarker(event.latLng);
  });  

  function postLocationToServer(event) {
	$.ajax({
	   type: "POST",
	   url: "locations",
	   data: $(event.target).serialize(),
	   success: function(msg){
	     alert( "Data Saved: " + msg );
	   }
	 });	
  }
  // Try W3C Geolocation method (Preferred)
  if(navigator.geolocation) {
    browserSupportFlag = true;
    navigator.geolocation.getCurrentPosition(function(position) {
      initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
      contentString = "Welcome. Please click on a location to save it";
      map.setCenter(initialLocation);
      infowindow.setContent(contentString);
      infowindow.setPosition(initialLocation);
      infowindow.open(map);
    }, function() {
      handleNoGeolocation(browserSupportFlag);
    });
  } else if (google.gears) {
    // Try Google Gears Geolocation
    browserSupportFlag = true;
    var geo = google.gears.factory.create('beta.geolocation');
    geo.getCurrentPosition(function(position) {
      initialLocation = new google.maps.LatLng(position.latitude,position.longitude);
      contentString = "Location found using Google Gears";
      map.setCenter(initialLocation);
      infowindow.setContent(contentString);
      infowindow.setPosition(initialLocation);
      infowindow.open(map);
    }, function() {
      handleNoGeolocation(browserSupportFlag);
    });
  } else {
    // Browser doesn't support Geolocation
    browserSupportFlag = false;
    handleNoGeolocation(browserSupportFlag);
  }
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag == true) {
    initialLocation = newyork;
    contentString = "Error: The Geolocation service failed.";
  } else {
    initialLocation = siberia;
    contentString = "Error: Your browser doesn't support geolocation. Are you in Siberia?";
  }
  map.setCenter(initialLocation);
  infowindow.setContent(contentString);
  infowindow.setPosition(initialLocation);
  infowindow.open(map);
}

function placeMarker(location) {
  var marker = new google.maps.Marker({
      position: location, 
      map: map
  });
  console.log(location);
  map.setCenter(location);
}


$(function() {
	$("#new_location").submit(function(event) {
		postLocationToServer(event);
	});
});