Spree::OrderMailer.class_eval do
  def notify_store_of_shipment(id)
    @shipment = Spree::Shipment.find_by(id: id)
    @order = @shipment.order
    store = @shipment.store
    subject = "Your shop has a pending order on Flea."
    mail(to: store.user.email, from: ENV["EMAIL"], subject: subject)
  end
end
