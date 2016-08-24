Rails.application.routes.draw do
  resources :games, only: [:index, :show, :new, :create] do
    resources :tries, only: [:create]
  end
  resources :players

  get 'welcome/index'

  root 'welcome#index'
end
