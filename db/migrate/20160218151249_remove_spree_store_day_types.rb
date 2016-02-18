class RemoveSpreeStoreDayTypes < ActiveRecord::Migration
  def change
    drop_table :spree_day_types
  end
end
