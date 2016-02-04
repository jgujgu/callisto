class AddDescriptionToStore < ActiveRecord::Migration
  def up
    change_table :spree_stores do |t|
      t.string :description
      t.boolean :showcase
    end
  end

  def down
    change_table :spree_stores do |t|
      t.string :description
      t.boolean :showcase
    end
  end
end
