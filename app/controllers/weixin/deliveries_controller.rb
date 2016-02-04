class Weixin::DeliveriesController < Weixin::BaseController
  def show
    @delivery = current_user.deliveries.find(params[:id])
  end
end