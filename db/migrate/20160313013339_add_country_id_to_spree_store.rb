class AddCountryIdToSpreeStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :country_id, :integer, default: 232
  end
end
