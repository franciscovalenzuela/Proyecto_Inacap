Evento::Application.routes.draw do
  #Ticket
  get "tickets/index" => 'tickets#index'
  get 'tickets/pdf/:id' => 'tickets#pdf'
  get 'tickets/view_app/:id' => 'tickets#view_app'
  get 'tickets/check_app/:id' => 'tickets#check_app'

  #Eventos
  get 'events/new' => 'events#new'
  post 'events/create' => 'events#create'
  get 'events/index' => 'events#index'
  get 'events/search' => 'events#search'
  get 'events/ingresos/:id' => 'events#ingresos'
  get 'events/siete_dias_app' => 'events#siete_dias_app'
  get 'events/patrocinados_app' => 'events#patrocinados_app'
  get 'events/buscar_app/:ciudad/:tipo' => 'events#buscar_app'
  get 'events/lista_app/:producer' => 'events#lista_app'
  get 'events/view_app/:id' => 'events#view_app'
  get  'events/:id/edit' => 'events#edit'
  get 'events/:id' => 'events#show'
  get 'events/:id/detail/:section' => 'events#detail', :as => :detail

  resources :events

  #Transactions
  get 'response' => 'transactions#result'
  post 'confirmation' => 'transactions#confirmation'
  get 'ticket_free' => 'transactions#ticket_free'
  get 'result_free' => 'transactions#result_free'

  #Sections
  get 'sections/new/:id' => 'sections#new'
  post 'sections/create' => 'sections#create'

  #Pages
  get 'pages/about' => 'pages#about'
  get 'pages/privacy' => 'pages#privacy'
  get 'pages/price' => 'pages#price'

  #Productores
  get 'producers/show/:id' => 'producers#show'
  get 'producers/log' => 'producers#log'
  get 'producers/account/:id' => 'producers#account'
  get 'producers/check_username' => 'producers#check_username'
  get 'producers/check_run' => 'producers#check_run'
  get 'producers/check_email' => 'producers#check_email'
  get 'producers/report/:evt' => 'producers#report'
  post 'producers/temp_img' => 'producers#temp_img'
  get 'producers/report_pdf' => 'producers#report_pdf'
  authenticated :producer do
    root :to => "producers#index", :as => "producer_root"
  end
  devise_for :producers, :skip => [:sessions], :controllers => {:registrations =>"producers/registrations"}
    as :producer do
    get 'producers/log' => 'devise/sessions#new', :as => :new_producer_session
    post 'producers/log' => 'devise/sessions#create', :as => :producer_session
    match 'producers/sign_out' => 'devise/sessions#destroy', :as => :destroy_producer_session,
    :via => Devise.mappings[:producer].sign_out_via
  end
  resources :producers	

  #Usuarios
  authenticated :user do
    root :to => "users#index", :as => "authenticated_root"
  end
  get 'users/check_username' => 'users#check_username'
  get 'users/check_email' => 'users#check_email'
  get 'users/grid' => 'users#grid'
  get 'events/informe/:id' => 'events#informe'
  devise_for :users, :controllers => {:omniauth_callbacks =>"omniauth_callbacks", :registrations => "registrations"}
  resources :users	

  #Ciudades
	get 'cities/geo' => 'cities#geo'

  #Admin
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  #root path
  root :to => "home#index"
end
