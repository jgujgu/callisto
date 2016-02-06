class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_action :geocode_user

  #def geocode_user
    #if Rails.env.development? || Rails.env.test?
      #@ip_address = "75.148.122.29"
    #else
      #@ip_address = request.remote_ip
    #end
    #@geocoder_result = Geocoder.search(@ip_address).first.data
  #end
end
