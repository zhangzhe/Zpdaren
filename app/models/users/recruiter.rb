class Recruiter < User
  devise :registerable, :confirmable

  has_one :company, :foreign_key => :user_id
  has_many :jobs, :foreign_key => :user_id
  has_many :deliveries, through: :jobs

  delegate :name, :mobile, :url, :address, :description, to: :company, prefix: true
  delegate :money, to: :wallet, prefix: true

  after_create :init_blank_comapny
  before_destroy :destroy_all_association_entities

  DELIVERY_STATE_WHITE_LIST = ['available', 'viewed', 'final_paid', 'refused', 'outdated']

  JOB_STATE_WHITE_LIST = ['submitted', 'deposit_paid', 'deposit_paid_confirmed', 'final_payment_paid', 'finished']

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

  def available_deliveries
    unprocess_deliveries.joins(:resume).where("resumes.available = ?", true)
  end

  def outdated_deliveries
    unprocess_deliveries.joins(:resume).where("resumes.available = ?", false)
  end

  def viewed_deliveries
    resume_ids = self.deliveries.process.map(&:resume_id)
    self.deliveries.where("deliveries.state = 'paid' or (deliveries.resume_id in (?) and deliveries.read_at is not null and deliveries.state = 'approved')", resume_ids)
  end

  def final_paid_deliveries
    deliveries.final_paid
  end

  def refused_deliveries
    deliveries.recruiter_refused
  end

  def recruiter_watchable_deliveries_count
    self.jobs.map(&:recruiter_watchable_deliveries).flatten.count
  end

  def create_and_pay_final_payment_for!(delivery)
    ActiveRecord::Base.transaction do
      self.receive(delivery.job.bonus_for_entry)
      delivery.final_payment = FinalPayment.create!(:amount => delivery.job.bonus_for_entry, :wallet_id => self.wallet.id, :zhifubao_account => Admin::BANK_ACCOUNT)
      delivery.save!
      delivery.pay_final_payment!
    end
  end

  def find_deliveries_by_state(state, job_id=nil)
    deliveries = self.send("#{state}_deliveries")
    deliveries = deliveries.where(job_id: job_id) if job_id.present?
    deliveries
  end

  def find_deliveries_count_by_state(state, job_id=nil)
    find_deliveries_by_state(state, job_id).count
  end

  def delivery_state_is_legal?(state)
    DELIVERY_STATE_WHITE_LIST.include?((state || '').downcase)
  end

  def find_jobs_by_state(state)
    self.jobs.send(state.downcase)
  end

  def find_jobs_count_by_state(state)
    find_jobs_by_state(state).count
  end

  def job_state_is_legal?(state)
    JOB_STATE_WHITE_LIST.include?((state || '').downcase)
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
