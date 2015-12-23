class Recruiters::DeliveriesController < Recruiters::BaseController
  def index
    @job = current_recruiter.jobs.find(params[:job_id]) if params[:job_id]
    @deliveries = Delivery.find_by_recruiter(params, current_recruiter, @job)
    @deliveries = @deliveries.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def show
    @delivery = current_recruiter.deliveries.find(params[:id])
    if @delivery.job.deposit_paid_confirmed?
      flash.now[:info] = "这份简历您曾经支付过，可以直接查看联系方式。" if @delivery.free_read?
      @delivery.read!
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
