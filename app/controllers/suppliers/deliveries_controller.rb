class Suppliers::DeliveriesController < Suppliers::BaseController

  def index
    @deliveries = current_supplier.deliveries.joins(:job)
    if params[:key]
      recruiter_ids = Company.where("name like ?", "%#{params[:key]}%").map(&:user_id)
      @deliveries = @deliveries.where("user_id in (?)", recruiter_ids)
    end
    @deliveries = @deliveries.order("#{params[:sort]} #{params[:direction]}")
    @deliveries = @deliveries.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def new
    @job = Job.find(params[:job_id])
    @resume = Resume.find(params[:resume_id])
    @delivery = Delivery.new
  end

  def create
    begin
      @delivery = Delivery.new(delivery_params)
      unless @delivery.save
        @job = Job.find(delivery_params[:job_id])
        @resume = Resume.find(delivery_params[:resume_id])
        flash[:error] = @delivery.errors.full_messages.first
        render 'new' and return
      end
    rescue ActiveRecord::RecordNotUnique
    end
    flash[:success] = "操作完成！"
    redirect_to suppliers_job_path(id: params[:delivery][:job_id])
  end

  private
  def delivery_params
    params.require(:delivery).permit(:job_id, :resume_id, :message)
  end
end