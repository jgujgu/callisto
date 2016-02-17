class AddDayTypesTable < ActiveRecord::Migration
  def change
    create_table :spree_day_types do |t|
      t.string :name
    end
  end
end
