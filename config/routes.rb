Rails.application.routes.draw do

  resources :farmers
  root :to => "welcome#index"
  get 'welcome/index'
  match 'register' => 'farmers#new', :as => :register 
    
end
