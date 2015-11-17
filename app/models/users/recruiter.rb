class Recruiter < User
  devise :registerable

  has_one :company, :foreign_key => :user_id
  has_many :jobs, :foreign_key => :user_id
  has_many :deliveries, through: :jobs
  after_create :init_blank_comapny
  before_destroy :destroy_all_association_entities

  include DataRecoverer

  def jobs_count
    self.jobs.available.count > 100 ? '99+' : self.jobs.count
  end

  def in_hiring_jobs_count
    self.jobs.in_hiring.count
  end

  def unprocess_deliveries_count
    unprocess_deliveries = []
    self.jobs.each do |job|
      unprocess_deliveries.push(job.unprocess_deliveries)
    end
    unprocess_deliveries.flatten.count
  end

  def recruiter_watchable_resumes_count
    self.jobs.map(&:recruiter_watchable_deliveries).flatten.count
  end

  def create_and_pay_final_payment_for!(delivery)
    ActiveRecord::Base.transaction do
      self.receive(delivery.job.bonus_for_entry)
      delivery.final_payment = FinalPayment.create!(:amount => delivery.job.bonus_for_entry, :wallet_id => self.wallet.id, :zhifubao_account => Admin.admin.bank_account)
      delivery.save!
      delivery.pay_final_payment!
    end
  end

  private
  def init_blank_comapny
    company = Company.create(:user_id => self.id)
    company.save(:validate => false)
  end

  def destroy_all_association_entities
    self.recruiter_recover
  end
end
