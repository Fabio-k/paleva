class EmployeePreRegistrationsController < ApplicationController
  def index
    @employee_pre_registration = EmployeePreRegistration.new
    @employee_pre_registrations = current_admin.restaurant.employee_pre_registrations
  end

  def create
    employee_pre_registration_params = params.require(:employee_pre_registration).permit(:email, :cpf)
    @employee_pre_registration = EmployeePreRegistration.new(employee_pre_registration_params)
    @employee_pre_registration.restaurant = current_admin.restaurant

    if @employee_pre_registration.save
      redirect_to employee_pre_registrations_path, notice: 'Funcionário cadastrado com sucesso'
    end
  end
end