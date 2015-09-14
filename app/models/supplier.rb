class Supplier < User
  devise :database_authenticatable, :registerable, :trackable, :validatable, :recoverable
  has_many :resumes
  has_many :deliveries, through: :resumes
  has_many :attentions
  has_many :drawings
  has_many :final_payment_requests

  delegate :money, to: :wallet, prefix: true

  def watch!(job)
    self.attentions.create!(job_id: job.id)
  end
end
