class Recruiters::DeliveriesController < Recruiters::BaseController
  def index
    @deliveries = []
    if params[:job_id]
      @job = Job.find(params[:job_id])
      @deliveries = @job.deliveries
    else
      jobs = current_recruiter.jobs
      jobs.map do |job|
        @deliveries << job.deliveries unless job.deliveries.blank?
      end
      @deliveries.flatten!
    end
  end

  def show
    @delivery = Delivery.find(params[:id])
    @delivery.read! if @delivery.unread?
  end

  def pay
    @delivery = Delivery.find(params[:id])
    if @delivery.recommended?
      @delivery.pay!
      flash[:success] = "支付成功，您现在可以查看候选人联系方式。"
    else
      flash[:error] = "未知错误，请联系管理员！"
    end
    redirect_to :back
  end
end
