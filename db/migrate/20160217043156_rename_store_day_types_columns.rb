class RenameStoreDayTypesColumns < ActiveRecord::Migration
  def change
    rename_column :spree_store_day_types, :spree_store_id, :store_id
    rename_column :spree_store_day_types, :spree_day_type_id, :day_type_id
  end
end
