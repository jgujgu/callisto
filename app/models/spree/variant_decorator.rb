Spree::Variant.class_eval do
  after_create :connect_stock_item_with_stock_location

  def connect_stock_item_with_stock_location
    stock_location_id = self.product.stores.first.stock_location.id
    Spree::StockItem.create(
      stock_location_id: stock_location_id,
      variant_id: self.id
    )
  end
end
