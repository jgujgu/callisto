Spree::Admin::OrdersController.class_eval do
  respond_to :pdf
  helper_method :filter_adjustments

  def show
    load_order
    respond_with(@order) do |format|
      format.pdf do
        template = params[:template] || "invoice"
        if (template == "invoice") && Spree::PrintInvoice::Config.use_sequential_number? && !@order.invoice_number.present?
          @order.invoice_number = Spree::PrintInvoice::Config.increase_invoice_number
          @order.invoice_date = Date.today
          @order.save!
        end
        render :layout => false , :template => "spree/admin/orders/#{template}.pdf.prawn"
      end
    end
  end

  def index
    query_present = params[:q]
    params[:q] ||= {}
    params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
    @show_only_completed = params[:q][:completed_at_not_null] == '1'
    params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
    params[:q][:completed_at_not_null] = '' unless @show_only_completed

    # As date params are deleted if @show_only_completed, store
    # the original date so we can restore them into the params
    # after the search
    created_at_gt = params[:q][:created_at_gt]
    created_at_lt = params[:q][:created_at_lt]

    params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

    if params[:q][:created_at_gt].present?
      params[:q][:created_at_gt] = begin
                                     Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
                                   rescue
                                     ""
                                   end
    end

    if params[:q][:created_at_lt].present?
      params[:q][:created_at_lt] = begin
                                     Time.zone.parse(params[:q][:created_at_lt]).end_of_day
                                   rescue
                                     ""
                                   end
    end

    if @show_only_completed
      params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
      params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
    end

    @search = Spree::Order.accessible_by(current_ability, :index).ransack(params[:q])

    # lazy loading other models here (via includes) may result in an invalid query
    # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
    # see https://github.com/spree/spree/pull/3919
    @orders = if query_present
                @search.result(distinct: true)
              else
                @search.result
              end

    #this block overrides the default functionality
    #ensuring that storefront admins only see orders from their location
    unless current_spree_user.has_spree_role? "super_admin"
      @orders = @orders.joins(:shipments).where("spree_shipments.stock_location_id = #{current_store.stock_location.id}")
    end

    @orders = @orders.
      page(params[:page]).
      per(params[:per_page] || Spree::Config[:orders_per_page])

    # Restore dates
    params[:q][:created_at_gt] = created_at_gt
    params[:q][:created_at_lt] = created_at_lt
  end

  def filter_adjustments(adjustments)
    unless adjustments.empty?
      adjustments = adjustments.select do |a|
        if a.adjustable_type == "Spree::LineItem"

          a.adjustable.variant.product.stores.first.id == current_store.id
        elsif a.adjustable_type ==  "Spree::Shipment"
          a.adjustable.stock_location_id == current_store.stock_location.id
        else
          true
        end
      end
    end
    adjustments
  end
end
