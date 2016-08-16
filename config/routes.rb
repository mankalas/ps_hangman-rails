Rails.application.routes.draw do
  resources :games do
    resources :tries
  end

  get 'welcome/index'

  root 'welcome#index'

end
