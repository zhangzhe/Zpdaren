class Deposit < MoneyTransfer
  belongs_to :job
  has_one :recruiter, through: :job
  has_one :company, through: :recruiter

  delegate :title, :description, to: :job, prefix: true
  delegate :email, to: :recruiter, prefix: true
  delegate :name, to: :company, prefix: true

  acts_as_paranoid
end
