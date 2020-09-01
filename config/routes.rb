Rails.application.routes.draw do
  get 'users/show'
  get 'users/edit'
  devise_for :users
  root 'home#index'
  resources :users, except: [:new, :create]
end
