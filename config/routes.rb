Rails.application.routes.draw do
  resources :orders
  resources :products
  devise_for :users

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  resources :products
  root to: "static#index"
end
