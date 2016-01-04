class Admins::MoneyTransfersController < Admins::BaseController
  def deposits
    @q = Deposit.ransack(params[:q])
    @deposits = @q.result(distinct: true)
    @deposits = @deposits.joins(:company, :job, :recruiter).paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def final_payments
    @q = FinalPayment.ransack(params[:q])
    @final_payments = @q.result(distinct: true)
    @final_payments = @final_payments.joins(:company, :job, :recruiter).paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def withdraws
    @q = Withdraw.ransack(params[:q])
    @withdraws = @q.result(distinct: true)
    @withdraws = @withdraws.joins(:user).paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def update
    money_transfer = MoneyTransfer.find(params[:id])
    money_transfer.confirm
    flash[:success] = "操作完成！"
    redirect_to :back
  end
end
