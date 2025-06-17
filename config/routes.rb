Rails.application.routes.draw do
  root to: "products#index"

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

  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    # get "dashboard", to: "dashboard#index"

    resources :products

    resources :orders, only: [ :index ]
  end
end
