Rails.application.routes.draw do

  resources :farmers
  root :to => "welcome#index"
  get 'welcome/index'
  get 'register' => 'farmers#new', :as => :register 
    
end
