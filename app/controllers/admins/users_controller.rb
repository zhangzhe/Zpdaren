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
    if user.destroy
      flash[:success] = '删除成功！'
    else
      flash[:error] = '程序异常，删除失败。'
    end
    redirect_to admins_users_path(type: user.type)
  end
end
