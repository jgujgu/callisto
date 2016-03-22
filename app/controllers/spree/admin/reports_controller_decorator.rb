Spree::Admin::ReportsController.class_eval do
  before_filter :spree_reports_setup, only: [:index]

  def index
    @reports = Spree::Admin::ReportsController.available_reports
    unless current_spree_user.has_spree_role? "super_admin"
      @reports.delete(:sales_total)
    end
  end

  def orders_by_period
    unless current_spree_user.has_spree_role? "super_admin"
      params[:state] = "complete_paid"
      params[:store] = current_spree_user.store.id.to_s
    end
    @report = SpreeReports::Reports::OrdersByPeriod.new(params)
    respond_to do |format|
      format.html
      format.csv {
        return head :unauthorized unless SpreeReports.csv_export
        send_data @report.to_csv, filename: @report.csv_filename, type: "text/csv"
      }
    end
  end

  def sold_products
    unless current_spree_user.has_spree_role? "super_admin"
      params[:store] = current_spree_user.store.id.to_s
    end
    @report = SpreeReports::Reports::SoldProducts.new(params)
    respond_to do |format|
      format.html
      format.csv {
        return head :unauthorized unless SpreeReports.csv_export
        send_data @report.to_csv, filename: @report.csv_filename, type: "text/csv"
      }
    end
  end

  protected

  def spree_reports_setup
    SpreeReports.reports.each do |report|
      Spree::Admin::ReportsController.add_available_report! report
    end
  end

end
