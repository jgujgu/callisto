class RenameStoreDayTypes < ActiveRecord::Migration
  def change
    rename_table :spree_store_day_types, :spree_day_hours
  end
end
