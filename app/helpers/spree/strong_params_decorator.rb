Spree::Core::ControllerHelpers::StrongParameters.class_eval do
  def permitted_user_attributes
    permitted_attributes.user_attributes + [
      bill_address_attributes: permitted_address_attributes,
      ship_address_attributes: permitted_address_attributes
    ] + [:store_id]
  end

  def permitted_payment_attributes
    permitted_attributes.payment_attributes + [
      source_attributes: permitted_source_attributes
    ] + [:stripe_token]
  end
end
