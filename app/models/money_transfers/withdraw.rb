class Withdraw < MoneyTransfer

  validates_presence_of :zhifubao_account, :mobile, :amount

  def previous_withdraw
    self.wallet.withdraws.try(:last)
  end
end
