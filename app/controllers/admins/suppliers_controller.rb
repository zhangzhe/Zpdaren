class Admins::SuppliersController < Admins::BaseController

  def show
    @supplier = Supplier.find(params[:id])
  end
end