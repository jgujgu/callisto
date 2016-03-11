Spree::Admin::StockItemsController.class_eval do
  def variant_scope
    scope = Spree::Variant.accessible_by(current_ability, :read)
    scope = scope.where(product: @product) if @product
    unless current_spree_user.has_spree_role? "super_admin"
      store_id = current_spree_user.store.id
      scope = scope.joins("
    INNER JOIN spree_products_stores ON spree_products_stores.product_id = spree_variants.product_id")
      .where("spree_products_stores.store_id = #{store_id}")
    end
    scope
  end
end
