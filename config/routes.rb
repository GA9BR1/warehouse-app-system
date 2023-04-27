Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get '/', to: 'home#index'
  resources :warehouses, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :stock_product_destinations, only: [:create]
  end
  resources :suppliers, only: [:show, :new, :create, :edit, :update, :index]
  resources :product_models, only: [:show, :index, :new, :create]
  resources :orders, only: [:new, :create, :show, :index, :edit, :update] do
    resources :order_items, only: [:new, :create]
    get 'search', on: :collection
    post 'delivered', on: :member
    post 'canceled', on: :member
  end
end
