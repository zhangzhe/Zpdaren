class Admins::DeliveriesController < Admins::BaseController
  helper_method :sort_column

  def index
    if params[:job_id]
      @job = Job.find(params[:job_id])
      @deliveries = @job.deliveries
      @approved_deliveries = @deliveries.after_approved.order("created_at DESC")
      @recommended_deliveries = @deliveries.recommended.order("created_at DESC")
    else
      @deliveries = Delivery.joins(:job)
      if params[:supplier_id]
        supplier = Supplier.find(params[:supplier_id])
        @deliveries = supplier.deliveries
      end
      if params[:key]
        recruiter_ids = Company.where("name like ?", "%#{params[:key]}%").map(&:user_id)
        @deliveries = @deliveries.where("user_id in (?)", recruiter_ids)
      end
      if params[:state] == "submitted"
        @deliveries = @deliveries.recommended
      elsif params[:state] == "approved"
        @deliveries = @deliveries.approved
      elsif params[:state] == "paid"
        @deliveries = @deliveries.paid
      elsif params[:state] == "final_paid"
        @deliveries = @deliveries.final_paid
      elsif params[:state] == "improper"
        @deliveries = Delivery.improper
      end
      @deliveries = @deliveries.order("created_at DESC").paginate(page: params[:page], per_page: Settings.pagination.page_size)
    end
  end

  def edit
    @job = Job.find(params[:job_id])
    @delivery = @job.deliveries.find(params[:id])
  end

  def update
    @job = Job.find(params[:job_id])
    @delivery = @job.deliveries.find(params[:id])
    if @delivery.resume.may_improve?
      flash[:error] = "简历信息不完整，先去简历列表完善简历吧！"
      render 'edit' and return
    end
    if @delivery.update_attributes(delivery_params)
      @delivery.approve!
      flash[:success] = "审核完成！"
    end
    redirect_to admins_job_deliveries_path(:job_id => @delivery.job)
  end

  private
  def sort_column
    params[:sort] if Delivery.column_names.include?(params[:sort])
  end

  def delivery_params
    params.require(:delivery).permit(:message)
  end
end
