Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks,
      controllers: {omniauth_callbacks: "omniauth_callbacks"}

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home", to: "static_pages#home"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/cart/:product_id/add", to: "carts#add", as: "cart_add"
    get "/cart/update", to: "carts#update", as: "cart_update"
    match "search" => "static_pages#search", via: [:get, :post], as: :search
    resources :carts, only: [:index, :destroy]
    devise_for :users, path: "",
      path_names: {sign_in: "login" ,sign_out: "logout",
      sign_up: "resgistration"}, skip: :omniauth_callbacks
    resources :users, only: [:show, :update] do
      member do
        get :change_password
        patch :change_password, to: "users#update_change_password"
      end
    end
    resources :products, only: [:index, :show] do
      member do
        post :rating, to: "products#rating_product"
        delete :destroy_rating, to: "products#destroy_rating"
        get :load_product_by_category, to: "products#load_product_by_category"
      end
    end
    resources :orders, only: [:new, :create]
    namespace :admin do
      get "/", to: "dashboars#index"
      resources :users, except: [:new, :create, :show] do
        collection do
          get :search, to: "users#search"
        end
      end
      resources :categories, except: :show do
        collection do
          get :confirm_before_destroy, to: "categories#confirm_before_destroy"
        end
      end
      resources :products, except: :show do
        collection do
          get :search, to: "products#search"
          get :categories, to: "products#load_categories"
          get :product_types, to: "products#load_products_types"
          get :confirm_before_destroy, to: "products#confirm_before_destroy"
        end
        member do
          delete  :destroy_for_order_waiting,
            to: "products#destroy_for_order_waiting"
        end
      end
      resources :orders, except: [:new, :create] do
        collection do
          get :search, to: "orders#search"
          get :filter_by_status, to: "orders#filter_by_status"
        end
      end
    end
  end
end
