class Admins::DeliveriesController < Admins::BaseController

  def index
    if params[:job_id]
      @job = Job.find(params[:job_id])
      @deliveries = @job.deliveries
      @approved_deliveries = @deliveries.after_approved.order("created_at DESC")
      @recommended_deliveries = @deliveries.recommended.order("created_at DESC")
    else
      @deliveries = Delivery.joins(:job)
      if params[:supplier_id]
        supplier = Supplier.find(params[:supplier_id])
        @deliveries = supplier.deliveries
      end
      if params[:key]
        resume_ids = Resume.where("candidate_name like ?", "%#{params[:key]}%").map(&:id)
        @deliveries = @deliveries.where("resume_id in (?)", resume_ids)
      end
      params[:state] = 'recommended' unless Delivery.state_valid?(params[:state])
      @deliveries = @deliveries.send(params[:state])
      @deliveries = @deliveries.order("created_at DESC").paginate(page: params[:page], per_page: Settings.pagination.page_size)
    end
  end

  def show
    @delivery = Delivery.find(params[:id])
    @job = @delivery.job
  end

  def edit
    @job = Job.find(params[:job_id])
    @delivery = @job.deliveries.find(params[:id])
  end

  def update
    @job = Job.find(params[:job_id])
    @delivery = @job.deliveries.find(params[:id])
    if @delivery.resume.may_improve?
      flash[:error] = "简历信息不完整，先去简历列表完善简历吧！"
      render 'edit' and return
    end
    if @delivery.update_attributes(delivery_params)
      @delivery.approve!
      flash[:success] = "审核完成！"
    end
    redirect_to admins_job_deliveries_path(:job_id => @delivery.job, :state => 'recommended')
  end

  private
  def delivery_params
    params.require(:delivery).permit(:message, :reason)
  end
end
