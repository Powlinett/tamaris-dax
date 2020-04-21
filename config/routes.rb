Rails.application.routes.draw do
  root 'pages#home'

  get 'products/all_shoes', to: 'products#all_shoes', as: :all_shoes

  resources :products, param: :reference, only: [:new, :show, :create]
  resources :bookings, only: [:new, :create]
end
