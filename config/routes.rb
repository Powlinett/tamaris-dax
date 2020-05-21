Rails.application.routes.draw do
  require 'sidekiq/web'

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'pages#home'

  get 'products/recherche', to: 'products#search', as: :products_search
  get 'categories/:sub_category', to: 'products#index_by_sub_category', as: :sub_category
  get 'promotions', to: 'products#all_offers', as: :all_offers
  delete 'products', to: 'products#destroy', as: :products

  resources :products, param: :reference, only: [:index, :new, :show, :create] do
    resources :bookings, path: '/:size/bookings', only: [:new, :create, :update]
    get ':size', to: 'variants#show', as: :size
  end

  get 'bookings/en-cours', to: 'bookings#current_bookings', as: :current_bookings
  get 'bookings/recherche', to: 'bookings#search', as: :bookings_search

  resources :bookings, only: [:index] do
    get 'confirm', to: 'bookings#confirm', as: :confirm
    get 'cancel', to: 'bookings#cancel', as: :cancel
    get 'pick-up', to: 'bookings#pick_up', as: :pick_up
    get 'back-in-stock', to: 'bookings#back_in_stock', as: :back_in_stock
    # get 'undo-last-action', to: 'bookings#undo_last_action', as: :undo_action
  end

  resources :bookers, only: [:index]
  get 'bookers/recherche', to: 'bookers#search', as: :bookers_search

  get ':category', to: 'products#index', as: :category
end
