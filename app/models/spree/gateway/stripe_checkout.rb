class Spree::Gateway::StripeCheckout < Spree::Gateway

  FLEA_FEE_PERCENT = 0.02

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
    stock_location = originator.reimbursement.customer_return.stock_location
    stock_location_id = stock_location.id
    stripe_user_id = stock_location.store.stripe_user_id
    stripe_charge_id = originator.payment.order.shipments.find_by(stock_location_id: stock_location_id).stripe_charge_id
    metadata = { refund_reason: Spree::RefundReason.find_by(id: originator.refund_reason_id).name }
    begin
      charge = Stripe::Charge.retrieve(stripe_charge_id, :stripe_account => stripe_user_id)
      re = charge.refunds.create(
        amount: money,
        metadata: metadata,
        refund_application_fee: true
      )
      stripe_refund_id = re.id
      store_email = stock_location.store.user.email
      Spree::RefundMailer.notify_store(store_email, money, stripe_refund_id).deliver_later
      ActiveMerchant::Billing::Response.new(true, 'success', { stripe_refund_id: stripe_refund_id }, {})
    rescue Stripe::InvalidRequestError => e
      ActiveMerchant::Billing::Response.new(false, 'There was a problem processing this refund.', {}, {})
    end
  end

  def purchase(amount, transaction_details, options = {})
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    profile_id = transaction_details[:gateway_payment_profile_id]
    user_id = transaction_details.user_id

    order = Spree::Order.find_by_number(options[:order_id].split("-")[0])

    user = Spree::User.find_by(id: user_id)
    if user && profile_id == user.stripe_customer_id #customer payment info unchanged
      customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      geocode_purchasing_user(user_id)
    elsif user && user.stripe_customer_id #customer has existing info, changed
      customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      geocode_purchasing_user(user_id)
      customer.source = profile_id
      customer.save
    elsif user #customer has no payment info
      customer = Stripe::Customer.create(
        :description => "Flea user",
        :email => user.email,
        :source => profile_id
      )
      user.stripe_customer_id = customer.id
      user.save
    else #guest customer
      customer = Stripe::Customer.create(
        :description => "Flea guest user",
        :source => profile_id
      )
    end

    result = nil
    order.shipments.each do |s|
      result = charge_shipment(s, customer, options)
    end
    result
  end

  def charge_shipment(shipment, customer, options)
    store = shipment.stock_location.store
    total_cost = (shipment.total_cost_with_shipping * 100).to_i
    flea_fee = (FLEA_FEE_PERCENT * total_cost).to_i
    connected_stripe_user_id = store.stripe_user_id
    Stripe.api_key = ENV["STRIPE_PUBLISHABLE_KEY"]
    store_token = Stripe::Token.create(
      {:customer => customer.id},
      {:stripe_account => connected_stripe_user_id} # id of the connected account
    )
    metadata = {
      :order_id => options[:order_id],
      :customer => options[:customer],
      :currency => "USD",
      :total_item_cost_with_tax => shipment.total_item_cost,
      :shipping_cost_with_tax => shipment.total_shipping_cost
    }
    begin
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      charge = Stripe::Charge.create({
        :amount => total_cost,
        :currency => "usd",
        :source => store_token,
        :description => "Flea Order ##{options[:order_id]} from #{store.name}",
        :application_fee => flea_fee,
        :receipt_email => options[:email],
        :metadata => metadata,
      }, {:stripe_account => connected_stripe_user_id})
      shipment.stripe_charge_id = charge.id
      shipment.save
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
