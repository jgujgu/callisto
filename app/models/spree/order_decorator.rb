Spree::Order.class_eval do
  def deliver_order_confirmation_email
    Spree::OrderMailer.confirm_email(self).deliver_later
    self.shipments.each do |s|
      Spree::OrderMailer.notify_store_of_shipment(s.id).deliver_later
    end
    update_column(:confirmation_delivered, true)
  end
end
