Spree::Admin::OrdersHelper.class_eval do
  def total_shipment_cost(shipment)
    manifest_total = 0
    shipment.manifest.each do |item|
      manifest_total += item.line_item.price * item.quantity
    end
    shipping_price = shipment.pre_tax_amount
    manifest_total + shipping_price
  end
end
