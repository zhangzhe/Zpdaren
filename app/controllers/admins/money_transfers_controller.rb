class Admins::MoneyTransfersController < Admins::BaseController
  def index
  end

  def deposits
    @deposits = Deposit.all.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    render :layout => 'admins_deposit_and_draw'
  end

  def final_payments
    @final_payments = FinalPayment.all.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    render :layout => 'admins_deposit_and_draw'
  end

  def withdraws
    @withdraws = Withdraw.all.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    render :layout => 'admins_deposit_and_draw'
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
