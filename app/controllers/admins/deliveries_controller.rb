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
      @deliveries = @deliveries.where("job_id = #{params[:job_id]} AND state = 'recommended'")
    end
    if params[:sort].present?
      @deliveries = @deliveries.order("#{params[:sort]} #{params[:direction]}")
    else
      @deliveries = @deliveries.order_by_state.order("created_at DESC")
    end
    @deliveries = @deliveries.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def edit
    @delivery = Delivery.find(params[:id])
  end

  def update
    @delivery = Delivery.find(params[:id])
    if @delivery.update_attributes(delivery_params)
      @delivery.approve!
    end
    redirect_to admins_deliveries_path(:job_id => @delivery.job)
  end

  private
  def sort_column
    params[:sort] if Delivery.column_names.include?(params[:sort])
  end

  def delivery_params
    params.require(:delivery).permit(:message)
  end
end
