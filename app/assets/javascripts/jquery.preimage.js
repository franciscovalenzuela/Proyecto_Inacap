var tmns = [];
(function( $ ){
  var settings = {
                'scale': 'contain', // cover
                'prefix': 'prev_',
                'types': ['image/gif', 'image/png', 'image/jpeg'],
                'mime': {'jpe': 'image/jpeg', 'jpeg': 'image/jpeg', 'jpg': 'image/jpeg', 'gif': 'image/gif', 'png': 'image/png', 'x-png': 'image/png', 'tif': 'image/tiff', 'tiff': 'image/tiff'}
        };

  var methods = {
     init : function( options ) {
                settings = $.extend(settings, options);
                
                return this.each(function(){
                        $(this).bind('change', methods.change);
                });
     },
     destroy : function( ) {
                return this.each(function(){
                        $(this).unbind('change');
                })
     },
     change : function(event) {
             var id = this.id
             
             $('#'+settings['prefix']+id).html('');

             if(window.FileReader){

                for(i=0; i<this.files.length; i++){
                   if($.inArray(this.files[i].type, settings['types']) == -1){
                       alert("Solo imagenes");        
                       return false
                   }else if(this.files[i].size > 1048576){
                       alert("Solo imagenes de 1MB");        
                       return false
                   }
               }
		     // en este orden: crea contenedor, lee el archivo, una ves leidos, esperar a que cargen las imagenes, y desplega el html
		     $('#'+settings['prefix']+this.id).html('').addClass(settings['prefix']+'container').show();
		     if (this.files.length <= 5){

                for(i=0; i<this.files.length; i++){

                    var reader = new FileReader();
                    tmns[i] = this.files[i].size;  
                    var vld = 0;
                    var ab = 0;                           
                    var its = -1;
                    reader.onload = function (e) { 

                        var imagen = new Image();
                        its+=1;
                        var s = ~~(tmns[its]/1024) +'KB';
                        imagen.src = e.target.result;
                        imagen.onload = function(){
                            vld+=1;
                            if(id == "user_avatar" || id == "producer_avatar"){
                                $('<div class="col-md-8"><p style="color:black;"> Imagen de Perfil<img src="'+imagen.src+'" class="img-responsive thumbnail imgnp"></p></div>').appendTo($('#'+settings['prefix']+id));
                            }else if (id == "event_img"){
							  //definir tamaños
                               if(imagen.width < 1349 && imagen.height < 2074){
                                    $('<div class="row row-preview"><div class="col-md-4"><img src="'+imagen.src+'" class="img-responsive thumbnail imgnp"></div><div class="col-md-6"><input id="event_img" name="prin" type="radio" value="'+vld+'">  <strong>'+imagen.width+'x'+imagen.height+' '+s+'</strong></div></div>').appendTo($('#'+settings['prefix']+id));
                                }else{
                                 alert("Por favor solo imagenes de tamaño (por definir)");
                                    return false;
                                }
                            } 
                        };
                 };
                 reader.readAsDataURL(this.files[i]);
             }
             $('<p><strong id="tip">Seleccione la imagen que será afiche</strong></p>').appendTo($("#helpflayer")); 

             }else{
                alert("Solo se puede subir 5 imágenes");
             }
        }
     }
  };

  $.fn.preimage = function( method ) {
    if ( methods[method] ) {
        return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
        return methods.init.apply( this, arguments );
    } else {
        $.error( 'Method ' + method + ' does not exist on jQuery.preimage' );
    }
  };

})( jQuery );
