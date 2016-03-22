SpreeReports::Reports::OrdersByPeriod.class_eval do
  def get_data
    # select by state

    if @state == "complete_paid"
      date_column = :completed_at
      @sales = Spree::Order.complete.where(payment_state: 'paid')
    elsif @state == "complete"
      date_column = :completed_at
      @sales = Spree::Order.complete
    elsif @state == "incomplete"
      date_column = :created_at
      @sales = Spree::Order.incomplete
    elsif @state == "canceled"
      date_column = :canceled_at
      @sales = Spree::Order.where.not(canceled_at: nil)
    else
      date_column = :created_at
      @sales = Spree::Order.where(state: @state)
    end

    if @store == "all"
      @reimbursements = Spree::Reimbursement.where(reimbursement_status: "reimbursed")
    else
      @reimbursements = Spree::Reimbursement.where(store_id: @store, reimbursement_status: "reimbursed")
    end

    @sales = @sales.where("#{date_column.to_s} >= ?", @date_start) if @date_start
    @sales = @sales.where(currency: @currency) if @currencies.size > 1
    @sales = @sales.where(store_id: @store) if @stores.size > 2 && @store != "all"
    @sales = without_excluded_orders(@sales)

    # group by

    if @group_by == :year
      @sales = @sales.group_by_year(date_column, time_zone: SpreeReports.time_zone)
      @reimbursements = @reimbursements.group_by_year(:created_at, time_zone: SpreeReports.time_zone)
    elsif @group_by == :month
      @sales = @sales.group_by_month(date_column, time_zone: SpreeReports.time_zone)
      @reimbursements = @reimbursements.group_by_month(:created_at, time_zone: SpreeReports.time_zone)
    elsif @group_by == :week
      # %W => week start: monday, %U => week start: sunday
      @sales = @sales.group_by_week(date_column, time_zone: SpreeReports.time_zone)
      @reimbursements = @reimbursements.group_by_week(:created_at, time_zone: SpreeReports.time_zone)
    else
      @sales = @sales.group_by_day(date_column, time_zone: SpreeReports.time_zone)
      @reimbursements = @reimbursements.group_by_day(:created_at, time_zone: SpreeReports.time_zone)
    end

    @sales_count = @sales.count
    @sales_total = @sales.sum(:total)
    @sales_item_total = @sales.sum(:item_total)
    @sales_adjustment_total = @sales.sum(:adjustment_total)
    @sales_shipment_total = @sales.sum(:shipment_total)
    @sales_promo_total = @sales.sum(:promo_total)
    @sales_included_tax_total = @sales.sum(:included_tax_total)
    @sales_item_count_total = @sales.sum(:item_count)
    @reimbursement_total = @reimbursements.sum(:total)

  end

  def build_response
    @data = @sales_count.map do |k, v|
      {
        date: k,
        date_formatted: SpreeReports::Helper.date_formatted(k, @group_by),
        count: v,
        total: @sales_total[k].to_f,
        item_total: @sales_item_total[k].to_f,
        avg_total: SpreeReports::Helper.round(SpreeReports::Helper.divide(@sales_total[k].to_f, v)),
        adjustment_total: @sales_adjustment_total[k].to_f,
        shipment_total: @sales_shipment_total[k].to_f,
        promo_total: @sales_promo_total[k].to_f,
        included_tax_total: @sales_included_tax_total[k].to_f,
        item_count_total: @sales_item_count_total[k].to_i,
        items_per_order: SpreeReports::Helper.round(SpreeReports::Helper.divide(@sales_item_count_total[k].to_f, v.to_f)),
        reimbursement_total: @reimbursement_total[k].to_f,
      }
    end
  end
end
