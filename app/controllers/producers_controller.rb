class ProducersController < ApplicationController 
  #before_action :authenticate_producer!
  load_and_authorize_resource # llama a ability.rb y chequea que tenga permisos asignados

  def index
    @producer = Producer.find(current_producer.id)
    @events = Event.where(producer_id: current_producer.id) 

    respond_to do |format|
      format.html
      format.js 
      format.json 
    end   
  end

  def show
  end

  def report_pdf
    @directorio = params[:dir]
    @events = Event.find(params[:event])
  
    respond_to do |format|
      format.pdf { render_pdf }
    end  
  end

  def new    
  end
  
  def respond   
  end

  def report

   # if params[:page].present?
    #  pagina = params[:page]
    #else
    #  pagina = 1
    #end
    id_evento = params[:evt]
    @eventos_productor = Event.where(id: id_evento)
    @events = Event.where(id: id_evento)
    lis_graph = []
    lista = []
    @events.pluck(:id).each do |e|  
      lis_graph.push(pie_chart(e))
      Section.where(event_id: e).pluck(:id).each {|s| lista.push(acum(s))}
    end
    @section_sale = lista
    @pie = lis_graph
    line_chart
    column_chart
    section_acum
     respond_to do |format|
          format.html
          format.js 
          format.json 
          format.json { render json:  {vistas: @dato_visitas, usuarios: @dato_usuario, asistencias: @dato_asistencia, vendido: @vendidos, novendido: @novendidos, nombre: @nombresecc }}
      end 
  end

  def section_acum
    eventoid = params[:evento]
    seccion = Section.select("id, name, stock").where(event_id: eventoid)
    
    data2 = []
    seccion.pluck(:id).each { |e|  data2.push(acum(e)) }
    stock =  seccion.pluck(:stock)    
    data3 = []
    stock.zip(data2).each do |s, t|
      data3.push(s - t)
    end
    @vendidos = data2
    @novendidos = data3
    @nombresecc = seccion.pluck(:name)
  end

  def line_chart
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('date', 'Day')
      data_table.new_column('number', 'N° Visitas')
      data_table.new_column('number', 'N° Usuarios')
      data_table.new_column('number', 'N° Asistencia')
      variable  = params[:nombre]  

     #todo funciona en base a datos por semana
     eventsid = params[:evt]
     productor_actual = current_producer.id
     fecha_inicio = Event.where(id: eventsid).first
     consulta_eventos = variable || fecha_inicio.id
     #descomentar esto si se quiere por dia
     # fecha = fecha_inicio.created_at...Date.today
     fecha = Date.today
     fecha_grafico = []
     (fecha_inicio.created_at.to_datetime.to_i .. (fecha.to_datetime.to_i + 7.days)).step(7.days) do |date|
        fecha_grafico.push(date)
     end
     
     hora_max = "23:59:59".to_datetime
      #vistas esta por semana, si quiero lo puedo cambiar 
     data1 = []
     data2 = []
     data3 = []
     (fecha_inicio.created_at.to_datetime.to_i .. (DateTime.now.to_datetime.to_i + 7.days)).step(7.days) do |date|
       data1.push(Producer.joins("INNER JOIN events ON events.id = #{eventsid} INNER JOIN impressions ON impressions.impressionable_id = #{consulta_eventos} AND impressions.impressionable_type = 'Event'").
           where("impressions.created_at<='#{Time.at(date).utc + (hora_max.hour - Time.at(date).utc.hour).hours + (hora_max.min - Time.at(date).utc.min).minutes + (hora_max.sec - Time.at(date).utc.sec).seconds}' and impressions.created_at>='#{Time.at(date).utc.change({ hour: 0, min: 0, sec: 0 }) - 6.days}' and impressions.impressionable_id = events.id ").count)
       data2.push(Producer.joins("INNER JOIN events ON events.id = #{eventsid} INNER JOIN impressions ON impressions.impressionable_id = #{consulta_eventos} AND impressions.impressionable_type = 'Event'").
                where("impressions.created_at<='#{Time.at(date).utc + (hora_max.hour - Time.at(date).utc.hour).hours + (hora_max.min - Time.at(date).utc.min).minutes + (hora_max.sec - Time.at(date).utc.sec).seconds}' and impressions.created_at>='#{Time.at(date).utc.change({ hour: 0, min: 0, sec: 0 }) - 6.days}' and impressions.impressionable_id = events.id and impressions.user_id > 0").count)
       data3.push(Producer.where(id: productor_actual).joins("INNER JOIN events ON events.id = #{eventsid} INNER JOIN sections ON sections.event_id = #{consulta_eventos} INNER JOIN transactions ON transactions.section_id = sections.id ").
                where("transactions.created_at<='#{Time.at(date).utc + (hora_max.hour - Time.at(date).utc.hour).hours + (hora_max.min - Time.at(date).utc.min).minutes + (hora_max.sec - Time.at(date).utc.sec).seconds}' and transactions.created_at>='#{Time.at(date).utc.change({ hour: 0, min: 0, sec: 0 }) - 6.days}'").count)
      end
      
      fecha_grafico.zip(data1, data2, data3).each do |f, d, t, g|
             data_table.add_rows([[Time.at(f).to_date, d, t, g]])
       end
       #ajax
      @dato_visitas = data1
      @dato_usuario = data2
      @dato_asistencia = data3

      option = { backgroundColor:'transparent', 
                  width: 1000, height: 340, 
                  title: 'Detalle por Evento',
                  pointSize: 8,
                  pointColor: '#ffffff',
                  curveType: 'function',
                  focusTarget: 'category',
                  explorer: { maxZoomOut:2, keepInBounds: true },
                  crosshair: { trigger: 'focus' }, 
                  colors:['#EAE874','#2FABE9', '#FA5833'],  
                  chartArea: { backgroundColor: 'white', width: '93%', height: '60%'}, 
                  titleTextStyle: {color: 'black', fontSize: 16}, 
                  hAxis:{ textStyle: {color: 'black'}, format:'MMM d' },
                  vAxis:{textStyle: {color: 'black'}}, 
                  legend: { textStyle: {color: 'black', bold: true, fontSize: 16}, alignment: 'center', position: 'bottom'},
                  animation: { duration: 1000,  easing: 'out'}}
      @chart = GoogleVisualr::Interactive::LineChart.new(data_table, option)
      @chart.add_listener("ready", "function(e) {
        $('circle').each(function() {
                  var $c = $(this);              
                  var circles = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                  circles.setAttribute('cx',$c.attr('cx'));
                  circles.setAttribute('cy',$c.attr('cy'));
                  circles.setAttribute('r',$c.attr('r'));
                  circles.setAttribute('fill',$c.attr('fill'));
                  circles.setAttribute('stroke','white');                  
                  circles.setAttribute('stroke-width','1');                  
                  this.parentElement.appendChild(circles);
                                    
                  circles = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                  circles.setAttribute('cx',$c.attr('cx'));
                  circles.setAttribute('cy',$c.attr('cy'));
                  circles.setAttribute('r', '2');
                  circles.setAttribute('fill','white');
                  this.parentElement.appendChild(circles);                          
              })
            }")
      @chart.add_listener("ready", "function(e) {$('.boton').on('click',function(){grafico(e, chart, data_table, this.value);});}")
  end

  def pie_chart(id = 1)

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'tipo')
    data_table.new_column('number', 'cantidad')

    seccions = Section.select("id, name").where(event_id: id)
    data2 = []
    seccions.pluck(:id).each { |e|  data2.push(acum(e)) }

    event_name = Event.find(id).name
    nombres = Section.select("name").where(event_id: id).pluck(:name)
    @cant_sale = data2
    nombres.zip(data2).each do |f, d|
             data_table.add_rows([[f,d]])
    end

    option   = { 
      width: 800, 
      height: 480,
      chartArea:{left:80,
                  width:'80%',
                  height:'90%'}, 
      title: 'Evento'+' '+event_name.to_s, 
      legend: { textStyle: {color: 'black', bold: true, fontSize: 10}, alignment: 'center'},
      pieSliceText: 'percentage',
      tooltip:{ trigger: 'focus', showColorCode: true},
      legend: {position: 'right'},
      pieStartAngle: 100}
   
    @chart_pie = GoogleVisualr::Interactive::PieChart.new(data_table, option)    
  end

  #acumular secciones
  def acum(sect)
    primer_evento= Event.where(producer_id: current_producer.id).first
    fecha_inicio = primer_evento.created_at.to_datetime.to_i
    hora_max = "23:59:59".to_datetime
    acumulado = 0
    (fecha_inicio .. (DateTime.now.to_datetime.to_i + 7.days)).step(7.days) do |date|
      acumulado += Transaction.where("transactions.section_id = #{sect} and transactions.created_at<='#{Time.at(date).utc + (hora_max.hour - Time.at(date).utc.hour).hours + (hora_max.min - Time.at(date).utc.min).minutes + (hora_max.sec - Time.at(date).utc.sec).seconds}' and transactions.created_at>='#{Time.at(date).utc.change({ hour: 0, min: 0, sec: 0 }) - 6.days}'").sum(:quantity)
    end
    return acumulado
  end

  def temp_img
   img = params[:imagen]
   png = Base64.decode64(img['data:image/png;base64,'.length .. -1])
   
    Tempfile.open('prefix', Rails.root.join('tmp') ) do |f|
     File.open(f.path, 'wb') { |f| f.write(png) }
     f.close
     @ruta = f.path
    end
    respond_to do |format|
      format.js 
      format.json {render json:{ruta: @ruta}}
    end
  end

  def column_chart

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Seccion')
    data_table.new_column('number', 'vendidos')
    data_table.new_column('number'  , nil, nil, 'annotation')
    data_table.new_column('number', 'no vendidos')
    data_table.new_column('number'  , nil, nil, 'annotation')
    data_table.add_rows(4)
    data_table.set_cell(0, 0, 'algo')
    data_table.set_cell(0, 1, 1000)
    data_table.set_cell(0, 2, 1000)
    data_table.set_cell(0, 3, 400)
    data_table.set_cell(0, 4, 400)
    opts   = { 
       width: 650, 
       height:380, 
      title: 'Entradas Vendidas por Sector', 
      chartArea: { left:30, top:40, backgroundColor: 'white', width: '80%', height: '90%'},
      legend: {position: 'bottom', alignment: 'center'},
      annotations: {
                    textStyle: {
                      fontName: 'Arvo',
                      fontSize: 18,
                      bold: true,
                      color: '#ffffff',    
                      auraColor: '#635f5f', 
                      opacity: 1          
                              }
                    }
 
       }
    @chart2 = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
    @chart2.add_listener("ready", "function(e) {
      $('.reportepdf').click(function(){
          foto_grafico(e, chart, data_table, this.value);
      });}")
  end

  def log   
  end

  def render_pdf
   report = ThinReports::Report.new 
   report.use_layout File.join(Rails.root, 'app', 'reports', 'google_chart.tlf'), :default => true
   report.use_layout File.join(Rails.root, 'app', 'reports', 'list.tlf'), :id  => :list
     report.start_new_page do |page|
      page.item(:productora).value(current_producer.name)
      page.item(:rut).value(current_producer.rut)
      page.item(:address).value(current_producer.adress)
      page.item(:phone).value(current_producer.phone)
      page.item(:nom).value(@events.name)
      page.item(:ciudad).value(@events.city.name)
      page.item(:dir).value(@events.address)
      page.item(:fecha).value(I18n.l @events.date, format: :long)
      page.item(:tip).value(@events.event_type.name)
      page.item(:image).value(File.open(@directorio)) #solo en windows
    end

    report.layout(:list).config.list(:list) do
      use_stores :total_cantidad => 0,
                 :total_precio => 0
      events.on :footer_insert do |e|
        e.section.item(:total_cant).value(e.store.total_cantidad)
        e.section.item(:total_valor).value(e.store.total_precio)
      end
    end

    report.start_new_page :layout => :list
     sect = Section.select('id, name').where(event_id:@events.id)
     trans = []
     sect.each {|s| trans.push(Transaction.where(section_id: s.id))}
     trans.each do |d|
      d.each do |t|
       report.list(:list).add_row do |row|
         row.item(:num ).value(t.id)
         row.item(:nomu ).value(t.user.first_name)
         row.item(:ape ).value(t.user.last_name)
         row.item(:mail ).value(t.user.email)
         row.item(:section ).value(t.section.name)
         row.item(:date ).value(t.processing_date)
         row.item(:cant ).value(t.quantity)
         row.item(:valor ).value(t.price)
       end # reportes
       report.page.list(:list) do |list|
        list.store.total_cantidad += t.quantity
        list.store.total_precio += t.price
       end
      end#for campos de transactions
     end #for de trans
   send_data report.generate, filename: 'Resumen_'+@events.name+'.pdf',
                                 type: 'application/pdf',
                                 disposition: 'attachment'
   #end
  end

  def account
  end

  def check_username
      if Producer.where(name: params[:producer][:name]).blank?
        respond_to do |format|
          format.json { render json: true }
        end
      else
        respond_to do |format|
          format.json { render json: false }
        end
      end
  end

  def check_run
        if Producer.where(:rut => params[:producer][:rut]).blank?
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
      if Producer.where(:email => params[:producer][:email]).blank?
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
