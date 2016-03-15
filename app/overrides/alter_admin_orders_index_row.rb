Deface::Override.new(
  :virtual_path => "spree/admin/orders/index",
  :name => "admin_orders_index_row",
  :replace => "[data-hook='admin_orders_index_rows']",
  :partial => "spree/admin/orders/orders_index_row",
  :disabled => false)
