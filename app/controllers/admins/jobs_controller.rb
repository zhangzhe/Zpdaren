class Admins::JobsController < Admins::BaseController

  def index
    @jobs = Job.approved
  end

  def edit
    @job = Job.find(params[:id])
  end

  def show
    @job = Job.find(params[:id])
  end

  def update
    job = Job.update(params[:id], job_params)
    job.publish
    job.save
    redircet_to admins_jobs_path
  end

  private
  def job_params
    params.require(:job).permit(:title, :description)
  end
end
