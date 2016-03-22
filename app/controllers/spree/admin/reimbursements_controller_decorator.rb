Spree::Admin::ReimbursementsController.class_eval do
  def perform
    @reimbursement.perform!
    unless current_spree_user.has_spree_role? "super_admin"
      @reimbursement.store_id = current_spree_user.store.id
      @reimbursement.save
    end
    redirect_to location_after_save
  end
end
