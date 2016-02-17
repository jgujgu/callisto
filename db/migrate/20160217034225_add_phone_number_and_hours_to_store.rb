class AddPhoneNumberAndHoursToStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :phone_number, :string, default: "9999999999"
  end
end
