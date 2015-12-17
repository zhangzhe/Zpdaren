class Recruiters::RejectionsController < Recruiters::BaseController

  def new
    @delivery = current_recruiter.deliveries.find(params[:delivery_id])
  end

  def create
    rejection = Rejection.create(rejection_params)
    if rejection.errors.any?
      flash[:error] = rejection.errors.full_messages.first
      redirect_to :back and return
    end
    delivery = rejection.delivery
    delivery.refuse!
    redirect_to recruiters_deliveries_path
  end

  private
  def rejection_params
    params.require(:rejection).permit!
  end
end
