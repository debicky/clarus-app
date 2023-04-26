# frozen_string_literal: true

Rails.application.routes.draw do
  resources :stocks
  resources :warehouses
  resources :products
  resources :orders, only: [:create] do
    resources :dispatches, only: [:create]
  end
end
