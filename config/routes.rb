Rails.application.routes.draw do
  root 'pages#home'

  get 'products/all_shoes', to: 'products#all_shoes', as: :all_shoes
  get 'products/new', to: 'products#new', as: :new_product
  get 'products/:reference', to: 'products#show', as: :product
  post 'products', to: 'products#create', as: :products

end
