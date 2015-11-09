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

  def destroy
    user = User.find(params[:id])
    if user.is_a?(Supplier)
      user.recover_supplier
    elsif user.is_a?(Recruiter)
      user.recover_recruiter
    end
    flash[:success] = '删除成功！'
    redirect_to admins_users_path(type: user.type)
  end
end
