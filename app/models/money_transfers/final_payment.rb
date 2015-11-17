class FinalPayment < MoneyTransfer
  has_one :delivery

  acts_as_paranoid
end
