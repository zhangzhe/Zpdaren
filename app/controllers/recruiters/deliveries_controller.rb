class Recruiters::DeliveriesController < Recruiters::BaseController
  def index
    @deliveries = Delivery.find_by_recruiter(params, current_recruiter)
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
