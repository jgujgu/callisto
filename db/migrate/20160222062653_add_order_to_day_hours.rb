class AddOrderToDayHours < ActiveRecord::Migration
  def change
    add_column :spree_day_hours, :order, :integer, default: 1
  end
end
