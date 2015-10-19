class Recruiter < User
  devise :database_authenticatable, :registerable, :trackable, :recoverable, :confirmable

  has_one :company, :foreign_key => :user_id
  has_many :jobs, :foreign_key => :user_id
  has_many :deliveries, through: :jobs
  after_create :init_blank_comapny

  def jobs_count
    self.jobs.available.count > 100 ? '99+' : self.jobs.count
  end

  def in_hiring_jobs_count
    self.jobs.in_hiring.count
  end

  def unprocess_resumes_count
    self.deliveries.where("resume_id not in (?)", self.deliveries.process.map(&:resume_id).uniq).count
  end

  def recruiter_watchable_resumes_count
    self.jobs.map(&:recruiter_watchable_deliveries).flatten.count
  end

  def create_and_pay_final_payment_for!(delivery)
    ActiveRecord::Base.transaction do
      self.receive(delivery.job.bonus_for_entry)
      delivery.final_payment = FinalPayment.create!(:amount => delivery.job.bonus_for_entry, :wallet_id => self.wallet.id, :zhifubao_account => Admin.admin.zhifubao_account)
      delivery.save!
      delivery.pay_final_payment!
    end
  end

  private
  def init_blank_comapny
    create_company
  end
end
