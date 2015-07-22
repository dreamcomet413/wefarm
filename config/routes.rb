Rails.application.routes.draw do

  get 'sessions/new'

  resources :farmers
  root :to => "welcome#index"
  get 'welcome/index'
  get 'register' => 'farmers#new', :as => :register 
    
end
