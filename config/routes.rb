Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users, except: [:new, :create] do
    resources :containers
  end
end
