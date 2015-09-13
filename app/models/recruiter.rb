class Recruiter < User
  devise :database_authenticatable, :registerable, :trackable, :validatable, :recoverable

  has_one :company, :foreign_key => :user_id
  has_many :jobs, :foreign_key => :user_id
  before_create :init_blank_comapny

  def jobs_num
    self.jobs.available.count > 100 ? '99+' : self.jobs.count
  end

  def deliveries_num
    deliveries = []
    self.jobs.map do |job|
      deliveries << job.approved_deliveries unless job.deliveries.recommended.blank?
    end
    deliveries.flatten!
    deliveries.count > 100 ? '99+' : deliveries.count
  end

  private
  def init_blank_comapny
    create_company
  end
end
