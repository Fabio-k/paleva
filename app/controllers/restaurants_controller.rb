class  RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :authenticate_admin!, only: [:new, :create]
  before_action :redirect_if_admin_has_restaurant, only: [:new, :create]
  layout :determine_layout

  def show
    @restaurant = current_user.restaurant
  end
  def new
    if current_admin.restaurant
      redirect_to dashboard_path
    end
    @restaurant = Restaurant.new
  end

  def create
    restaurant_params = params.require(:restaurant).permit(:brand_name, :corporate_name, :registration_number, :street, :address_number, :city, :state, :phone_number, :email)
    restaurant = Restaurant.new(restaurant_params)
    restaurant.admin = current_admin
    if restaurant.save
      redirect_to business_hours_path
    else
      flash.now[:alert] = 'Erro ao cadstrar Restaurante'
      render 'new'
    end
  end

  private 

  def redirect_if_admin_has_restaurant
    return redirect_to dashboard_path if admin_has_restaurant?
  end

  def admin_has_restaurant?
    current_admin.restaurant.present?
  end

  def determine_layout
    case action_name
    when 'show'
      'application'
    else
      'devise'
    end
  end
end