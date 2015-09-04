class Recruiters::JobsController < ApplicationController
  layout "recruiters"

  def index
    if current_recruiter.company.description.blank?
      redirect_to edit_recruiters_company_path(current_recruiter.company)
    else
      @jobs = current_recruiter.company.jobs
    end
  end

  def new
    @job = current_recruiter.company.jobs.build
  end

  def create
    job = current_recruiter.company.jobs.create!(job_params)
    redirect_to deposit_pay_new_recruiters_job_path(job)
  end

  def deposit_pay_new
    @job = Job.find(params[:id])
  end

  def deposit_pay
    job = Job.update(params[:job][:id], deposit_pay_params)
    admin = Admin.first
    admin.receive(job.deposit)
    job.publish
    job.save!
    redirect_to recruiters_jobs_path
  end

  def complete
    @job = Job.find(params[:id])
    @job.complete!
    redirect_to :back
  end

  private
  def job_params
    params[:job].permit(:title, :description, :bonus, :state)
  end

  def deposit_pay_params
    params[:job].permit(:deposit)
  end
end
