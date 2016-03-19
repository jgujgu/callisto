class Spree::Gateway::StripeCheckout < Spree::Gateway
  attr_accessor :server, :test_mode

  def provider_class
    Spree::Gateway::StripeCheckout
  end

  def payment_source_class
    Spree::CreditCard
  end

  def method_type
    'stripe_checkout'
  end

  def credit(money, creditcard, response_code)
    provider.refund(money, response_code, {})
  end

  def refund(money, response_code, options)
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    originator = response_code[:originator]
    stripe_charge_id = originator.payment.response_code
    metadata = { refund_reason: Spree::RefundReason.find_by(id: originator.refund_reason_id).name }
    begin
      re = Stripe::Refund.create(
        charge: stripe_charge_id,
        amount: money,
        metadata: metadata
      )
      stripe_refund_id = re.id
      store_email = originator.reimbursement.customer_return.stock_location.store.user.email
      Spree::RefundMailer.notify_store(store_email, money, stripe_refund_id).deliver_later
      ActiveMerchant::Billing::Response.new(true, 'success', { stripe_refund_id: stripe_refund_id }, {})
    rescue Stripe::InvalidRequestError => e
      ActiveMerchant::Billing::Response.new(false, 'There was a problem processing this refund.', {}, {})
    end
  end

  def purchase(amount, transaction_details, options = {})
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    token = transaction_details[:gateway_payment_profile_id]
    user_id = transaction_details.user_id
    geocode_purchasing_user(user_id) if user_id
    metadata = {
      :order_id => options[:order_id],
      :customer => options[:customer],
      :subtotal => Money.new(options[:subtotal]).to_s,
      :shipping => Money.new(options[:shipping]).to_s,
      :tax => Money.new(options[:tax]).to_s,
      :discount => Money.new(options[:discount]).to_s,
      :currency => "USD",
      :user_id => user_id
    }
    begin
      charge = Stripe::Charge.create(
        :amount => amount, # amount in cents, again
        :currency => "usd",
        :source => token,
        :description => "Flea Order ##{options[:order_id]}",
        :receipt_email => options[:email],
        :metadata => metadata
      )
      ActiveMerchant::Billing::Response.new(true, 'success', { stripe_charge_id: charge.id }, {})
    rescue Stripe::CardError => e
      ActiveMerchant::Billing::Response.new(false, 'This card has been declined.', {}, {})
    end
  end

  def email_customer_and_store(customer_email, store_email, amount)
    Spree::RefundMailer.notify_customer(customer_email, amount).deliver_later
    Spree::RefundMailer.notify_store(store_email, amount).deliver_later
  end

  def auto_capture?
    true
  end

  def geocode_purchasing_user(user_id)
    latitude, longitude = Spree::User.find_by(id: user_id).geocode
    Spree::User.update(user_id, latitude: latitude, longitude: longitude)
  end
end
