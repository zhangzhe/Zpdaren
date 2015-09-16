class Recruiters::RefusesController < Recruiters::BaseController

  def new
    @delivery = Delivery.find(params[:delivery_id])
  end

  def create
    refuse = Refuse.create(refuse_params)
    if refuse.errors.any?
      flash[:error] = refuse.errors.messages[:reason]
      redirect_to :back
    else
      delivery = refuse.delivery
      delivery.refuse! if delivery.recommended? && delivery.may_refuse?
      redirect_to recruiters_delivery_path(delivery)
    end
  end

  private
  def refuse_params
    params.require(:refuse).permit!
  end
end
