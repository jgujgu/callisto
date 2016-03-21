Spree::Admin::ReturnAuthorizationsController.class_eval do
  create.before :set_stock_location_on_return_authorization

  def load_resource
    if member_action?
      @object ||= load_resource_instance
      authorize! action, @object
      instance_variable_set("@#{object_name}", @object)
    else
      @collection ||= collection
      unless current_spree_user.has_spree_role? "super_admin"
        @collection = @collection.where(stock_location_id: current_store.stock_location.id)
      end
      instance_variable_set("@#{controller_name}", @collection)
    end
  end

  private

  def load_return_items
    all_inventory_units = @return_authorization.order.inventory_units
    unless current_spree_user.has_spree_role? "super_admin"
      store_id = current_store.id
      all_inventory_units = all_inventory_units.joins(:variant).joins("
    INNER JOIN spree_products_stores ON spree_products_stores.product_id = spree_variants.product_id")
      .where("spree_products_stores.store_id = #{store_id}")
    end
    associated_inventory_units = @return_authorization.return_items.map(&:inventory_unit)
    unassociated_inventory_units = all_inventory_units - associated_inventory_units

    new_return_items = unassociated_inventory_units.map do |new_unit|
      Spree::ReturnItem.new(inventory_unit: new_unit).tap(&:set_default_pre_tax_amount)
    end
    @form_return_items = (@return_authorization.return_items + new_return_items).sort_by(&:inventory_unit_id)
  end

  def set_stock_location_on_return_authorization
    unless current_spree_user.has_spree_role? "super_admin"
      params[:return_authorization][:stock_location_id] = current_store.stock_location.id
    end
  end
end
