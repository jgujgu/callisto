Spree::Core::ControllerHelpers::Order.class_eval do
  def current_order_params
    { currency: current_currency, guest_token: cookies.signed[:guest_token], user_id: try_spree_current_user.try(:id) }
  end
end
