RailsAdmin.config do |config|
  require "rails_admin/application_controller"
  module RailsAdmin
    class ApplicationController < ::ApplicationController

    before_filter :can_admin?

    private
    def can_admin?
      raise CanCan::AccessDenied unless current_user.user_role.name == "Admin"
    end
  end
end

  ### Popular gems integration

  ## == Devise ==
   config.authenticate_with do
     warden.authenticate! scope: :user
   end
   config.current_user_method(&:current_user)

  ## == Cancan ==
  #config.authorize_with :cancan# AdminAbility
  RailsAdmin.config do |config|
    config.authorize_with :cancan, AdminAbility#, ProducerAbility 
  end



  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
