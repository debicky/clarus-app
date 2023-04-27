# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :stocks
  resources :warehouses
  resources :products
  resources :orders, only: [:create] do
    resources :dispatches, only: [:create]
  end
  resources :stock_balances, only: :show
end
