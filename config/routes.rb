Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :products, param: :reference, only: [:index, :new, :show, :create] do
    # resources :bookings, path: 'bookings', only: [:new, :create]
    # get '/:size', param: :size, to: 'variants#show', as: :size
    get '/:size/booking', param: :size, to: 'bookings#new', as: :new_booking
  end

  post 'products/:reference/test', to: 'variants#show', as: :product_variant

  resources :bookings, only: [:index] do
    get 'confirm', to: 'bookings#confirm', as: :confirm
    get 'cancel', to: 'bookings#cancel', as: :cancel
    get 'pick_up', to: 'bookings#pick_up', as: :pick_up
  end
  resources :bookers, only: [:index]
end
