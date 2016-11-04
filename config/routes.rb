Rails.application.routes.draw do
  root 'notifications#index'
  resources :notifications, only: [:index, :show, :create, :new]
  resources :webhook, only: [:index] do
    post :click, on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
