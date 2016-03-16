class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :geocode_user
  before_action :set_current_admin_spree_user_store
  helper_method :time_format

  def time_format
    "%-I:%M %p"
  end

  def set_current_admin_spree_user_store
    if store_owner_signed_in?
      @current_store = current_spree_user.store
    end
  end

  def after_sign_in_path_for(resource)
    if store_owner_signed_in?
      @current_store = current_spree_user.store
      return admin_orders_path
    end
    return root_path
  end

  def store_owner_signed_in?
    admin_path? && current_spree_user && current_spree_user.store
  end

  def admin_path?
    request.original_fullpath.split("/")[1] == "admin"
  end

  def geocode_user
    if current_spree_user && current_spree_user.latitude && current_spree_user.longitude
      @geocoder_result = {
        "latitude" => current_spree_user.latitude,
        "longitude" => current_spree_user.longitude,
        "city" => current_spree_user.default_address.city,
        "region_code" => current_spree_user.default_address.state_name.to_s,
        "zip_code" => current_spree_user.default_address.zipcode
      }
    else
      if Rails.env.development? || Rails.env.test?
        @ip_address = "75.148.122.29"
      else
        @ip_address = request.remote_ip
      end
      begin
        @geocoder_result = Geocoder.search(@ip_address).first.data
      rescue
        @geocoder_result = {
          "latitude" => 39.7393251,
          "longitude" => -104.9869956,
          "city" => "Denver",
          "region_code" => "CO",
          "zip_code" => "80203"
        }
      end
    end
  end
end
