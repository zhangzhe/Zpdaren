class Admins::SuppliersController < Admins::BaseController

  def index
    @suppliers = Supplier.all
  end
end
