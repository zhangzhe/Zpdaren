class Recruiters::DepositsController < Recruiters::BaseController
  def new
    @job = current_recruiter.jobs.submitted.find(params[:job_id])
  end

  def create
    ActiveRecord::Base.transaction do
      job = current_recruiter.jobs.find(params[:job][:id])
      job.update_attributes(deposit_params)
      admin = Admin.admin
      admin.receive(job.deposit)
      job.pay!
      Deposit.create(:amount => job.deposit, :wallet_id => current_recruiter.wallet.id, :zhifubao_account => admin.bank_account, :job_id => job.id)
    end
    redirect_to recruiters_jobs_path
  end

  private
  def deposit_params
    params[:job].permit(:deposit)
  end
end
