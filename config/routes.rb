Rails.application.routes.draw do
  devise_for :admins

  devise_scope :admin do
    authenticated :admin do
      root :to => 'dashboard#index', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
  end
  
  resources :restaurants, only: [:new, :create]
  resources :business_hours, only: [:index, :new, :create, :edit, :update]
  resources :dishes, only: [:new, :create, :edit, :update, :show, :destroy]
  resources :beverages, only: [:new, :create, :show, :edit, :update, :destroy] 
  resources :itens do
    patch 'change_status', on: :member
    resources :portions, only: [:new, :create]
  end
  resources :portions, only: [:edit, :update]
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  get 'search', to: 'dashboard#search', as: 'search_item'

end
