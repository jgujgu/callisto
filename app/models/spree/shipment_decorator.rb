Spree::Shipment.class_eval do
  def total_cost_with_shipping
    total_item_cost + total_shipping_cost
  end

  def total_shipping_cost
    self.pre_tax_amount + self.adjustment_total
  end

  def total_item_cost
    #start with adjustment total
    manifest_total = 0
    self.manifest.each do |item|
      manifest_total += (item.line_item.price * item.quantity) + item.line_item.adjustment_total
    end
    manifest_total
  end

  def store
    self.stock_location.store
  end

  def total_tax_adjustment

  end
end
