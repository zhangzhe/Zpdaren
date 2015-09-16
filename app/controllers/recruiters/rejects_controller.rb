class Recruiters::RejectsController < Recruiters::BaseController

  def new
    @delivery = Delivery.find(params[:delivery_id])
  end

  def create
    reject = Reject.create(reject_params)
    if reject.errors.any?
      flash[:error] = reject.errors.messages[:reason]
      redirect_to :back
    else
      delivery = reject.delivery
      delivery.refuse! if delivery.recommended? && delivery.may_refuse?
      redirect_to recruiters_delivery_path(delivery)
    end
  end

  private
  def reject_params
    params.require(:reject).permit!
  end
end
