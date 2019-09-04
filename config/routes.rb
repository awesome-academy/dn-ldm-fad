Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home", to: "static_pages#home"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/register", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    post "/cart/:product_id/add", to: "carts#add", as: "cart_add"
    get "/cart/update", to: "carts#update", as: "cart_update"
    get "/search", to: "static_pages#search"
    resources :carts, only: [:index, :destroy]
    resources :users, except: [:index, :edit, :destroy] do
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
      resources :categories, except: :show
      resources :products, except: :show do
        collection do
          get :search, to: "products#search"
          get :categories, to: "products#load_categories"
          get :product_types, to: "products#load_products_types"
        end
      end
      resources :orders, except: [:new, :create, :destroy] do
        collection do
          get :search, to: "orders#search"
          get :filter_by_status, to: "orders#filter_by_status"
        end
      end
    end
  end
end
