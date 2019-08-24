var geocoder; 		//Busqueda de dirección
var map;			//Referencia al mapa
var marker;			//Marcador creación
var markers = [];	//Marcadores Búsqueda
var idMapa;			//ID del mapa, para no abusar de jQuery
var infowindows = [];		//Ventana emergente de busqueda eventos
var colors = [
	'FFFFFF',
	'FF2D2D',
	'4F3CFF',
	'11FF1D',
	'F0FD00',
	'2FEFFF',
	'FFCC55',
	'FF04FF',
	'AEB0A4',
	'417864'];

$(function() {

if ( $( '#mapa-busqueda' ).length ) {

	// //var ciudad_id = $('#event_city_id');
	// if( ciudad_identificador != null) {
	// 	obtenerPosicion( ciudad_identificador );
	// } else {
	// 	obtenerPosicion( 1 );
	// }
	
	idMapa = 'mapa-busqueda';
	window.onload = function(){
		posicion(ciudad_mapa);
		if(markers.length!=0) cleanMap();
		for(i in eventos[0]){
			dibujarMarkers(eventos[0][i]);
		}
		for(i in markers){
			marketClick(markers[i]);
		}
	}
  } else if ( $( '#MapaCreacion' ).length ) {
  		var geocoder = new google.maps.Geocoder();
  		var ciudad_id = $('#event_city_id');
  		var marker;
  		idMapa = 'MapaCreacion';

  		if ( ciudad_id.val() == 0 ){
  			$('#MapaCreacion').hide();
  			//$('#Mapa').hide();
  		} else {
  			obtenerPosicion( ciudad_id.val() );
  		}

  		ciudad_id.on('change', function() {
  			obtenerPosicion( ciudad_id.val() );
  			$('#MapaCreacion').show();
  			//$('#Mapa').show();
  		});

  		
  	} else if ( $( '#mapa-show' ).length ) {
  		idMapa = 'mapa-show';
  		var mapOptions = {
	    	center: new google.maps.LatLng( show_lat, show_lng ),
	    	zoom: 15,
	    	mapTypeId: google.maps.MapTypeId.ROADMAP,
        scrollwheel: false 
	    };

		map = new google.maps.Map(document.getElementById( idMapa ), mapOptions);

		var marker = new google.maps.Marker({
	        map: map,
	        position: new google.maps.LatLng(show_lat,show_lng),
	        animation: google.maps.Animation.DROP,
	     });

  	} else if ( $( '#mapa-edit' ).length ) {
  		var geocoder = new google.maps.Geocoder();
  		var ciudad_id = $('#event_city_id');
  		var marker;
  		idMapa = 'mapa-edit';
  		var mapOptions = {
	    	center: new google.maps.LatLng( edit_lat, edit_lng ),
	    	zoom: 15,
	    	mapTypeId: google.maps.MapTypeId.ROADMAP
	    };

		map = new google.maps.Map(document.getElementById( idMapa ), mapOptions);

		var marker = new google.maps.Marker({
	        map: map,
	        draggable: true,
	        position: new google.maps.LatLng(edit_lat, edit_lng),
	        animation: google.maps.Animation.DROP,
	     });
		
		$('#event_city_id').on("change", function(){
			if ( ciudad_id.val() == 0 ){
	  			$('#mapa-edit').hide();
	  			//$('#Mapa').hide();
	  		} else {
	  			obtenerPosicion( ciudad_id.val() );
	  		}

	  		ciudad_id.on('change', function() {
	  			obtenerPosicion( ciudad_id.val() );
	  			$('#mapa-edit').show();
	  			//$('#Mapa').show();
	  		});
		})
  	}else{

  	}
 
  	$('#buscar').click(function() {
		var direccion = $('#event_address').val();
		var ciudad = $('#event_city_id').children("option").filter(":selected").text();

		geocoder.geocode( {
			'region': 'CL',
			'address': ciudad + " " + direccion
		}, function(results, status){
			if (status == google.maps.GeocoderStatus.OK) {
				cleanMap();

				map.setCenter(results[0].geometry.location);
				if (markers[0] != null) {
					markers[0].setPosition(results[0].geometry.location);				    

				} else {
						markers[0] = new google.maps.Marker({
					        map: map,
					        position: results[0].geometry.location,
					        draggable: true,
	        				animation: google.maps.Animation.DROP
				    	});
				map.setZoom(16);
			    	google.maps.event.clearListeners(map, 'click');
			    	google.maps.event.addListener(markers[0], 'dragend', function(){
				        setPosition(this.getPosition().lat(), this.getPosition().lng());
				    }); 
				}
				setPosition(markers[0].getPosition().lat(),markers[0].getPosition().lng());
				
			} else {
				alert("Seleccione una ciudad");
			}
		});
	});

});

