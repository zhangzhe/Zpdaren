class Recruiters::RefuseReasonsController < Recruiters::BaseController

  def create
    refuse_reason = RefuseReason.create(refuse_reason_params)
    redirect_to recruiters_delivery_path(refuse_reason.delivery)
  end

  private
  def refuse_reason_params
    params.require(:refuse_reason).permit!
  end
end
