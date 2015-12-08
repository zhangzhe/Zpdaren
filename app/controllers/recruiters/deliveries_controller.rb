class Recruiters::DeliveriesController < Recruiters::BaseController
  def index
    params[:state] = 'approved' if params[:state].blank?
    if params[:job_id]
      @job = current_recruiter.jobs.find(params[:job_id])
      if params[:state] == 'approved'
        @deliveries = @job.unprocess_deliveries
      elsif params[:state] == 'viewed'
        @deliveries = @job.viewed_deliveries
      elsif params[:state] == 'final_paid'
        @deliveries = @job.deliveries.final_paid
      else
        @deliveries = @job.deliveries.refused
      end
      @deliveries = @deliveries.order("created_at DESC")
    else
      if params[:state] == 'approved'
        @deliveries = current_recruiter.unprocess_deliveries
      elsif params[:state] == 'viewed'
        @deliveries = current_recruiter.viewed_deliveries
      elsif params[:state] == 'final_paid'
        @deliveries = current_recruiter.final_paid_deliveries
      else
        @deliveries = current_recruiter.refused_deliveries
      end
      @jobs = current_recruiter.jobs
      @jobs = @jobs.where("title like ?", "%#{params[:key]}%") if params[:key].present?
      job_ids = @jobs.map(&:id)
      @deliveries = @deliveries.includes(:job).where("job_id in (?)", job_ids).order("created_at DESC")
    end
    @deliveries = @deliveries.order("created_at DESC")
    @deliveries = @deliveries.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def show
    @delivery = current_recruiter.deliveries.find(params[:id])
    if @delivery.job.deposit_paid_confirmed?
      if @delivery.unread?
        @delivery.read!
        flash.now[:info] = "这份简历您曾经支付过，可以直接查看联系方式。" if @delivery.ever_paid_or_final_payment_paid_or_finished?
      end
    end
  end

  def pay
    delivery = current_recruiter.deliveries.find(params[:id])
    if delivery.approved?
      delivery.pay!
      flash[:success] = "支付成功，您现在可以查看候选人联系方式。"
    else
      flash[:error] = "未知错误，请联系管理员！"
    end
    redirect_to :back
  end
end
