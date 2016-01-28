class Suppliers::DeliveriesController < Suppliers::BaseController

  def index
    params[:state] = 'recommended' unless current_supplier.delivery_state_is_legal?(params[:state])

    @q = current_supplier.find_deliveries_by_state(params[:state]).ransack(params[:q])
    @deliveries = @q.result(distinct: true)
    @deliveries = @deliveries.joins(:job, :resume, :company).paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def new
    @job = Job.find(params[:job_id])
    @resume = Resume.find(params[:resume_id])
    @delivery = Delivery.new
  end

  def create
    unless Delivery.find_by_resume_id_and_job_id(delivery_params[:resume_id], delivery_params[:job_id])
      if current_supplier.resumes.find(delivery_params[:resume_id]).problematic?
        flash[:error] = '该简历有问题，请修改后再推荐。'
        redirect_to :back and return
      end
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
