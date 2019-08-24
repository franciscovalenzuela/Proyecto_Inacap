class UsersController < ApplicationController 
  #before_action :authenticate_user!

  load_and_authorize_resource # llama a ability.rb y chequea que tenga permisos asignados

  def index
    @user = User.find(current_user.id)
    @events = Event.joins(:event_status).where("date < ? and date >= ? and sponsor = ? and event_statuses.name = ?", (7.days.from_now - 3.hours), (Time.now - 3.hours), false, "Activo")
    #@patrocinados = Event.where(sponsor: true)
    @patrocinados = Event.joins(:event_status).where(:event_statuses => {:name => "Activo"}, :sponsor => true, date: (Time.zone.now - 3.hours)..1.month.from_now.to_time)


    #descomentar cuando esten empiezen a registrar eventos recomendados, que esten al dia
    #@patrocinados = Event.where(:sponsor => true, date: (Time.now - 3.hours)..1.months.from_now.to_time).limit(8)
    
  end

  def grid
    if params[:page].present?
      pagina = params[:page]
    else
      pagina = 1
    end
    @events = Event.all.page(pagina)
  end

  def check_username
    if User.where(name: params[:user][:name]).blank?
      respond_to do |format|
        format.json { render json: true }
      end
    else
      respond_to do |format|
        format.json { render json: false }
      end
    end
  end

  def check_email
    if User.where(:email => params[:user][:email]).blank?
      respond_to do |format|
        format.json { render json: true }
      end
    else
      respond_to do |format|
        format.json { render json: false }
      end
    end
  end
  
end
