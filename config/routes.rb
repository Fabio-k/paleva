Rails.application.routes.draw do
  devise_for :admins
  root "home#index"
  resources :restaurants, only: [:new, :create]
  resources :business_hours, only: [:index, :new, :create, :edit, :update]
  resources :dishes, only: [:new, :create, :edit, :update, :show, :destroy]
  resources :beverages, only: [:new, :create, :show, :edit, :update, :destroy]
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

end
