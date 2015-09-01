class Recruiters::JobsController < ApplicationController
  layout "recruiters"

  def index
    if current_user.company.description.blank?
      redirect_to edit_recruiters_company_path(current_user.company)
    else
      @jobs = current_user.company.jobs
    end
  end

  def new
    @job = current_user.company.jobs.build
  end

  def create
    current_user.company.jobs.create!(job_params)
    redirect_to recruiters_jobs_path
  end

  private
  def job_params
    params[:job].permit(:title, :description, :bonus)
  end
end
