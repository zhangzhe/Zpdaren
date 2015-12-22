class Suppliers::DeliveriesController < Suppliers::BaseController

  def index
    @deliveries = Delivery.find_by_supplier(params, current_supplier)
    @deliveries = @deliveries.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def new
    @job = Job.find(params[:job_id])
    @resume = Resume.find(params[:resume_id])
    @delivery = Delivery.new
  end

  def create
    unless Delivery.find_by_resume_id_and_job_id(delivery_params[:resume_id], delivery_params[:job_id])
      @delivery = Delivery.create(delivery_params)
      if @delivery.errors.any?
        flash[:error] = @delivery.errors.full_messages.first
        redirect_to :back and return
      end
    else
      flash[:error] = '该简历已被推荐，请选择其他简历。'
      redirect_to select_list_suppliers_resumes_path(job_id: delivery_params[:job_id]) and return
    end
    flash[:success] = "简历推荐成功。我们会尽快审核，请耐心等待。"
    redirect_to current_supplier.weixin ? suppliers_job_path(id: params[:delivery][:job_id]) : suppliers_qr_code_path(current_supplier, job_id: params[:delivery][:job_id])
  end

  private
  def delivery_params
    params.require(:delivery).permit(:job_id, :resume_id, :message)
  end
end