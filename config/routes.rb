Rails.application.routes.draw do
  resources :games

  get 'welcome/index'

  root 'welcome#index'

end
