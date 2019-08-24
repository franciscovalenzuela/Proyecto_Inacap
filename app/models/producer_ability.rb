class ProducerAbility
  include CanCan::Ability
  def initialize(producer) 
      if producer.has_rolep :silver 
        can :manage, Event  
        can :manage, Producer  
      	cannot [:edit, :destroy, :update, :sign_in], User
      	can [:new, :create, :sign_up], User
        can :manage, City
        #can :manage, :all#descomenta esto si se quiere permiso admin 
      elsif producer.has_rolep :gold
        can :manage, Event  
        can :manage, Producer  
      	cannot [:edit, :destroy, :update, :sign_in], User
      	can [:new, :create, :sign_up], User
        can :manage, City
        #can :manage, :all#descomenta esto si se quiere permiso admin 
      end
   end
 end
