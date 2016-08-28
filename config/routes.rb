Rails.application.routes.draw do
  resources :games, only: [:index, :show, :create] do
    resources :tries, only: [:create]
  end

  get 'welcome/index'

  root 'welcome#index'
end
