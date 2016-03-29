class AddStripeCustomerIdToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :stripe_customer_id, :string
  end
end
