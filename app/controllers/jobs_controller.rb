class JobsController < ApplicationController
  def show
    @job = Job.find(params[:id])
    @similar_jobs = @job.similar_jobs
    render layout: 'anonymous_job'
  end

  def index
    @jobs = Job.available
    @jobs = @jobs.max_priority if params[:state] == 'max_priority'
    @jobs = @jobs.where("user_id = ? ", params[:recruiter_id]) if params[:recruiter_id]
    @jobs = @jobs.where("title ilike ?", "%#{params[:key]}%") if params[:key].present?
    @jobs = @jobs.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    render layout: 'anonymous_jobs'
  end

  def preview
    @description = params[:description]

    respond_to do |format|
      format.json
    end
  end
end
