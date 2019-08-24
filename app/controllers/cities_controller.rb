class CitiesController < ApplicationController
  load_and_authorize_resource # llama a ability.rb y chequea que tenga permisos asignados
  def geo
		ciudad = params[:id]
		@ubication = City.where(id: ciudad)
		respond_to do |format|
			format.json { render json: @ubication }
		end
	end
end
