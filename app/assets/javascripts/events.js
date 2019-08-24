$(function() {

	$('#r-mapa').hide();
	$('#r-evento').show();
	showdate();
	previmg();
	flayer_reset();
	entersubmitdis();
        $('#area').find( 'textarea' ).keyup();

	$('#btn-mosaico').on('click', function(){
		$('#r-mapa').hide();
		$('#r-evento').show();
		$('#r-paginator').show();
		$('#btn-mosaico').addClass('active');
		$('#btn-mapa').removeClass('active');
	});

	$('#btn-mapa').on('click', function(){
		$('#r-evento').hide();
		$('#r-paginator').hide();
		$('#r-mapa').show();
		$('#btn-mapa').addClass('active');
		$('#btn-mosaico').removeClass('active');
		var latlng = map.getCenter();
		google.maps.event.trigger(map, 'resize');
		map.setCenter(latlng);

	});

	$('#new_event').validate({
		rules: {
			'event[name]': {
				required: true	
			},
			'event[event_type_id]': {
				required: true
			},
			'event[date]': {
				required: true,
			},
			'event[city_id]': {
				required: true
			},
			'event[address]': {
				required: true
			}
		},
		messages: {
			'event[name]': {
				required: 'Debe ingresar el nombre del evento.'
			},
			'event[event_type_id]': {
				required: 'Debe seleccionar una categoria.'
			},
			'event[date]': {
				required: 'Debe ingresar una fecha.'
			},
			'event[city_id]': {
				required: 'Debe seleccionar una ciudad'
			},
			'event[address]': {
				required: 'Debe ingresar una direccion'
			}
		}
	});

  var i=0;
  $( "#btn-ticket" ).click(function(){
    if (i ==0){
      $("body").animate({ scrollTop: ($('#section-ticket').offset().top) }, "slow");
      i=1;
    }else{

    }
    //alert("Boton ticket");
    i=0;
  });


	$( "#btnfecha" ).click(function() {
		$('#fecha_desde').datetimepicker().datetimepicker( "show" );
	});

	$( "#btnfecha2" ).click(function() {
		$('#fecha_hasta').datetimepicker().datetimepicker( "show" );
	});

	function previmg() {
	  $('.file').preimage();
	  $('#event_img').on("click", function(){$('#event_img').val('');$('#prev_event_img').empty();$("#tip").remove();$(".prev_container").hide();});
	}

	function flayer_reset(){
		//alert(flayer_act);
		$("#event_img").on("change", function(){
			$("form input:radio[name=prin]").click(function(){
			    if(flayer_act === true){
			      	alert("Ya hay un flayer registrado, vuelva a intentarlo");
                	$('#event_img').val('');
                	$('#prev_event_img').empty();
                	$("#tip").remove();
                	$(".prev_container").hide();
                }else{

                }
			});
		});
	}

	function showdate() {
	  $("#fecha").click(function(){$('.f-datetime').datetimepicker().datetimepicker( "show" )});
	}

	function entersubmitdis(){
		$("#new_event").bind("keypress", function(e) {
	        if (e.keyCode == 13) {
	            return false;
	        }
	    });
	}

    $('#event_address').keypress(function(e){ //activar busqueda de direccion, con la tecla enter
        if(e.which == 13){
          $('#buscar').click();
        }
    });

    $('#area').on( 'keyup', 'textarea', function (e){
        $(this).css('height', 'auto' );
        $(this).height( this.scrollHeight );
    });

    function autoheight(a) {
      if (!$(a).prop('scrollTop')) {
        do {
              var b = $(a).prop('scrollHeight');
              var h = $(a).height();
                $(a).height(h - 5);
        }while (b && (b != $(a).prop('scrollHeight')));
       };
      $(a).height($(a).prop('scrollHeight') + 20);
    }
      
    autoheight($("#event_description"));
});
