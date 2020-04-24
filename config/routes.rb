Rails.application.routes.draw do
  root to: 'pages#home'

  get 'products/all_shoes', to: 'products#all_shoes', as: :all_shoes

  resources :products, param: :reference, only: [:new, :show, :create] do
    resources :bookings, path: ':variant_id/bookings', only: [:new, :create, :index]
  end
end
