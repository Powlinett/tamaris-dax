Rails.application.routes.draw do
  root 'pages#home'

  get 'products/all_shoes', to: 'products#all_shoes', as: :all_shoes

  resources :bookings, only: [:new, :create, :index]
  resources :products, param: :reference, only: [:new, :show, :create]
end
