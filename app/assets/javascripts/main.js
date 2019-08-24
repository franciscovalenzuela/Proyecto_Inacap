$(function() {
	
	$('.f-datetime').datetimepicker({
		closeText: 'Seleccionar',
		timeText: 'Seleccionada',
		hourText: 'Hora',
		minuteText: 'Minutos',
		monthNames: ['Enero','Febrero','Маrzo','Аbril','Маyo','Junio',
			'Julio','Аgosto','Septiembre','Оctubre','Noviembre','Diciembre'],
		dayNames: ['Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sábado'],
		dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sa'],
		dateFormat: "yy-mm-dd",
		minDate: new Date()
	});

	$( "#city_id" ).change(function() {
  		$("#select").submit();
	});

	(function(d, s, id) {
	  var js, fjs = d.getElementsByTagName(s)[0];
	  if (d.getElementById(id)) return;
	  js = d.createElement(s); js.id = id;
	  js.src = "//connect.facebook.net/es_LA/sdk.js#xfbml=1&version=v2.0";
	  fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
});
