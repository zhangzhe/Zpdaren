class Admins::MoneyTransfersController < Admins::BaseController
  def deposits
    @deposits = Deposit.joins(:job).all.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def final_payments
    @final_payments = FinalPayment.all.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def withdraws
    @withdraws = Withdraw.all.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def update
    money_transfer = MoneyTransfer.find(params[:id])
    money_transfer.confirm
    flash[:success] = "操作完成！"
    redirect_to :back
  end
end
