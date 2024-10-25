Rails.application.routes.draw do
  devise_for :admins
  root "home#index"
  resources :restaurants, only: [:new, :create]
  resources :business_hours, only: [:index, :new, :create, :edit, :update]
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

end
