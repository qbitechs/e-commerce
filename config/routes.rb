Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  constraints(lambda { |req| req.host != "localhost" }) do
    root to: "stores#show", as: :store

    scope module: "store" do
      # Carts:
      resource :cart, only: [ :show ] do
        resources :items, only: [ :create, :update, :destroy ], controller: "cart_items"
        post "checkout", on: :member
      end

      resources :products, only: [ :index, :show ]
      resources :orders, only: [ :index ]

      devise_for :customers, path: "customers", controllers: {
        registrations: "store/customers/registrations",
        sessions:      "store/customers/sessions",
        passwords:     "store/customers/passwords"
      }

      authenticated :customer do
        root to: "products#index", as: :customer_root
      end
    end
  end

  namespace :admin do
    resource :session
    resources :passwords, param: :token

    # Super admin routes
    constraints AdminTypeConstraint.new(super_admin: true) do
      root to: "admin_users#index", as: :super_admin_root
    end

    # Non-super admin routes
    constraints AdminTypeConstraint.new(super_admin: false) do
      root to: "products#index"
      resources :products
      resources :orders, only: [ :index ]
      resources :customers, only: [ :index ]
      resource :domain_settings, only: [ :show, :edit, :update ]
      resource :settings, only: [ :edit, :update ]
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
  get "/pricing", to: "static#pricing"
  get "/about", to: "static#about"
  get "/contract", to: "static#contract"
end
