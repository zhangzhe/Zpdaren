class Suppliers::DeliveriesController < Suppliers::BaseController

  def index
    @deliveries = current_supplier.deliveries
  end

  def new
    @job = Job.find(params[:job_id])
    @resumes = current_supplier.resumes
  end

  def create
    resume = Resume.find(params[:delivery][:resume_id])
    delivery = Delivery.create!(delivery_params)
    delivery.update_attributes!(:approved => resume.approved?)
    flash[:success] = "操作完成！"
    redirect_to suppliers_job_path(id: params[:delivery][:job_id])
  end

  private
  def delivery_params
    params.require(:delivery).permit(:job_id, :resume_id)
  end
end