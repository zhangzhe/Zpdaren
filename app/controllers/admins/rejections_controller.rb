class Admins::RejectionsController < Admins::BaseController
  def new
    @delivery = Delivery.find(params[:delivery_id])
  end

  def create
    rejection = Rejection.create(rejection_params)
    if rejection.errors.any?
      flash[:error] = rejection.errors.full_messages.first
      redirect_to :back and return
    end
    delivery = rejection.delivery
    delivery.refuse!
    flash[:success] = '操作成功！'
    redirect_to admins_job_deliveries_path(:job_id => delivery.job.id, :state => 'submitted')
  end

  private
  def rejection_params
    params.require(:rejection).permit!
  end
end
