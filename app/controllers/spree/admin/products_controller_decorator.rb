Spree::Admin::ProductsController.class_eval do
  def index
    session[:return_to] = request.url
    unless current_spree_user.has_spree_role? "super_admin"
      store_id = current_spree_user.store.id
      @collection = @collection.joins(:stores).where("spree_stores.id = #{store_id}")
    end
    respond_with(@collection)
  end
end
