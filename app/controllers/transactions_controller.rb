class TransactionsController < ApplicationController
	include ActionView::Helpers::NumberHelper
	skip_before_filter :verify_authenticity_token, :only => [:confirmation]

	def result
		ticket 						= false
		@referenceCode 		= params[:referenceCode]
		merchant_id 			= params[:merchantId]
		@currency 				= params[:currency]
		transactionState 	= params[:transactionState]
		@firma 						= params[:signature]
		@transactionId 		= params[:transactionId]
		@reference_pol 		= params[:reference_pol]
		@extra1 					= params[:description]
		@lapPaymentMethod = params[:lapPaymentMethod]
		cantidad					= params[:extra1]
		polResponseCode 	= params[:polResponseCode]
		polPaymentMethodType = params[:polPaymentMethodType]
		processingDate 		= params[:processingDate]
		message 					= params[:message]
		merchant_name 		= params[:merchant_name]

		# => datosReferencia
		# => [0] = userId
		# => [1] = sectionId
		# => [2] = producerId
		# => [3] = MD5(time)
		datosReferencia		= @referenceCode.split('/')
		producer 					= Producer.find(datosReferencia[2])
		api_key 					= producer.api_key

		@tx_value 				= params[:TX_VALUE]
		new_value 				= number_with_precision(@tx_value, precision: 1, separator: '.', delimiter: '')	

		firma_cadena 			= api_key+"~"+merchant_id.to_s+"~"+@referenceCode+"~"+new_value.to_s+"~"+@currency+"~"+transactionState.to_s
		@firmacreada 			= Digest::MD5.hexdigest(firma_cadena)
		
		if (params[:transactionState].to_i == 6 && params[:polResponseCode].to_i == 5)
			@estadoTx = "Transacción fallida"
		elsif (params[:transactionState].to_i == 6 && params[:polResponseCode].to_i  == 4)
			@estadoTx = "Transacción rechazada"
		elsif (params[:transactionState].to_i == 12 && params[:polResponseCode].to_i  == 99)
			@estadoTx = "Pendiente, Por favor revisar si el débito fue realizado en el Banco"
		elsif (params[:transactionState].to_i == 4 && params[:polResponseCode].to_i  == 1)
			@estadoTx = "Transacción aprobada"

			transaction = Transaction.new do |t|
				t.reference_code 						= @referenceCode
				t.user_id										= datosReferencia[0].to_i
				t.section_id								= datosReferencia[1].to_i
				t.quantity									=	cantidad
				t.price											= @tx_value
				t.pol_response_code					= polResponseCode
				t.reference_pol							= @reference_pol
				t.pol_payment_method_type		= polPaymentMethodType
				t.processing_date						= processingDate
				t.message										= message
				t.merchant_name							= merchant_name
				t.transaction_id 						= @transactionId
			end

			transaction.save!
			
			section = Section.find(datosReferencia[1].to_i)
			section.stock = section.stock - cantidad.to_i
			section.save!

			ticket = true
		else
			@estadoTx = params[:message]
		end

		if (@firma.upcase == @firmacreada.upcase)
			@estado_firma = true
		else
			@estado_firma = false
		end

		if (ticket == true)
			x = cantidad.to_i

			@counter = 1
			while @counter <= x do
			  ticket = Ticket.new do |t|
					t.section_id 	= datosReferencia[1]
					t.user_id			= datosReferencia[0]
					t.state 			= false
				end
				ticket.save!
				@counter = @counter + 1
			end
		end
	end

	def confirmation

	end

	def ticket_free

		reference_sale 				= params[:referenceCode]
		extra1								= params[:extra1]
		value 								= params[:amount]

		datosReferencia	= reference_sale.split('/')
		userId					=	datosReferencia[0].to_i
		sectionId 			= datosReferencia[1].to_i

		transaction = Transaction.new do |t|
			t.reference_code 						= reference_sale
			t.user_id										= userId
			t.section_id								= sectionId
			t.quantity									=	extra1
			t.price											= value
			t.processing_date						= Date.today
		end
		transaction.save!
		section = Section.find(sectionId)
		section.stock = section.stock - extra1.to_i
		section.save!

		x = extra1.to_i

		@counter = 1
		while @counter <= x do
			ticket = Ticket.new do |t|
				t.section_id 	= datosReferencia[1]
				t.user_id			= datosReferencia[0]
				t.state 			= false
			end
			ticket.save!
			@counter = @counter + 1
		end

    render "result_free"
  end
end