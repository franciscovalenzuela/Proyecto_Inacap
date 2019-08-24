class SectionsController < ApplicationController

	def new
		if current_producer.producer_role.name == "Silver"
			@precio_libre = false
		else
			@precio_libre = true
		end

		@event_id = params[:id]
		@event = Event.find(@event_id)
		@sections = Section.where(event_id: @event_id)
		@section = Section.new
	end

	def create
		@section = Section.create(section_params)
		respond_to do |format|
			if @section.save
      	format.js
    	else
      	
    	end
    end
	end

	def section_params
		params.require(:section).permit(:name, :price, :from, :to, :state, :stock, :event_id)
	end
	
end
