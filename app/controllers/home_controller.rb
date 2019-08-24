class HomeController < ApplicationController
  def main; end

  def index
    #@patrocinados = Event.where(:sponsor => true, date: (Time.zone.now - 3.hours)..1.years.from_now.to_time)
    @patrocinados = Event.joins(:event_status).where(:event_statuses => {:name => "Activo"}, :sponsor => true, date: (Time.zone.now - 3.hours)..1.month.from_now.to_time)
  end
end
