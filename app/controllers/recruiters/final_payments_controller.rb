class Recruiters::FinalPaymentsController < Recruiters::BaseController
  def index
    flash.now[:info] = "请选择一份简历作为支付目标"
    @job = Job.find(params[:job_id])
    @deliveries = @job.deliveries
  end

  def new
    @delivery = Delivery.find(params[:delivery_id])
    @job = @delivery.job
  end

  def create
    delivery = Delivery.find(params[:delivery_id])
    current_recruiter.create_and_pay_final_payment_for!(delivery)
    flash[:info] = "恭喜您招聘成功，非常感谢您的支持！"
    redirect_to recruiters_jobs_path
  end
end
