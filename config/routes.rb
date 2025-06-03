Rails.application.routes.draw do
  root to: "products#index"

  # Carts:
  resource :cart, only: [ :show ] do
    resources :cart_items, only: [ :create, :update, :destroy ]
    post "checkout", on: :member
  end


  resources :products, only: [ :index, :show ]

  resources :orders, only: [ :index, :show ]

  devise_for :users, path: "user", controllers: {
    registrations: "users/registrations",
    sessions:      "users/sessions",
    passwords:     "users/passwords"
  }

  namespace :admin do
    root to: "dashboard#index"

    resources :products

    resources :orders, only: [ :index, :show, :update ]
  end
end
