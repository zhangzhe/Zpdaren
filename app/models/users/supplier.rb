class Supplier < User
  devise :registerable
  has_many :resumes
  has_many :deliveries, through: :resumes
  has_many :watchings
  delegate :money, to: :wallet, prefix: true

  include TestDataRecoverer
end
