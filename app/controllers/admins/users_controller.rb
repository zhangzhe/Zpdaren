class Admins::UsersController < Admins::BaseController

  def index
    if params[:type] == 'Recruiter'
      @companies = Company.active.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    elsif params[:type] == 'Supplier'
      @suppliers = Supplier.all.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    else
      @users = User.all.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    end
  end
end
