class AddStripeUserIdToSpreeStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :stripe_user_id, :string
  end
end
