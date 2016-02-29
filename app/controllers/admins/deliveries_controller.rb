class Admins::DeliveriesController < Admins::BaseController

  def index
    params[:state] = 'recommended' unless current_admin.delivery_state_is_legal?(params[:state])
    if params[:job_id].present?
      @job = Job.find(params[:job_id])
      @q = @job.find_deliveries_by_state(params[:state]).ransack(params[:q])
    elsif params[:supplier_id].present?
      @supplier = Supplier.find(params[:supplier_id])
      @q = @supplier.find_deliveries_by_state(params[:state]).ransack(params[:q])
    else
      @q = current_admin.find_deliveries_by_state(params[:state]).ransack(params[:q])
    end
    @deliveries = @q.result(distinct: true)
    @deliveries = @deliveries.joins(:resume, :job, :supplier, :company).paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def show
    @delivery = Delivery.find(params[:id])
    @job = @delivery.job
  end

  def create
    @resume = Resume.find(create_delivery_params[:resume_id])
    job = Job.find(create_delivery_params[:job_id])
    @delivery = Delivery.new(create_delivery_params)
    if @resume.may_delivery?(job)
      @delivery.state = 'approved'
      if @delivery.save
        @delivery.notify_recruiter
        redirect_to matched_jobs_admins_resume_path(id: create_delivery_params[:resume_id]), notice: '推荐成功。'
      else
        redirect_to matched_jobs_admins_resume_path(id: create_delivery_params[:resume_id]), error: '程序异常，推荐失败。'
      end
    else
      redirect_to matched_jobs_admins_resume_path(id: create_delivery_params[:resume_id]), notice: '不能推荐该简历。'
    end
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
      flash.now[:error] = "简历信息不完整，先去简历列表完善简历吧。"
      render 'edit' and return
    end
    if @delivery.check(update_delivery_params)
      flash[:success] = "审核完成。"
    else
      flash[:error] = '程序异常，审核失败。'
    end
    redirect_to admins_job_deliveries_path(:job_id => @delivery.job, :state => 'recommended')
  end

  private
  def update_delivery_params
    params.require(:delivery).permit(:message, :reason)
  end

  def create_delivery_params
    params.require(:delivery).permit(:resume_id, :job_id)
  end
end
