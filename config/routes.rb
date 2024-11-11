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
  resources :portions, only: [:edit, :update]
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  get 'search', to: 'dashboard#search', as: 'search_item'
  resources :caracteristics, only: [:new, :create]
  resources :menus, only: [:index, :create, :edit, :update] 
  resources :orders, only: [:create]
  resources :employee_pre_registrations, only: [:index, :create]

end
