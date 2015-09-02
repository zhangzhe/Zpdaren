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
    current_recruiter.company.jobs.create!(job_params)
    redirect_to recruiters_jobs_path
  end

  private
  def job_params
    params[:job].permit(:title, :description, :bonus)
  end
end
