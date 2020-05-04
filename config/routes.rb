Rails.application.routes.draw do
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'pages#home'

  resources :products, param: :reference, only: [:index, :new, :show, :create] do
    resources :bookings, path: '/:size/bookings', only: [:new, :create, :update]
    get '/:size', to: 'variants#show', as: :size
  end

  get 'toutes-les-chaussures', to: 'products#all_shoes', as: :all_shoes
  get 'tous-les-accessoires', to: 'products#all_accessories', as: :all_accessories
  get 'toutes-les-promotions', to: 'products#all_offers', as: :all_offers

  resources :bookings, only: [:index] do
    get 'confirm', to: 'bookings#confirm', as: :confirm
    get 'cancel', to: 'bookings#cancel', as: :cancel
    get 'pick-up', to: 'bookings#pick_up', as: :pick_up
    get 'back-in-stock', to: 'bookings#back_in_stock', as: :back_in_stock
    get 'undo-last-action', to: 'bookings#undo_last_action', as: :undo_action
  end
  get 'reservations-en-cours', to: 'bookings#current_bookings', as: :current_bookings

  resources :bookers, only: [:index]
end
