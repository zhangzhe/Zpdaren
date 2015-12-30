class Deposit < MoneyTransfer
  belongs_to :job

  delegate :title, :description, to: :job, prefix: true

  acts_as_paranoid
end
