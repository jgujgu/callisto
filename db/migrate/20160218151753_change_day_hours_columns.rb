class ChangeDayHoursColumns < ActiveRecord::Migration
  def change
    add_column :spree_day_hours, :day_name, :string
  end
end
