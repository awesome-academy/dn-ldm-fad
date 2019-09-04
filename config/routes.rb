Rails.application.routes.draw do
  get 'products/index'

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home", to: "static_pages#home"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/register", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/cart", to: "carts#index", as: "cart_index"
    post "/cart/:product_id/add", to: "carts#add", as: "cart_add"

    resources :users, except: [:index, :edit, :destroy] do
      member do
        get :change_password
        patch :change_password, to: "users#update_change_password"
      end
    end
    resources :products, only: :index
  end
end
