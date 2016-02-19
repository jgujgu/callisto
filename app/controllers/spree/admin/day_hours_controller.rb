class Spree::Admin::DayHoursController < Spree::Admin::ResourceController
  def index
    @day_hours = current_store.day_hours.all
  end

  def new
    @day_hour = current_store.day_hours.create
  end

  def show
    @day_hour = current_store.day_hours.find(params[:id])
  end

  def update
    permitted_resource_params[:closing_time] = DateTime.parse(permitted_resource_params[:closing_time])
    permitted_resource_params[:opening_time] = DateTime.parse(permitted_resource_params[:opening_time])
    @day_hour = current_store.day_hours.update(params[:id], permitted_resource_params)
    redirect_to admin_day_hours_path
  end
  def destroy

  end
end
