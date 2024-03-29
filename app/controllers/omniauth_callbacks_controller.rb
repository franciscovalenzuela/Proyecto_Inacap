class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted? #usuario existe se logea con el
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else #sino me redirije hacia el formulario de registro
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :facebook, :all
  alias_method :twitter, :all
  alias_method :google_oauth2, :all

end