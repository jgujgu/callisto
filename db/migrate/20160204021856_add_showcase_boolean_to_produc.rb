class AddShowcaseBooleanToProduc < ActiveRecord::Migration
  def change
    add_column :spree_products, :showcase, :boolean, default: false
  end
end
