class FinalPayment < MoneyTransfer
  has_one :delivery
  has_one :job, through: :delivery
  has_one :recruiter, through: :job
  has_one :company, through: :recruiter

  acts_as_paranoid
end
