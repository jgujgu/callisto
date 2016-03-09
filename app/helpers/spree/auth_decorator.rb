Spree::Core::ControllerHelpers::Auth.class_eval do
  def set_guest_token
    unless cookies.signed[:guest_token].present?
      cookies.permanent.signed[:guest_token] = {
        value: SecureRandom.urlsafe_base64(nil, false),
        domain: :all,
        tld_length: 2
      }
    end
  end
end
