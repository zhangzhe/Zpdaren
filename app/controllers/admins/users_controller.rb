class Admins::UsersController < Admins::BaseController

  def index
    if params[:type] == 'Company'
      @q = Company.ransack(params[:q])
      @companies = @q.result(distinct: true)
      @companies = @companies.joins(:recruiter).active.paginate(page: params[:page], per_page: Settings.pagination.page_size)
      render 'recruiters'
    elsif params[:type] == 'Supplier'
      @q = Supplier.ransack(params[:q])
      @suppliers = @q.result(distinct: true)
      @suppliers = @suppliers.paginate(page: params[:page], per_page: Settings.pagination.page_size)
      render 'suppliers'
    else
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true)
      @users = @users.paginate(page: params[:page], per_page: Settings.pagination.page_size)
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
