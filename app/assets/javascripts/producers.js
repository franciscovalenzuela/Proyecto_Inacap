
$(document).ready(function() {
	 //	var data = new google.visualization.DataTable(); 
	//console.log(data);

	$.validator.addMethod('p_password', function(value){
	    if(value == $('#producer_password').val()){
	        return true;
	    }
	    return false;
	}, "La contraseñas no coinciden");

	$.validator.addMethod("rut", function(value, element) {
	  	return this.optional(element) || $.Rut.validar(value);
	}, "Este campo debe ser un rut valido.");

	$('.formproducer').validate({
		rules: {
			'producer[rut]': {
				required: true,
				minlength: 9,
				maxlength: 10,
				remote: '/producers/check_run.json',
				rut: true
			},
			'producer[name]': {
				required: true,
				minlength: 3,
				maxlength: 30,
				remote:'/producers/check_username.json'
			},
			'producer[email]': {
				required: true,
				email: true,
				remote:'/producers/check_email.json'
			},
			'producer[password]': {
				required: true,
				minlength: 3
			}			
		},
		messages: {
			'producer[rut]': {
				required: "Este campo es obligatorio.",
				minlength: "Rut Incorrecto.",
				maxlength: "Rut Incorrecto.",
				remote: "El run ya se encuentra registrado."
			},
			'producer[name]': {
				required: "Este campo es obligatorio.",
				minlength: "Su nombre de usuario debe tener al menos 3 caracteres.",
				maxlength: "Su nombre de usuario puede tener como maximo 30 caracteres.",
				remote: "El nombre de usuario ya se encuentra registrado."
			},

			'producer[email]': {
				required: "Este campo es obligatorio.",
				email: "Porfavor, ingrese un e-mail valido.",
				remote: "El e-mail ya se encuentra registrado."
			},
			'producer[password]': {
				required: "Este campo es obligatorio.",
				minlength: "Su nombre de usuario debe tener al menos 3 caracteres."
			}	
		}
	});
});

$(document).ready(function () {
    $("ul[data-liffect] li").each(function (i) {
        $(this).attr("style", "-webkit-animation-delay:" + i * 1000 + "ms;"
                + "-moz-animation-delay:" + i * 1000 + "ms;"
                + "-o-animation-delay:" + i * 1000 + "ms;"
                + "animation-delay:" + i * 1000 + "ms;");
        if (i == $("ul[data-liffect] li").size() -1) {
            $("ul[data-liffect]").addClass("play")
        }
    });
    $("#tabla").hide();
    $("#salir").hide();
    $("#form_pdf").hide();

    $(".reportepdf").click(function(){
		$("#event").val($(this).attr("value"));
	});
  
});


var requestSent = false;

function grafico(e, chart, data1, valor) {
	
    if(!requestSent) {
      requestSent = true;
		$.ajax({
				type: 'GET',
				url: '/producers/report.json',
				data: {
					nombre: valor
				},
				success: function(data) {
					respuesta(data);
				    },
				timeout: 15000,
				complete: function() {
	                requestSent = false;
	         		},
				});

				function respuesta(data){
				   
				     var vista = data.vistas;
				     var usuario = data.usuarios;
				     var asistencia= data.asistencias;
				     var option = { backgroundColor:'transparent', 
					                  width: 1000, height: 340, 
					                  title: 'Detalle por Evento',
					                  pointSize: 8,
					                  pointColor: '#ffffff',
					                  curveType: 'function',
					                  focusTarget: 'category',
					                  explorer: { maxZoomOut:2, keepInBounds: true },
					                  crosshair: { trigger: 'focus' }, 
					                  colors:['#EAE874','#2FABE9', '#FA5833'],  
					                  chartArea: { backgroundColor: 'white', width: '93%', height: '60%'}, 
					                  titleTextStyle: {color: 'black', fontSize: 16}, 
					                  hAxis:{ textStyle: {color: 'black'}, format:'MMM d' },
					                  vAxis:{textStyle: {color: 'black'}}, 
					                  legend: { textStyle: {color: 'black', bold: true, fontSize: 16}, alignment: 'center', position: 'bottom'},
					                  animation: { duration: 1000,  easing: 'out'}}
						for (var i = 0; i < vista.length - 1; i++) {		
								data1.setValue(i, 1, vista[i]);
								data1.setValue(i, 2, usuario[i]);
								data1.setValue(i, 3, asistencia[i]);
						};
						         
						chart.draw(data1, option);
				};
	}		
}

function foto (e, chart) {

    if(!requestSent) {
      requestSent = true;
		$.ajax({
				type: 'POST',
				dataType: 'json',
				url: '/producers/temp_img',
				data: {
					imagen: chart
				},
				success: function(data) {
					//console.log(data.ruta);
					//
				
					$("#dir").val(data.ruta);
					$("#salir").trigger("click");

				},
				timeout: 15000,
				complete: function() {
	                requestSent = false;
	         		},
				});
	}
}


function foto_grafico(e, chart, data1, valor) {
	
    if(!requestSent) {
      requestSent = true;
		$.ajax({
				type: 'GET',
				url: '/producers/report/'+valor+'.json',
				data: {
					evento: valor
				},
				success: function(data) {
					respuesta(data);
				    },
				timeout: 15000,
				complete: function() {
	                requestSent = false;
	         		},
				});

				function respuesta(data){
				   
				     var vendida = data.vendido;
				     var novendida = data.novendido;
				     var nombre = data.nombre;
				     var option  = { 
							       width: 650, 
      							   height:400, 
							      title: 'Entradas Vendidas por Sector', 
							      chartArea: { left:30, top:20, backgroundColor: 'white', width: '80%', height: '90%'}, 
							      legend: {textStyle: {color: 'black', bold: true, fontSize: 10}, alignment: 'center'},
							      annotations: {
							                    textStyle: {
							                      fontName: 'Arvo',
							                      fontSize: 20,
							                      bold: true,
							                      color: '#ffffff',    
							                      auraColor: '#635f5f', 
							                      opacity: 1          
							                              }
							                    }
							 
							       }
						for (var i = 0; i < novendida.length ; i++) {	
								data1.setValue(i, 0, nombre[i]);	
								data1.setValue(i, 1, vendida[i]);
								data1.setValue(i, 2, vendida[i]);
								data1.setValue(i, 3, novendida[i]);
								data1.setValue(i, 4, novendida[i]);

						};   
						chart.draw(data1, option);
						google.load("visualization", "1", {"packages":["corechart"], "callback": function(e) { foto(e, chart.getImageURI()); }});
						
						
				};
	}		
}




