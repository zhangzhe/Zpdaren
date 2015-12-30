class Admins::DeliveriesController < Admins::BaseController

  def index
    params[:state] = 'recommended' unless current_admin.delivery_state_is_legal?(params[:state])
    if params[:job_id].present?
      @job = Job.find(params[:job_id])
      @deliveries = @job.find_deliveries_by_state(params[:state])
    elsif params[:supplier_id].present?
      @supplier = Supplier.find(params[:supplier_id])
      @deliveries = @supplier.find_deliveries_by_state(params[:state])
    else
      @deliveries = current_admin.find_deliveries_by_state(params[:state])
    end
    @deliveries = @deliveries.joins(:resume).where("resumes.candidate_name like ?", "%#{params[:key]}%").paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def show
    @delivery = Delivery.find(params[:id])
    @job = @delivery.job
  end

  def edit
    @job = Job.find(params[:job_id])
    @company = @job.company
    @delivery = @job.deliveries.find(params[:id])
  end

  def update
    @job = Job.find(params[:job_id])
    @delivery = @job.deliveries.find(params[:id])
    if @delivery.resume.may_improve?
      flash[:error] = "简历信息不完整，先去简历列表完善简历吧。"
      render 'edit' and return
    end
    if @delivery.check(delivery_params)
      flash[:success] = "审核完成。"
    else
      flash[:error] = '程序异常，审核失败。'
    end

    redirect_to admins_job_deliveries_path(:job_id => @delivery.job, :state => 'recommended')
  end

  private
  def delivery_params
    params.require(:delivery).permit(:message, :reason)
  end
end
