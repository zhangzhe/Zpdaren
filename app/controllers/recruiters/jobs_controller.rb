class Recruiters::JobsController < Recruiters::BaseController

  def index
    if current_recruiter.company.description.blank?
      redirect_to edit_recruiters_company_path(current_recruiter.company)
    else
      @jobs = current_recruiter.jobs
    end
  end

  def new
    @job = current_recruiter.jobs.build
  end

  def create
    job = current_recruiter.jobs.create!(job_params)
    redirect_to new_recruiters_deposit_path(:job_id => job.id)
  end

  def show
    @job = Job.find(params[:id])
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    job = Job.update(params[:id], job_params)
    redirect_to recruiters_jobs_path
  end

  def freeze
    job = Job.find(params[:id])
    job.freeze! if job.submitted? && job.may_freeze?
    redirect_to :back
  end

  def active
    job = Job.find(params[:id])
    job.active! if job.freezing? && job.may_active?
    redirect_to :back
  end

  private
  def job_params
    params[:job].permit(:title, :description, :bonus, :state, :tag_list)
  end
end
