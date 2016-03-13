class AddStateIdToSpreeStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :state_id, :integer, default: 3530
  end
end
