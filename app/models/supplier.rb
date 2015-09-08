class Supplier < User
  devise :database_authenticatable, :registerable, :trackable, :validatable, :recoverable
  has_many :resumes
  has_many :concerns

  has_one :wallet, foreign_key: :user_id

  def watch!(job)
    self.concerns.create!(job_id: job.id)
  end
end
