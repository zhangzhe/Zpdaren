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

    ActiveRecord::Base.transaction do
      delivery.final_payment = FinalPayment.create!(:amount => delivery.job.bonus_for_entry, :wallet_id => current_recruiter.wallet.id, :zhifubao_account => Admin.admin.zhifubao_account)
      delivery.save!
      delivery.job.pay_final_payment!
    end

    flash.now[:info] = "恭喜您招聘成功，非常感谢您的支持！"
    redirect_to recruiters_jobs_path
    # admin confirm job is done !
  end
end
