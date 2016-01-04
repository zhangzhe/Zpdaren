class JobsController < ApplicationController

  def index
    if params[:state] == 'high_priority'
      @jobs = Job.available.high_priority
    else
      @jobs = Job.available
    end
    @jobs = @jobs.tagged_with(params[:tag]) if params[:tag]
    @jobs = @jobs.where("title ilike ?", "%#{params[:key]}%").paginate(page: params[:page], per_page: Settings.pagination.page_size)
    tags = Job.tag_counts_on(:tags).order('taggings_count DESC')
    @priority_tags = tags.where(:priority => 1)
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
