Spree::UserRegistrationsController.class_eval do
  def create
    build_resource(spree_user_params)
    if resource.save
        set_flash_message(:notice, :signed_up)
        sign_in(:spree_user, resource)
        session[:spree_user_signup] = true
        associate_user
      if params[:spree_user][:storefront] == "true"
        current_spree_user.role_users.create(role_id: Spree::Role.find_by(name: "admin").id)
        redirect_to new_store_path
      else
        respond_with resource, location: after_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      respond_with(resource) do |format|
        format.html { render :new }
      end
    end
  end
end
