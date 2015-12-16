module WithdrawCore

  def new
    if current_user.wallet.money > 0
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
  def choose_layout
    case
    when current_recruiter
      self.class.layout 'recruiters'
    when current_supplier
      self.class.layout 'suppliers'
    end
  end

  def redirect_path
    case
    when current_recruiter
      recruiters_path
    when current_supplier
      suppliers_path
    end
  end

  def withdraw_params
    params[:withdraw].permit(:amount, :zhifubao_account, :mobile)
  end
end