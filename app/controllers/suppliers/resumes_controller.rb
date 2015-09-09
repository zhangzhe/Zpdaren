class Suppliers::ResumesController < ApplicationController
  layout "suppliers"

  def index
    @resumes = current_supplier.resumes
  end

  def create
    job = Job.find(params[:job_id])
    resume = Resume.create!(resume_params)
    current_supplier.resumes << resume
    job.delivery!(resume)
    redirect_to :back
  end

  private

  def resume_params
    params[:resume].permit(:candidate_name, :tag_list, :attachment)
  end
end
