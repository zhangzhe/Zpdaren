class Suppliers::DeliveriesController < Suppliers::BaseController
  layout 'suppliers'

  def index
    @deliveries = current_supplier.deliveries
  end

  def new
    @job = Job.find(params[:job_id])
    @resumes = current_supplier.resumes
  end

  def create
    Delivery.create!(delivery_params)
    redirect_to suppliers_job_path(id: params[:delivery][:job_id])
  end

  private

  def delivery_params
    params.require(:delivery).permit(:job_id, :resume_id)
  end
end