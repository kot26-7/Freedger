Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root 'home#index'
  get '/about', to: 'home#about'
  resources :users, except: [:new, :create] do
    resources :containers do
      resources :products, except: [:index]
    end
    resources :products, only: [:index]
    resources :deadline_alerts, only: [:index, :create, :destroy] do
      get 'list', on: :collection
    end
    resources :search_suggests, only: [:index]
  end
  get '/users/:user_id/containers/:container_id/products', to: redirect('/')
end
