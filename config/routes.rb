Rails.application.routes.draw do
  root to: "products#index"

  resources :products, only: [ :index, :show ]

  resources :orders, only: [ :index, :show ]

  devise_for :users, path: "customer", controllers: {
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
