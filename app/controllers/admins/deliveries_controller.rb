class Admins::DeliveriesController < Admins::BaseController
  helper_method :sort_column

  def index
    if params[:key].present?
      resume_ids = Resume.tagged_with([params[:key]], any: true, wild: true).map(&:id)
      @deliveries = Delivery.includes(:resume).where("resume_id in (?)", resume_ids)
    else
      @deliveries = Delivery.includes(:resume)
    end
    @deliveries = @deliveries.order("#{params[:sort]} #{params[:direction]}")
    @deliveries = @deliveries.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  private

  def sort_column
    Delivery.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end