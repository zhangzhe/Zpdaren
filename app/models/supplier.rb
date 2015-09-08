class Supplier < User
  devise :database_authenticatable, :registerable, :trackable, :validatable, :recoverable
  has_many :resumes
  has_many :attentions

  has_one :wallet, foreign_key: :user_id

  def attend(job)
    Attention.create!(supplier_id: self.id, job_id: job.id)
  end
end
