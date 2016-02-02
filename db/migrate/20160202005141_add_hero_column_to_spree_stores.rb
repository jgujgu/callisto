class AddHeroColumnToSpreeStores < ActiveRecord::Migration
  def up
    change_table :spree_stores do |t|
      t.string :hero_file_name
    end
  end

  def down
    change_table :spree_stores do |t|
      t.remove :hero_file_name
    end
  end
end
