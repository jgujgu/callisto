Spree::Admin::ProductsController.class_eval do
  create.before :set_store_on_product
  update.before :set_store_on_product

  def index
    session[:return_to] = request.url
    unless current_spree_user.has_spree_role? "super_admin"
      store_id = current_store.id
      @collection = @collection.joins(:stores).where("spree_stores.id = #{store_id}")
    end
    respond_with(@collection)
  end

  def set_store_on_product
    unless current_spree_user.has_spree_role? "super_admin"
      params[:product][:store_ids] = [current_store.id]
    end
  end
end
