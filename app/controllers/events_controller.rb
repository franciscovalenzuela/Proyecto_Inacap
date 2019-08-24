class EventsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_filter :custom_auth, :only => [:detail]
  load_and_authorize_resource # llama a ability.rb y chequea que tenga permisos asignados

  def index
    @events = Event.find(:all)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @event = Event.friendly.find(params[:id])
    @mostrar_meta = true
    @producer = Producer.find(@event.producer_id)
    url_image = @event.to_json(:only => [:id], :methods => [:thumb_url])
    @url_thumb = JSON.parse(url_image)
    @sections = Section.where(:event_id => @event)
    impressionist(@event)
    @patrocinados = Event.where(:sponsor => true, date: (Time.now - 3.hours)..1.years.from_now.to_time).limit(6)
    start_time = 17.days.ago.to_time
    @topviews = Event.joins(:impressions).
	    where("impressions.created_at<='#{Time.now.utc}' and impressions.created_at>='#{start_time}'").
            group("impressions.impressionable_id, events.id").
            order("count(impressions.id) DESC").limit(4)
  end

  def new
    if current_producer.producer_role.name == "Silver"
      fecha_limite = current_producer.created_at + 3.month
      if fecha_limite > Date.today
        @producer_id = current_producer.id
        @event = Event.new
      else
        render "golden"
      end
    else
      @producer_id = current_producer.id
      @event = Event.new
    end
  end

  def search
    condiciones = {}

    #para buscar ciudad desde index
    if params[:city].present?
      city = params[:city][:id].to_s
      ciudad = City.where(slug: city)
      condiciones[:city_id] = ciudad.first.id unless ciudad.first.id.blank?
      @ciudad = ciudad
    end

    #para buscar ciudad desde search
    if params[:ciudad_busqueda].present?
      city = params[:ciudad_busqueda].to_s
      condiciones[:city_id] = city unless city.blank?
      @ciudad = City.where(id: city)
    end

    if params[:event_type].present?
      event_type = params[:event_type][:id].to_s
      condiciones[:event_type_id] = event_type unless event_type.blank?
    end

    if params[:fecha_desde].present?
      fecha_desde = params[:fecha_desde].to_s
      fecha_hasta = params[:fecha_hasta].to_s
      condiciones[:date] = fecha_desde..fecha_hasta
    else
      fecha_hoy = Time.now.to_s
      fecha_hasta = 1.years.from_now.to_time.to_s
      condiciones[:date] = fecha_hoy..fecha_hasta
    end
    
    if params[:page].present?
      pagina = params[:page]
    else
      pagina = 1
    end
    if @ciudad.nil?
      @ciudad = City.where(id: 2)
    end
    @events_map = Event.joins(:event_status).where(condiciones).where(:event_statuses => {:name => "Activo"})
    @events = Event.joins(:event_status).where(condiciones).where(:event_statuses => {:name => "Activo"}).page(pagina)
  end

  def create
  	@event = Event.create(event_params)
	  vlt=0
  	#@event.date = @event.date.to_s(:db) 
	  params[:img].each do |i|#por cada elemento del arreglo img[], el argumento i va tomando su valor
	    vlt+=1
	    if params[:prin] == vlt.to_s 
              @event.images.build(:img => i,"flayer" => "1")# datos enviados a la tabla image
	    else
	      @event.images.build(:img => i)
	    end
	  end

  	if @event.save
  	  redirect_to "/"
  	else
  	  redirect_to events_new_path
      flash[:info] = "A ocurrido un error "
  	end
  end

  def detail
    if current_user.name.blank? == false && current_user.last_name.blank? == false && current_user.phone.blank? == false && current_user.adress.blank? == false && current_user.city_id.blank? == false
        @event           = Event.find(params[:id])
        @section         = Section.find(params[:section])
        @cantidad        = params[:cantidad]

        producer         = Producer.find(@event.producer_id)
        apiKey           = producer.api_key 
        @merchantId      = producer.merchant_id
        @accountId       = producer.account_id

        @description     = @section.name + ' - ' + @event.name
        @amount          = @cantidad.to_i * @section.price.to_i
        @currency        = "COP"

        #ReferenceCode   = userId+"~"+sectionId+"~"+producerId+"~"+MD5(time)
        referenciaHash   = Digest::MD5.hexdigest(Time.now.to_s)
        @referenceCode   = current_user.id.to_s+"/"+params[:section].to_s+"/"+@event.producer_id.to_s+"/"+referenciaHash

        
        #Signature       = ApiKey~merchantId~referenceCode~amount~currency
        @signature       = Digest::MD5.hexdigest(apiKey+'~'+@merchantId.to_s+'~'+@referenceCode+'~'+@amount.to_s+'~'+@currency)

        if current_user
          @user = User.find(current_user.id)
        end

        if @amount == 0
          @entrada_gratuita = true
          else
          @entrada_gratuita = false 
        end
    else
      flash[:error] = "Necesita entregar los datos necesarios para la transacción"
      redirect_to "/" and return
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    imagenes = @event.images.find_all
    vlt=0
    unless params[:img]
      imagenes.each do |i|
        vlt+=1
        if params[:event_img] == vlt.to_s 
            i.flayer = "1"
        else
            i.flayer = "0"
        end
      end
      if @event.update_attributes(event_params)
          redirect_to "/"
        else
          render "edit"
      end
    end
    if params[:img]
      params[:img].each do |i|#por cada elemento del arreglo img[], el argumento i va tomando su valor
        vlt+=1
        if params[:prin] == vlt.to_s 
                @event.images.build(:img => i,"flayer" => "1")# datos enviados a la tabla image
        else
          @event.images.build(:img => i)
        end
      end
      if @event.update_attributes(event_params)
        redirect_to "/"
      else
        render "edit"
      end
    end
  end

  def ingresos
    @lista_secciones = Hash.new
    @event = Event.find(params[:id])
    sections = Section.where(event_id: params[:id])

    sections.each_with_index do |s, index|
      acum = Ticket.where(section_id: s.id)
      nombre = s.name
      contador = acum.count
      precio = s.price
      total = precio*contador
      @lista_secciones[index] = { :nombre => nombre, :cantidad => contador, :precio => precio, :total => total } 
    end

    formatter = GoogleVisualr::NumberFormat.new( { :prefix => '$', :fractionDigits => 0 } )
    formatter.columns(1)

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Sección')
    data_table.new_column('number', 'Recaudación')
    data_table.add_rows(sections.count)
    data_table.format(formatter)

    sections.each_with_index do |s, index|
      data_table.set_cell(index, 0, @lista_secciones[index][:nombre])
      data_table.set_cell(index, 1, @lista_secciones[index][:total])
    end

    opts   = { 
      :width => 800,
      :height => 480,
      :title => 'Ingresos del evento '+@event.name,
      :is3D => false,
      :pieSliceText => 'value',
      :chartArea => { :left => 10, :top => 40, :bottom => 40, :width => "80%", :height => "90%" }
    }
    @chart = GoogleVisualr::Interactive::PieChart.new(data_table, opts)
  end

  def siete_dias_app
    @events = Event.where(:date => Date.today..Date.today+8)
    #render :json => @events.to_json(:only => [:id, :name, :address, :sponsor, :place_name, :date, :description], :include => [:event_type], :methods => [:flayer_url], :callback => "JSON_CALLBACK")
    response = params[:callback] + '('+ @events.to_json(:only => [:id, :name, :sponsor, :date], :include => [:event_type], :methods => [:thumb_url]) + ')'
    render :text => response
  end

  def patrocinados_app
    @events = Event.where(:sponsor => true)
    response = params[:callback] + '('+ @events.to_json(:only => [:id, :name, :address], :include => [:event_type], :methods => [:thumb_url]) + ')'
    render :text => response
  end

  def buscar_app
    ciudad = params[:ciudad]
    tipo = params[:tipo]
    @events = Event.where(:city_id => ciudad, :event_type_id => tipo)
    response = params[:callback] + '('+ @events.to_json(:only => [:id, :name, :address], :include => [:event_type], :methods => [:thumb_url]) + ')'
    #response = ciudad
    render :text => response
  end

  def lista_app
    producer_id = params[:producer]
    @events = Event.where(:producer_id => producer_id)
    response = params[:callback] + '('+ @events.to_json(:only => [:id, :name, :date], :include => [:event_type], :methods => [:thumb_url]) + ')'
    render :text => response
  end

  def view_app
    event_id = params[:id]
    @event = Event.find(event_id)
    response = params[:callback] + '('+ @event.to_json(:only => [:id, :name, :date, :address, :latitude, :longitude, :place_name, :sponsor, :description], :include => [:event_type, :city, :producer, :event_status], :methods => [:thumb_url, :original_url, :original_urls, :section_list]) + ')'
    render :text => response
  end

  private
  def event_params
	  params.require(:event).permit(:name, :date, :producer_id, :city_id, :address, :latitude, :longitude, :event_type_id, :event_status_id, :place_name, :description, images_attributes: [:id, :img_file_name, :event_id, :flayer, :_destroy] )
  end

  private
  def custom_auth
    if current_user
       return authenticate_user!
    elsif current_producer
       return authenticate_producer!
    else
      return authenticate_user!
    end
  end

end
