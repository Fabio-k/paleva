class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  #allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_admin
  before_action :redirect_employees
  layout :layout_by_resource
  devise_group :user, contains: [:employee, :admin]

  protected

  def redirect_employees
    if controller_name == "registrations" && action_name == "new" && current_employee
      redirect_to menus_path
    end
  end

  def check_admin
    if admin_signed_in? && !current_admin.restaurant.present? && !on_restaurant_creation_page?
      redirect_to new_restaurant_path, notice: 'Cadastre um restaurante primeiro'
    end
  end

  def on_restaurant_creation_page?
    controller_name == 'restaurants' && %w[new create].include?(action_name)
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cpf, :name, :last_name])
  end

  def after_sign_out_path_for(resource)
    new_admin_session_path
  end

  def after_sign_up_path_for(resource)
    if resource == :admin
      new_restaurant_path
    end
  end

  def after_sign_in_path_for(resource)
    if current_user.restaurant
      menus_path
    else
      new_restaurant_path
    end
  end
end
