class BusinessHoursController < ApplicationController
  before_action :authenticate_admin!
  layout 'devise'
  def index
    @business_hour = BusinessHour.new
    @current_schedule = current_admin.restaurant.business_hours
  end
  def new
    
  end

  def create
    business_hour_params = params.require(:business_hour).permit(:opening_hour, :closing_hour, :day_of_week)
    business_hour = current_admin.restaurant.business_hours.build(business_hour_params)
    business_hour.save
    redirect_to business_hours_path
  end
end