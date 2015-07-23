Rails.application.routes.draw do

  get 'sessions/new'

  resources :farmers
  root :to => "farmers#index"
  get 'welcome/index'
  get 'register' => 'farmers#new', :as => :register 
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy', :as => :logout
  post '/sessions/create' => 'sessions#create'

  get '/farmers/:action(/:farmer_id)', :controller => 'farmers'
    
end
