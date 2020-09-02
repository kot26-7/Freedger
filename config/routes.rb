Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users, except: [:new, :create] do
    resources :containers do
      resources :products, except: [:index]
    end
    resources :products, only: [:index]
  end
  get '/users/:user_id/containers/:container_id/products', to: redirect('/')
end
