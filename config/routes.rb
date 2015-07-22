Rails.application.routes.draw do

  root :to => "welcome#index"
  get 'welcome/index'
    
end
