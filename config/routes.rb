Rails.application.routes.draw do
  resources :games
  resources :tries

  get 'welcome/index'

  root 'welcome#index'

end
