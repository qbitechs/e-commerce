Rails.application.routes.draw do
  # Carts:
  resource :cart, only: [ :show ] do
    resources :items, only: [ :create, :update, :destroy ], controller: "cart_items"
    post "checkout", on: :member
  end


  resources :products, only: [ :index, :show ]

  resources :orders, only: [ :index ]

  devise_for :customers, path: "customers", controllers: {
    registrations: "customers/registrations",
    sessions:      "customers/sessions",
    passwords:     "customers/passwords"
  }

  authenticated :customer do
    root to: "products#index", as: :customer_root
  end

  namespace :admin do
    root to: "products#index"

    resource :session
    resources :passwords, param: :token

    resources :products

    resources :orders, only: [ :index ]
  end

  root to: "static#index"
end
