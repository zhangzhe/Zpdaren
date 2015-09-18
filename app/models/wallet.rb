class Wallet < ActiveRecord::Base
  belongs_to :user
  has_many :withdraws

  def update_money(operator, value)
    self.update_attribute(:money, self.money.send(operator.to_sym, value))
  end

  def build_withdraw_template
    self.withdraws.new(:amount => self.money.to_i, :zhifubao_account => zhifubao_account)
  end

  def create_withdraw_and_self_balance!(withdraw_params)
    ActiveRecord::Base.transaction do
      self.withdraws.create!(withdraw_params)
      self.update_attributes!(:money => self.money.to_i - withdraw_params[:amount].to_i)
    end
  end

  private
  def zhifubao_account
    if withdraw = self.withdraws.last
      withdraw.zhifubao_account
    end
  end
end
