class Admins::DeliveriesController < Admins::BaseController
  helper_method :sort_column

  def index
    if params[:job_id]
      @job = Job.find(params[:job_id])
      @deliveries = @job.deliveries
      @approved_deliveries = @deliveries.after_approved
      @recommended_deliveries = @deliveries.recommended
    else
      @deliveries = Delivery.all
      if params[:state] == "submitted"
        @deliveries = @deliveries.recommended
      elsif params[:state] == "approved"
        @deliveries = @deliveries.after_approved
      end
      @deliveries = @deliveries.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    end
  end

  def edit
    @job = Job.find(params[:job_id])
    @delivery = @job.deliveries.find(params[:id])
  end

  def update
    @job = Job.find(params[:job_id])
    @delivery = @job.deliveries.find(params[:id])
    if @delivery.update_attributes(delivery_params)
      @delivery.approve!
      flash[:success] = "审核完成！"
    end
    redirect_to admins_job_deliveries_path(:job_id => @delivery.job)
  end

  private
  def sort_column
    params[:sort] if Delivery.column_names.include?(params[:sort])
  end

  def delivery_params
    params.require(:delivery).permit(:message)
  end
end
