class Supplier < User
  devise :database_authenticatable, :registerable, :trackable, :validatable, :recoverable, :confirmable
  has_many :resumes
  has_many :deliveries, through: :resumes
  has_many :attentions
  delegate :money, to: :wallet, prefix: true

end
