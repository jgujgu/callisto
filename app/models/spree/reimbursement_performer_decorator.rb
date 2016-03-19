Spree::ReimbursementPerformer.class_eval do
  private
  def execute(reimbursement, simulate)
    reimbursement_type_hash = calculate_reimbursement_types(reimbursement)

    reimbursement_type_hash.flat_map do |reimbursement_type, return_items|
      reimbursement_type.reimburse(reimbursement, return_items, simulate)
    end
  end
end
