class Suppliers::JobsController < Suppliers::BaseController
  layout "suppliers"

  def index
    if params[:key].present?
      @jobs = Job.approved.where("title ilike ?", "%#{params[:key]}%")
    else
      @jobs = Job.approved
    end
    @jobs = @jobs.paginate(page: params[:page], per_page: Settings.pagination.page_size)
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
