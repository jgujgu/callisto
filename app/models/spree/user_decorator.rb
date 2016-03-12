Spree::User.class_eval do
  belongs_to :store

  geocoded_by :full_street_address

  def full_street_address
    address = self.default_address
    address.address1 + "," +
    address.city + "," +
    address.state.to_s + " " +
    address.zipcode
  end
end
