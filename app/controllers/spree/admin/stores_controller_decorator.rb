Spree::Admin::StoresController.class_eval do
  def index
    @stores = @stores.ransack({ name_or_domains_or_code_cont: params[:q] }).result if params[:q]
    @stores = @stores.where(id: params[:ids].split(',')) if params[:ids]
    unless current_spree_user.has_spree_role? "super_admin"
      @stores = @stores.where(id: current_store.id)
    end
    respond_with(@stores) do |format|
      format.html
      format.json
    end
  end
end
