class AddStreetInformation < ActiveRecord::Migration
  def up
    change_table :spree_stores do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
    end
  end

  def down
    change_table :spree_stores do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
    end
  end
end
