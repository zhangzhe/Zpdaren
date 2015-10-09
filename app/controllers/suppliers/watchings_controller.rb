class Suppliers::WatchingsController < Suppliers::BaseController

  def create
    Watching.create!(watching_params)
    redirect_to :back
  end

  private
  def watching_params
    params.require(:watching).permit(:job_id, :supplier_id)
  end
end
