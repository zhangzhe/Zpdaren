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

  def unprocess_deliveries
    resume_ids = self.deliveries.process.map(&:resume_id)
    if resume_ids.present?
      self.deliveries.where("(resume_id not in (?) and deliveries.state = 'approved') or (resume_id in (?) and deliveries.state = 'approved' and read_at is null)", resume_ids, resume_ids)
    else
      self.deliveries.approved
    end
  end

  def unprocess_deliveries_count
    unprocess_deliveries.count
  end

  def viewed_deliveries
    resume_ids = self.deliveries.process.map(&:resume_id)
    self.deliveries.where("deliveries.state = 'paid' or (deliveries.resume_id in (?) and deliveries.read_at is not null and deliveries.state = 'approved')", resume_ids)
  end

  def viewed_deliveries_count
    viewed_deliveries.count
  end

  def paid_deliveries
    deliveries.paid
  end

  def paid_deliveries_count
    paid_deliveries.count
  end

  def final_paid_deliveries
    deliveries.final_paid
  end

  def final_paid_deliveries_count
    final_paid_deliveries.count
  end

  def refused_deliveries
    deliveries.refused
  end

  def refused_deliveries_count
    refused_deliveries.count
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
