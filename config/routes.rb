Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/find_all', to: "merchants/search#index"

      resources :merchants, only: [:index, :show] do
        get '/items', to: "merchants/merchant_items#index"
      end

      get '/items/find', to: "items/search#show"

      resources :items do
        get '/merchant', to: "items/item_merchant#show"
      end
    end
  end
end
