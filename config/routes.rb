Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get 'products/all_shoes', to: 'products#all_shoes', as: :all_shoes

  resources :products, param: :reference, only: [:new, :show, :create] do
    resources :bookings, path: ':variant_id/bookings', only: [:new, :create]
  end
  resources :bookings, only: [:index] do
    get 'confirm', to: 'bookings#confirm', as: :confirm
    get 'cancel', to: 'bookings#cancel', as: :cancel
    get 'pick_up', to: 'bookings#pick_up', as: :pick_up
  end
  resources :bookers, only: [:index]
end
