class Recruiters::RejectionsController < Recruiters::BaseController

  def new
    @delivery = Delivery.find(params[:delivery_id])
  end

  def create
    rejection = Rejection.create(rejection_params)
    if rejection.errors.any?
      flash[:error] = rejection.errors.messages[:reason]
      redirect_to :back
    else
      delivery = rejection.delivery
      delivery.refuse!
      redirect_to recruiters_delivery_path(delivery)
    end
  end

  private
  def rejection_params
    params.require(:rejection).permit!
  end
end
