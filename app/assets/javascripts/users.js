$(function() {

	$.validator.addMethod('c_password', function(value){
	    if(value == $('#user_password').val()){
	        return true;
	    }
	    return false;
	}, "La contraseñas no coinciden");

	$('.formuser').validate({
		rules: {
			'user[name]': {
				required: true,
				remote:'/users/check_username.json'
			},
			'user[email]': {
				required: true,
				email: true,
				remote:'/users/check_email.json'
			},
			'user[password]': {
				required: true,
				minlength: 3
			}			
		},
		messages: {
			'user[name]': {
				required: "Este campo es obligatorio.",
				minlength: "Su nombre de usuario debe tener al menos 3 caracteres.",
				maxlength: "Su nombre de usuario puede tener como maximo 30 caracteres.",
				remote: "El nombre de usuario ya se encuentra registrado."
			},

			'user[email]': {
				required: "Este campo es obligatorio.",
				email: "Porfavor, ingrese un e-mail valido.",
				remote: "El e-mail ya se encuentra registrado."
			},
			'user[password]': {
				required: "Este campo es obligatorio.",
				minlength: "Su nombre de usuario debe tener al menos 3 caracteres."
			}	
		}
	});

	$(document).ready(function() {
    $('#Carousel').carousel({
        interval: 5000
    })
});

//$("#formLoginUser").validate({
//		rules: {
//			'user[email]': {
//				required: true,
//				email: true,
//			}
//		},
//		messages: {
//			'user[email]': {
//				required: "Este campo es obligatorio.",
//				email: "Porfavor, ingrese un e-mail valido."
//			}
//		}
//	});
});
