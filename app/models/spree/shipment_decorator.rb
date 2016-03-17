Spree::Shipment.class_eval do
  def total_cost_with_shipping
    shipping_price = self.pre_tax_amount
    total_item_cost + shipping_price
  end

  def total_item_cost
    manifest_total = 0
    self.manifest.each do |item|
      manifest_total += item.line_item.price * item.quantity
    end
    manifest_total
  end

  def store
    self.stock_location.store
  end
end
