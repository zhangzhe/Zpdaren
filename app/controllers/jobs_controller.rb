class JobsController < ApplicationController
  def show
    @job = Job.find(params[:id])
    @similar_jobs = @job.similar_jobs
    render layout: 'anonymous_jobs'
  end
end
