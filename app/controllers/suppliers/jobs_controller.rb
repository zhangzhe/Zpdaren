class Suppliers::JobsController < Suppliers::BaseController
  layout "suppliers"

  def index
    @jobs = Job.approved

  end

  def show
    @job = Job.find(params[:id])
    @similar_jobs = @job.similar_jobs
    render layout: 'jobs'
  end

  def watch
    job = Job.find(params[:id])
    current_supplier.watch!(job)
    redirect_to :back
  end
end
