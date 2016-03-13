Spree::Store.class_eval do
  has_and_belongs_to_many :products, join_table: 'spree_products_stores'
  has_many :taxonomies
  has_many :orders

  has_many :store_shipping_methods
  has_many :shipping_methods, through: :store_shipping_methods
  has_many :day_hours
  has_many :users
  has_one :stock_location
  after_create :create_stock_location

  belongs_to :country
  belongs_to :state

  def create_stock_location
    Spree::StockLocation.create(
      store_id: self.id,
      name: self.name,
      default: false,
      address1: self.street_address,
      address2: "",
      city: self.city,
      state_id: self.state_id,
      state_name: nil,
      country_id: self.country_id,
      zipcode: self.zipcode,
      phone: self.phone_number,
      active: true,
      backorderable_default: false,
      propagate_all_variants: false,
      admin_name: self.code,
      position: 0,
      restock_inventory: true,
      fulfillable: true,
      code: self.code,
      check_stock_on_transfer: true,
    )
  end

  has_and_belongs_to_many :promotion_rules, class_name: 'Spree::Promotion::Rules::Store', join_table: 'spree_promotion_rules_stores', association_foreign_key: 'promotion_rule_id'

  has_attached_file :logo,
    styles: { mini: '48x48>', small: '100x100>', medium: '240x240>', large: '600x600>' },
    default_style: :medium,
    default_url: 'noimage/:style.png',
    url: '/spree/stores/logo/:id/:style/:basename.:extension',
    path: ':rails_root/public/spree/stores/logo/:id/:style/:basename.:extension',
    convert_options: { all: '-strip -auto-orient' }

  validates_attachment_file_name :logo, matches: [/png\Z/i, /jpe?g\Z/i],
    if: -> { respond_to?(:logo_file_name) }

  has_attached_file :hero,
    styles: { mini: '48x48>', small: '100x100>', medium: '240x240>', large: '600x600>' },
    default_style: :medium,
    default_url: 'noimage/:style.png',
    url: '/spree/stores/hero/:id/:style/:basename.:extension',
    path: ':rails_root/public/spree/stores/hero/:id/:style/:basename.:extension',
    convert_options: { all: '-strip -auto-orient' }

  validates_attachment_file_name :hero, matches: [/png\Z/i, /jpe?g\Z/i],
    if: -> { respond_to?(:hero_file_name) }

  #geocoder methods
  geocoded_by :full_street_address
  after_validation :geocode

  def full_street_address
    self.street_address + "," +
      self.city + "," +
      self.state.name + " " +
      self.zipcode
  end

  scope :showcases, -> {
    where(showcase: true)
  }
end
