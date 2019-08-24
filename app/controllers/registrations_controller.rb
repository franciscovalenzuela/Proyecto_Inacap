class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?

  
  def update_sanitized_params
   devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, :current_password, :name, :run, :phone, :adress, :city_id, :avatar)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:email, :password, :password_confirmation, :current_password, :name, :run, :phone, :adress, :city_id, :avatar, :first_name, :last_name
 )}
  end
  def update
      @user = User.find(current_user.id)
      successfully_updated = if needs_password?(@user, params)
        @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
      else
        # remove the virtual current_password attribute
        # update_without_password doesn't know how to ignore it
        params[:user].delete(:current_password)
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
        @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
      end
  
      if successfully_updated
        set_flash_message :notice, :updated
        # Sign in the user bypassing validation in case their password changed
        sign_in @user, :bypass => true
        redirect_to after_update_path_for(@user)
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
  
    # check if we need password to update user data
    # ie if password or email was changed
    # extend this as needed
    def needs_password?(user, params)
      user.email != params[:user][:email] ||
        params[:user][:password].present?
  end
  
end
