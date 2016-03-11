Spree::Admin::UsersController.class_eval do
  def index
    unless current_spree_user.has_spree_role? "super_admin"
      @users = @collection.where(id: current_spree_user.id)
    end
    respond_with(@collection) do |format|
      format.html
    end
  end
end
