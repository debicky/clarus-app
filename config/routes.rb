Rails.application.routes.draw do
  resources :stocks, only: [:index, :show]
  resources :warehouses
  resources :products
end
