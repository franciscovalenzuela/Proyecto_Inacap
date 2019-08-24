class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout :layout_by_resource
  include ApplicationHelper
  protect_from_forgery with: :exception
  #load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to '/'
  end

  before_filter do
     resource = controller_name.singularize.to_sym
     method = "#{resource}_params"
     params[resource] &&= send(method) if respond_to?(method, true)
  end

  protected 
  def layout_by_resource
    if devise_controller? && resource_name == :producer
      "application"
    else
      "application"
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(:user) || root_path
  end
  
end
