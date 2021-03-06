module WithdrawCore

  def new
    if current_user.wallet.money > 0
      qrcode_create if current_supplier and !current_supplier.weixin
      @withdraw = current_user.wallet.build_withdraw_template
    else
      flash[:error] = '您账户的余额为零，不能提现'
      redirect_to redirect_path
    end
  end

  def create
    if withdraw_params[:amount].to_i < 1 || withdraw_params[:amount].to_i > current_user.wallet.money.to_i
      flash[:error] = "请输入正确的金额!"
      redirect_to :back
    else
      current_user.wallet.create_withdraw_and_self_balance!(withdraw_params)
      flash[:success] = "提现成功，提现金额 #{withdraw_params[:amount]} 元会在一个工作日内打入您的支付宝账号，请注意查收。"
      redirect_to redirect_path
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "输入有误，请确认支付宝帐号、提现金额和手机号是否填写!"
    redirect_to :back
  end

  private

  def redirect_path
    case
    when current_recruiter
      recruiters_path
    when current_supplier
      suppliers_path
    end
  end

  def qrcode_create
    ticket = Weixin.qr_code_ticket(current_supplier.id)
    @qrcode_url = Weixin.qrcode_url(ticket)
  end

  def withdraw_params
    params[:withdraw].permit(:amount, :zhifubao_account, :mobile)
  end
end
