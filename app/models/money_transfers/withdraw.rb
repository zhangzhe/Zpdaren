class Withdraw < MoneyTransfer
  validates_length_of :mobile, is: 11

  def previous_withdraw
    self.wallet.withdraws.try(:last)
  end
end
