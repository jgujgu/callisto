class AddLatitudeAndLongitudeToStore < ActiveRecord::Migration
  def up
    change_table :spree_stores do |t|
      t.float :latitude
      t.float :longitude
    end
  end

  def down
    change_table :spree_stores do |t|
      t.float :latitude
      t.float :longitude
    end
  end
end
