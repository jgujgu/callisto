class AddStoreIdToSpreeReimbursement < ActiveRecord::Migration
  def change
    add_column :spree_reimbursements, :store_id, :integer
  end
end
