class AddStoreIdToSpreeStockLocation < ActiveRecord::Migration
  def change
    add_column :spree_stock_locations, :store_id, :integer
  end
end
