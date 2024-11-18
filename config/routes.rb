Rails.application.routes.draw do
  devise_for :employees
  devise_for :admins

  devise_scope :admin do
    authenticated :admin do
      root :to => "menus#index", as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
  end

  devise_scope :employee do
    authenticated :employee do
      root to: "menus#index", as: :authenticated_employee_root
    end
    unauthenticated :employee do
      root to: 'devise/registrations#new', as: :unauthenticated_employee_root
    end
  end
  
  resources :restaurants, only: [:new, :create, :show]
  resources :business_hours, only: [:index, :new, :create, :edit, :update]
  resources :items do
    patch 'change_status', on: :member
    resources :portions, only: [:new, :create]
  end
  get 'search', to: 'items#search', as: 'search_item'
  resources :portions, only: [:edit, :update]
  resources :caracteristics, only: [:create]
  resources :menus, only: [:index, :create, :edit, :update] 
  resources :orders, only: [:create]
  resources :employee_pre_registrations, only: [:index, :create]

  namespace :api, {format: :json} do
    resources :orders, only: [:index]
    get 'order', to:'orders#show', as: 'order'
    patch 'order/accept', to: "orders#accept", as: 'order_accept'
    patch 'order/ready', to: "orders#ready", as: 'order_ready'
    patch 'order/cancel', to: "orders#cancel", as: 'order_cancel'
  end
end
