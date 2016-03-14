Spree::Admin::UsersController.class_eval do
  def index
    unless current_spree_user.has_spree_role? "super_admin"
      @users = @collection.where(id: current_spree_user.id)
    end
    respond_with(@collection) do |format|
      format.html
    end
  end

  def update
    if user_params[:password].blank?
      result = @user.update_without_password(user_params)
    else
      result = @user.update_attributes(user_params)
    end

    if result
      set_roles
      set_stock_locations
      flash[:success] = Spree.t(:account_updated)
    end

    redirect_to edit_admin_user_url(@user)
  end

  def set_stock_locations
    stock_location_ids = params[:user][:stock_location_ids]
    if stock_location_ids
      @user.stock_locations = Spree::StockLocation.where(id: stock_location_ids)
    end
  end
end
