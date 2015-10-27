class Admins::DeliveriesController < Admins::BaseController
  helper_method :sort_column

  def index
    if params[:key].present?
      resume_ids = Resume.tagged_with([params[:key]], any: true, wild: true).map(&:id)
      @deliveries = Delivery.includes(:resume).where("resume_id in (?)", resume_ids)
    else
      @deliveries = Delivery.includes(:resume)
    end
    if params[:job_id]
      @deliveries = @deliveries.where("job_id = #{params[:job_id]} OR state = 'recommended'")
    end
    if params[:sort].present?
      @deliveries = @deliveries.order("#{params[:sort]} #{params[:direction]}")
    else
      @deliveries = @deliveries.order_by_state.order("created_at DESC")
    end
    @deliveries = @deliveries.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  private

  def sort_column
    params[:sort] if Delivery.column_names.include?(params[:sort])
  end
end
