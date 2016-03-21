Spree::Admin::CustomerReturnsController.class_eval do
  def create
    invoke_callbacks(:create, :before)

    if current_spree_user.has_spree_role? "super_admin"
      @object.attributes = permitted_resource_params
    else
      @object.attributes = permitted_resource_params.merge(stock_location_id: current_store.stock_location.id)
    end

    if @object.save
      invoke_callbacks(:create, :after)
      flash[:success] = flash_message_for(@object, :successfully_created)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_save }
        format.js   { render :layout => false }
      end
    else
      invoke_callbacks(:create, :fails)
      respond_with(@object) do |format|
        format.html do
          flash.now[:error] = @object.errors.full_messages.join(", ")
          render_after_create_error
        end
        format.js { render layout: false }
      end
    end
  end

  private

  def load_form_data
    return_items = @order.inventory_units
    unless current_spree_user.has_spree_role? "super_admin"
      store_id = current_store.id
      return_items = return_items.joins(:variant).joins("
    INNER JOIN spree_products_stores ON spree_products_stores.product_id = spree_variants.product_id")
      .where("spree_products_stores.store_id = #{store_id}")
    end
    return_items = return_items.map(&:current_or_new_return_item).reject(&:customer_return_id)
    @rma_return_items, @new_return_items = return_items.partition(&:return_authorization_id)
    load_return_reasons
  end

  def collection
    parent # trigger loading the order
    @collection ||= Spree::ReturnItem
      .accessible_by(current_ability, :read)
      .where(inventory_unit_id: @order.inventory_units.pluck(:id))
      .map(&:customer_return).uniq.compact
    unless current_spree_user.has_spree_role? "super_admin"
      @collection = @collection.select {|sl| sl.stock_location_id == current_store.stock_location.id }
    end
    @customer_returns = @collection
  end
end
