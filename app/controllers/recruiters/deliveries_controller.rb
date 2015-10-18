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
      @deliveries.order("created_at DESC").flatten!
    end
  end

  def show
    @delivery = Delivery.find(params[:id])
    if @delivery.unread?
      @delivery.read!
      flash.now[:info] = "这份简历您曾经支付过，可以直接查看联系方式。" if @delivery.paid?
    end
    # @delivery.read! if @delivery.unread?
    # if !@delivery.paid? && @delivery.resume_paid_in_other_delivery?
    #   flash.now[:info] = "这份简历您曾经支付过，可以直接查看联系方式。"
    # end
  end

  def pay
    @delivery = Delivery.find(params[:id])
    if @delivery.approved?
      @delivery.pay!
      flash[:success] = "支付成功，您现在可以查看候选人联系方式。"
    else
      flash[:error] = "未知错误，请联系管理员！"
    end
    redirect_to :back
  end
end
