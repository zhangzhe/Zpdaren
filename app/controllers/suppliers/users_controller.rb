class Suppliers::UsersController < Suppliers::BaseController

  def update
    current_supplier.mobile = supplier_params[:mobile]
    if current_supplier.save
      flash[:success] = '修改成功'
      redirect_to suppliers_path
    else
      flash[:error] = current_supplier.errors.full_messages.first
      redirect_to suppliers_path
    end
  end

  private

  def supplier_params
    params.require(:supplier).permit(:mobile)
  end
end