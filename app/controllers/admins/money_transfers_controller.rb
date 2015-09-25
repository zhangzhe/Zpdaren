class Admins::MoneyTransfersController < Admins::BaseController
  def index
    @deposits = Deposit.all
    @withdraws = Withdraw.all
    @final_payments = FinalPayment.all
  end

  def update
    money_transfer = MoneyTransfer.find(params[:id])

    ActiveRecord::Base.transaction do
      money_transfer.go!
      if money_transfer.type == "FinalPayment"
        money_transfer.delivery.complete!
      end
    end

    flash[:success] = "操作完成！"
    redirect_to :back
  end
end
