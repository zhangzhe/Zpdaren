class Suppliers::DrawingsController < ApplicationController
  layout 'suppliers'
  def index
    @drawings = current_supplier.drawings
  end

  def create
    current_supplier.wallet.update_attribute(:money, 0)
    current_supplier.drawings.create(drawing_params)
    redirect_to :back
  end

  private
  def drawing_params
    params.require(:drawing).permit(:money)
  end
end
