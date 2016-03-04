class Spree::Gateway::StripeCheckout < Spree::Gateway
  def provider_class
    Spree::Gateway::StripeCheckout
  end

  def payment_source_class
    Spree::CreditCard
  end

  def method_type
    'stripe_checkout'
  end

  def purchase(amount, transaction_details, options = {})
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    token = transaction_details[:gateway_payment_profile_id]
    metadata = {
      :order_id => options[:order_id],
      :customer => options[:customer],
      :subtotal => Money.new(options[:subtotal]).to_s,
      :shipping => Money.new(options[:shipping]).to_s,
      :tax => Money.new(options[:tax]).to_s,
      :discount => Money.new(options[:discount]).to_s,
      :currency => "USD",
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
    rescue Stripe::CardError => e
      # The card has been declined
    end

    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end

  def auto_capture?
    true
  end
end
