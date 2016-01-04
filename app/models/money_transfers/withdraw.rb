class Withdraw < MoneyTransfer
  has_one :user, through: :wallet

  delegate :email, to: :user, prefix: true

  validates_presence_of :zhifubao_account, :mobile, :amount

  def previous_withdraw
    self.wallet.withdraws.try(:last)
  end
end
