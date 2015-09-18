class Admins::MoneyTransfersController < Admins::BaseController
  def index
   @deposits = Deposit.all
   @withdraws = Withdraw.all
  end

  def update
    money_transfer = MoneyTransfer.find(params[:id])
    money_transfer.go!
    flash[:success] = "操作完成！"
    redirect_to :back
  end
end
