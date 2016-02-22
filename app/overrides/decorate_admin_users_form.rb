Deface::Override.new(
  virtual_path: "spree/admin/users/_form",
  name: "multi_domain_admin_users_form_stores_dropdown",
  insert_bottom: "[data-hook='admin_user_form_stock_locations']",
  disabled: false,
  partial: "spree/admin/shared/stores_dropdown"
)
