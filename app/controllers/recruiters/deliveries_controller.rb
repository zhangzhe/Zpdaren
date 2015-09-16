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
    @delivery.pay! if @delivery.recommended? && @delivery.may_pay?
    redirect_to :back
  end

  def final_pay
    delivery = Delivery.find(params[:id])
    job = delivery.job
    supplier = delivery.resume.supplier
    job.pay_final_payment_to(supplier)
    redirect_to :back
  end
end
