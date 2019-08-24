module ApplicationHelper
#por ahora funciona
  def  current_ability
 	  if producer_signed_in?
          @current_ability ||= ProducerAbility.new(current_producer)
    elsif user_signed_in?
	    if current_user.user_role.name == "Normal"
             @current_ability ||= Ability.new(current_user)
	    elsif current_user.user_role.name == "Admin"
             @current_ability ||= AdminAbility.new(current_user)
	    end
    else
      @current_ability ||= Ability.new(current_user)
    end  
  end
 def resource_name
    :producer
 end
 
  def resource
    @resource ||= Producer.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:producer]
  end
#opcional..?     
 # def current_ability
 #   @current_ability or @current_ability = Ability.new(current_auth_resource)
 # end
  # def current_ability
  #   @current_ability ||= case
  #                        when current_user
  #                          Ability.new(current_user)
  #                        when current_producer
  #                          ProducerAbility.new(current_producer)
  #                        else 
  #                          Ability.new(current_user)
  #                        end
  # end

  def title(page_title)
    content_for :title, "PanoramaSur - "+page_title.to_s
  end

end
