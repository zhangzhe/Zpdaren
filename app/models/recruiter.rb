class Recruiter < User
  devise :database_authenticatable, :registerable, :trackable, :validatable, :recoverable

  has_one :company, :foreign_key => :user_id
  has_many :jobs, :foreign_key => :user_id
  before_create :init_blank_comapny

  def jobs_count
    self.jobs.available.count > 100 ? '99+' : self.jobs.count
  end

  def in_hiring_jobs_count
    self.jobs.in_hiring.count
  end

  def unread_resumes_count
    self.jobs.map(&:unread_deliveries).flatten.count
  end

  def approved_resumes_count
    self.jobs.map(&:approved_deliveries).flatten.count
  end

  private
  def init_blank_comapny
    create_company
  end
end
