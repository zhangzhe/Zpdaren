class Suppliers::JobsController < ApplicationController
  layout "suppliers"

  def index
    @jobs = Job.all
  end


  # def create
  #   current_recruiter.company.jobs.create!(job_params)
  #   redirect_to recruiters_jobs_path
  # end
  #
  # private
  # def job_params
  #   params[:job].permit(:title, :description, :bonus)
  # end
end
