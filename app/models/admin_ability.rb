class AdminAbility
  include CanCan::Ability
  def initialize(user)
      can :dashboard
      can :access, :rails_admin
      can :manage, :all   
  end
end
