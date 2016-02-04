class AddDefaultFalseToStoreShowcaseBoolean < ActiveRecord::Migration
  def change
    change_column_default :spree_stores, :showcase, false
  end
end
