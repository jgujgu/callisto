class Spree::Admin::DayHoursController < Spree::Admin::ResourceController
  helper_method :time_format

  def index
    @day_hours = current_store.day_hours.all.order(:order)
  end

  def new
    @day_hour = current_store.day_hours.create
  end

  def show
    @day_hour = current_store.day_hours.find(params[:id])
  end

  def update
    begin
      permitted_resource_params[:closing_time] = DateTime.parse(permitted_resource_params[:closing_time])
      permitted_resource_params[:opening_time] = DateTime.parse(permitted_resource_params[:opening_time])
      permitted_resource_params[:order] = permitted_resource_params[:order].to_i
    rescue
      permitted_resource_params[:closing_time] = DateTime.now
      permitted_resource_params[:opening_time] = DateTime.now
      permitted_resource_params[:order] = permitted_resource_params[:order].to_i
    end
    @day_hour = current_store.day_hours.update(params[:id], permitted_resource_params)
    redirect_to admin_day_hours_path
  end

  def time_format
    "%I:%M %p"
  end
end
