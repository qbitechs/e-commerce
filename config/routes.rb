Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

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

    constraints lambda { |request|
      user = Session.find_by(id: request.cookie_jar.signed[:session_id]).user if request.cookie_jar.signed[:session_id]
      user = User.find_by(id: user)
      !user&.super_admin?
    } do
      resources :products
      resources :orders, only: [ :index ]
      resources :customers, only: [ :index ]
      resource :domain_settings, only: [ :show, :update ]
      resources :meta_tags
    end

    resources :admin_users, only: [ :index ] do
      member do
        post :switch_to
      end
      collection do
        post :switch_back
      end
    end
  end

  root to: "static#index"
end
