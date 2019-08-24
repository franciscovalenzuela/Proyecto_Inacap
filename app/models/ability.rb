class Ability
  include CanCan::Ability	
# ability.rb = user
# admin_ability.rb = admin
# producer_ability.rb = producer
  def initialize(user)
      unless user
        can [:new, :create, :sign_in, :sign_up, :check_username, :check_email, :check_run, :log], [Producer, User]
        cannot [:new, :destroy, :update], Event  
        can [:show, :index, :search, :siete_dias_app, :patrocinados_app, :buscar_app, :lista_app, :view_app], Event  
	      cannot [:account, :edit, :destroy, :update], [Producer, User]
        can [:geo], City
        can [:view_app, :check_app], Ticket
        #can :manage, :all#comentar esto si se quiere quitar permiso admin 
      else
        if user.has_role? :normal
          can :manage, User
          can [:new, :create, :sign_in, :sign_up, :check_username, :check_email, :check_run, :log], [Producer]
          cannot [:account, :edit, :destroy, :update], Producer
          cannot [:new, :destroy, :update], Event  
          can [:show, :index, :search, :detail], Event  
          can [:ticket_free, :result_free, :result], Transaction
          can [:view_app, :check_app, :index, :pdf, :render_pdf], Ticket
          #can :manage, :all# esto si se quiere quitar permiso admin 
        end
      end
   end
 end