function obtenerPosicion (id) {
	$.ajax({
			type: 'GET',
			url: '/cities/geo.json',
			data: {
				id: id
			},
			success: posicion
		});
}

function posicion (pos) {
	if( map == null ) {
		dibujarMapa (pos);
		if($( '#MapaCreacion' ).length){
			mapClick();
		}
	} else {
		centrarMapa (pos);
	}
}

function dibujarMapa (pos) {
	var mapOptions = {
	    	center: new google.maps.LatLng( pos[0].latitude, pos[0].longitude),
	    	zoom: 14,
	    	mapTypeId: google.maps.MapTypeId.ROADMAP
	    };

	map = new google.maps.Map(document.getElementById( idMapa ), mapOptions);
}

function centrarMapa ( pos ) {
	var posicion = new google.maps.LatLng(pos[0].latitude, pos[0].longitude);
	map.setCenter( posicion );
	map.setZoom(13);
}

function dibujarMarkers (evento) {
	
	var name = evento.name;
	var ident = evento.id;
  	var lat  = evento.latitude;
  	var lng  = evento.longitude;
  	var address = evento.address;
  	var event_id = evento.event_type_id;
  	var pinColor = getColor(event_id);
	var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
        new google.maps.Size(21, 34),
        new google.maps.Point(0,0),
        new google.maps.Point(10, 34));

  	marker = new google.maps.Marker({
        map: map,
        position: new google.maps.LatLng(lat,lng),
        animation: google.maps.Animation.DROP,
        title: name,
        icon: pinImage
     });
  	marker.set('event_id', evento.id);
  	marker.set('event_date', evento.date);
  	marker.set('event_address', evento.address);

  	for(i in links){
  		if (links[i].id == ident) {
  			var contentString = 
		  		'<div class="infowindows">'+
		  			'<div class="col-md-5">'+
		  				'<img class="img-responsive" src="'+links[i].direccion+'" alt="">'+
		  			'</div>'+
		  			'<div class="col-md-7">'+
		  				'<span class="iw-name">'+
		  					name+
		  				'</span>'+
		  				'<br>'+
		  				'<span class="iw-address">'+
		  					address+
		  				'</span>'+
		  			'</div>'+
		  		'</div>';
  		} else {
  			//var contentString = '';
  		}
  	}
  	
  	var infowindow = new google.maps.InfoWindow({
    	content: contentString,
    	disableAutoPan: true
  	});
  	google.maps.event.addListener(marker, 'mouseover', function() {
		infowindow.open(map,this);
	});
	google.maps.event.addListener(marker, 'mouseout', function() {
		infowindow.close();
	});

	markers.push(marker);
	infowindows.push(infowindow);
}

function getColor (event_type_id) {
	var color;
	switch	(event_type_id) {
		case 1:
			color = colors[1];
			break;
		case 2:
			color = colors[2];
			break;
		case 3:
			color = colors[3];
			break;
		case 4:
			color = colors[4];
			break;
		case 5:
			color = colors[5];
			break;
		case 6:
			color = colors[6];
			break;
		case 7:
			color = colors[7];
			break;
		case 8:
			color = colors[8];
			break;
		case 9:
			color = colors[9];
			break;
		default:
			color = colors[0];
	}

	return color;
}

function marketClick (marker) {
	google.maps.event.addListener(marker, "click", function () {
		var marker_id_evento = marker.event_id;
		window.location.href = '/events/'+marker_id_evento;
	});
}

function mapClick () {
	google.maps.event.addListenerOnce(map, 'click', function(event){
	    var lat = event.latLng.lat();
	    var lng = event.latLng.lng();
	    markers[0] = new google.maps.Marker({
	       	position: new google.maps.LatLng(lat,lng),
	        map: map,
	        draggable: true,
	        animation: google.maps.Animation.DROP
	    });
	    setPosition(markers[0].getPosition().lat(), markers[0].getPosition().lng());

	    google.maps.event.addListener(markers[0], 'dragend', function(){
	        setPosition(this.getPosition().lat(), this.getPosition().lng());
	    });   
	});
}

function setPosition(latitud, longitud) {
	
    $('#event_latitude').attr('value', latitud);
    $('#event_longitude').attr('value', longitud);
}

function cleanMap() {
  	for(i in markers){
   		markers[i].setMap(null);
  	}
  	markers.length = 0;
}