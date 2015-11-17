class Deposit < MoneyTransfer
  belongs_to :job

  acts_as_paranoid
end
