class JobsController < ApplicationController

  def index
    if params[:state] == 'high_priority'
      @jobs = Job.available.high_priority
    else
      @jobs = Job.available
    end
    @jobs = @jobs.where("title ilike ?", "%#{params[:key]}%").paginate(page: params[:page], per_page: Settings.pagination.page_size)
    render layout: 'anonymous_jobs'
  end

  def show
    @job = Job.find(params[:id])
    @similar_jobs = @job.similar_jobs
    render layout: 'anonymous_job'
  end

  def preview
    @description = params[:description]

    respond_to do |format|
      format.json
    end
  end
end
