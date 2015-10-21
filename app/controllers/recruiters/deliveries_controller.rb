class Recruiters::DeliveriesController < Recruiters::BaseController
  def index
    @deliveries = []
    if params[:job_id]
      @job = Job.find(params[:job_id])
      @deliveries = @job.deliveries.order("created_at DESC")
    else
      job_ids = current_recruiter.jobs.map(&:id)
      @deliveries = Delivery.includes(:job).where("job_id in (?)", job_ids).order("created_at DESC")
    end
  end

  def show
    @delivery = Delivery.find(params[:id])
    if @delivery.unread?
      @delivery.read!
      flash.now[:info] = "这份简历您曾经支付过，可以直接查看联系方式。" if @delivery.ever_paid_or_final_payment_paid_or_finished?
    end
  end

  def pay
    delivery = Delivery.find(params[:id])
    if delivery.approved?
      delivery.pay!
      flash[:success] = "支付成功，您现在可以查看候选人联系方式。"
    else
      flash[:error] = "未知错误，请联系管理员！"
    end
    redirect_to :back
  end
end
