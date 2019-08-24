class TicketsController < ApplicationController 
  
	include ActionView::Base::Goqr
	include ActionView::Helpers::NumberHelper

  def index
		@tickets = Ticket.where(:user_id => current_user.id)
	end

	def pdf
		@ticket = Ticket.find(params[:id])

		respond_to do |format|
      format.pdf { render_pdf }
    end  
	end

	def render_pdf
  	report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'ticket.tlf')

    report.start_new_page do |page|
      page.item(:ticket).value(@ticket.id)
      page.item(:event).value(@ticket.section.event.name)
      page.item(:place).value(@ticket.section.event.place_name)
      page.item(:date).value(I18n.l @ticket.section.event.date, format: :long)
      page.item(:section).value(@ticket.section.name)
      page.item(:price).value(number_to_currency(@ticket.section.price, locale: 'es-CL', precision: 0)) 
      page.item(:qr).value(open_image)
    end

    # Filename = user_id+event_id+ticket_id
    filename_pdf = @ticket.user_id.to_s + 
                   @ticket.section.event.id.to_s +
                   @ticket.id.to_s +
                   ".pdf"

   	send_data report.generate,
   			filename: "ticker.pdf",
      	type: 'application/pdf',
      	disposition: 'attachment'
  end

  def open_image
    img_qr = URI.encode(goqr(data: @ticket.id.to_s, size: '100x100')) 
    open(URI.parse(img_qr))
  end

  def view_app
    ticket_id = params[:id]
    @ticket = Ticket.find(ticket_id)
    response = params[:callback] + '('+ @ticket.to_json(:only => [:id, :state], :include => [:section, :user]) + ')'
    render :text => response
  end

  def check_app
    ticket_id = params[:id]
    @ticket = Ticket.find(ticket_id)
    @ticket.state = true
    @ticket.save!
    response = params[:callback] + '('+ @ticket.to_json(:only => [:id, :state]) + ')'
    render :text => response
  end

end
