class Producers::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, :current_password, :name, :rut, :phone, :adress, :city_id, :avatar)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:email, :password, :password_confirmation, :current_password, :name, :rut, :phone, :adress, :city_id, :avatar, :api_key, :merchant_id, :account_id )}
  end
    def update
      @producer = Producer.find(current_producer.id)
      successfully_updated = if needs_password?(@producer, params)
        @producer.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
      else
        params[:producer].delete(:current_password)
        params[:producer].delete(:password)
        params[:producer].delete(:password_confirmation)
        @producer.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
      end
  
      if successfully_updated
        set_flash_message :notice, :updated
        sign_in @producer, :bypass => true
        redirect_to after_update_path_for(@producer)
      else
        render "edit"
      end
  end

  def create
    if Rails.env.production?
      #flash[:info] = 'El registro no es disponible por ahora, lo sentimos'
      #redirect_to root_path
      super
    else
      super
    end 
  end
  
    private
  
    # Pide password si se quiere modificar el email
    def needs_password?(producer, params)
      producer.email != params[:producer][:email] ||
        params[:producer][:password].present?
    end
end