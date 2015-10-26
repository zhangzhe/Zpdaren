class Withdraw < MoneyTransfer

  def previous_withdraw
    self.wallet.withdraws.try(:last)
  end
end
