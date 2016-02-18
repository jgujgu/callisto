class RemoveDayTypeIdFromDayHour < ActiveRecord::Migration
  def change
    remove_column :spree_day_hours, :day_type_id
  end
end
