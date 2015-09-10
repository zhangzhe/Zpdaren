class Suppliers::JobsController < Suppliers::BaseController
  layout "suppliers"

  def index
    @jobs = Job.approved
  end

  def show
    @job = Job.find(params[:id])
    render layout: 'jobs'
  end

  def watch
    job = Job.find(params[:id])
    current_supplier.watch!(job)
    redirect_to :back
  end
end
