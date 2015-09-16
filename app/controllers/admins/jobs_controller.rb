class Admins::JobsController < Admins::BaseController

  def index
    @jobs = Job.all
  end

  def edit
    @job = Job.find(params[:id])
  end

  def show
    @job = Job.find(params[:id])
  end

  def update
    job = Job.find(params[:id])
    job.update_and_approve(job_params)
    redirect_to admins_jobs_path
  end

  def complete
    job = Job.find(params[:id])
    final_payment_request = job.final_payment_request
    supplier = final_payment_request.supplier
    Job.transaction do
      supplier.wallet.update_money(:+, job.bonus_for_entry)
      job.complete!
      job.final_payment_request.pay!
    end
    redirect_to :back
  end

  private
  def job_params
    params.require(:job).permit(:title, :description, :tag_list)
  end
end
