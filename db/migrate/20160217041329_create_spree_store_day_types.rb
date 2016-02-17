class CreateSpreeStoreDayTypes < ActiveRecord::Migration
  def change
    create_table :spree_store_day_types do |t|
      t.integer :spree_store_id
      t.integer :spree_day_type_id
      t.time :opening_time, default: Time.now
      t.time :closing_time, default: Time.now
    end
  end
end
