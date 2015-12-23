class Job < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id
  has_one :company, through: :recruiter
  has_many :resumes, through: :deliveries
  has_many :deliveries do
    def any_available_for_final_payment?
      self.each do |delivery|
        return true if delivery.available_for_final_payment?
      end
      return false
    end
  end
  has_many :watchings
  has_many :suppliers, through: :watchings
  has_many :refund_requests

  validates_presence_of :title, :description, :bonus, :tag_list
  validates_length_of :title, maximum: 50
  validates_numericality_of :salary_min, only_integer: true, greater_than_or_equal_to: 0, less_than: 10000
  validates_numericality_of :salary_max, only_integer: true, greater_than_or_equal_to: :salary_min, less_than: 10000, if: Proc.new { |job| job.salary_min.is_a?(Integer) }
  validates_numericality_of :bonus, greater_than_or_equal_to: 1000, only_integer: true

  delegate :name, :id, :address, :mobile, :description, to: :company, prefix: true

  scope :submitted, -> { where('state' => 'submitted')}
  scope :deposit_paid, -> { where('state' => 'deposit_paid')}
  scope :deposit_paid_confirmed, -> { where('state' => 'deposit_paid_confirmed')}
  scope :final_payment_paid, -> { where('state' => 'final_payment_paid') }
  scope :finished, -> { where('state' => 'finished') }
  scope :available, -> { where('state in (?)', ['submitted', 'deposit_paid', 'deposit_paid_confirmed']) }
  scope :in_hiring, -> { where.not('state in (?)', ['submitted', 'finished', 'final_payment_paid']) }
  scope :un_hiring, -> { where('state in (?)', ['final_payment_paid', 'finished']) }
  scope :priority, lambda{ |key| where(priority: PRIORITY_LIST[key]) }

  default_scope { order(created_at: :desc) }

  before_destroy :destroy_all_association_entities

  extend Statistics

  strip_attributes
  acts_as_paranoid
  include SimilarEntity
  include DataRecoverer
  include AASM

  PRIORITY_LIST = { 'high' => 1, 'medium' => 2, 'low' => '3' }

  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :deposit_paid
    state :deposit_paid_confirmed
    state :final_payment_paid
    state :finished

    event :pay do
      transitions :from => :submitted, :to => :deposit_paid
    end

    event :confirm_deposit_paid, :after => :notify_recruiter_and_deliver_matching_resumes do
      transitions :from => :deposit_paid, :to => :deposit_paid_confirmed
    end
  end

  class << self
    def high_priority
      priority('high')
    end

    def deleted
      only_deleted
    end

    def find_by_admin(params)
      params[:state] = 'in_hiring' unless ['in_hiring', 'un_hiring', 'deleted', 'submitted', 'high_priority'].include?(params[:state])
      jobs = send(params[:state])
      jobs = jobs.where("title like ?", "%#{params[:key]}%") if params[:key].present?
      jobs
    end

    def find_by_recruiter(params, current_recruiter)
      params[:state] = 'submitted' unless ['submitted', 'deposit_paid', 'deposit_paid_confirmed', 'final_payment_paid', 'finished'].include?(params[:state])
      jobs = current_recruiter.jobs.send(params[:state])
      jobs = jobs.where("title like ?", "%#{params[:key]}%") if params[:key].present?
      jobs
    end

    def find_by_supplier(params)
      jobs = Job.available
      jobs = jobs.high_priority if params[:state] == 'high_priority'
      jobs = jobs.where("user_id = ? ", params[:recruiter_id]) if params[:recruiter_id]
      jobs = jobs.where("title ilike ?", "%#{params[:key]}%") if params[:key].present?
      jobs
    end
  end

  def state_show?
    self.deposit_paid? || self.final_payment_paid? || self.finished?
  end

  def self.high_priority_samples
    self.high_priority.shuffle[0..5]
  end

  def editable?
    ["submitted", "deposit_paid", "deposit_paid_confirmed"].include?(self.state)
  end

  def in_hiring?
    !['finished', 'final_payment_paid'].include?(self.state)
  end

  def viewed_deliveries
    resume_ids = recruiter.deliveries.process.map(&:resume_id)
    self.deliveries.where("deliveries.state = 'paid' or (deliveries.resume_id in (?) and deliveries.read_at is not null and deliveries.state = 'approved')", resume_ids)
  end

  def unprocess_deliveries
    self.deliveries.approved.unread
  end

  def recruiter_watchable_deliveries
    self.deliveries.recruiter_watchable
  end

  def resumes_count_from(supplier)
    resumes_from(supplier).count
  end

  def resumes_from(supplier)
    self.resumes.where(:supplier_id => supplier.id)
  end

  def deliveries_from(supplier)
    self.deliveries.where("resume_id in (?)", supplier.resumes.map {|resume| resume.id })
  end

  BONUS_RATE_FOR_EACH_RESUME = 0.01
  BONUS_RATE_FOR_ENTRY = 0.8
  DEPOSIT_RATE = 0.2
  def bonus_for_each_resume
    (BONUS_RATE_FOR_EACH_RESUME * bonus.to_i).to_i
  end

  def bonus_for_each_resume_for_supplier
    bonus_for_each_resume/2
  end

  def bonus_for_entry
    (bonus.to_i * BONUS_RATE_FOR_ENTRY).to_i
  end

  def original_deposit
    (bonus.to_i * DEPOSIT_RATE).to_i
  end

  def visible_resume_count
    self.deposit.present? ? (self.deposit / self.bonus_for_each_resume) : 0
  end

  def company
    recruiter.company
  end

  def company_name
    company.name
  end

  def company_description
    company.description
  end

  def delivery!(resume)
    Delivery.create(:resume_id => resume.id, :job_id => self.id) unless Delivery.find_by_resume_id_and_job_id(resume.id, self.id)
  end

  def watched_by?(supplier)
    suppliers.include?(supplier)
  end

  # def may_refund?
  #   (self.deposit_paid? || self.deposit_paid_confirmed?) && refund_requests.find_by_state(:submitted).nil?
  # end

  def deliver_matching_resumes
    matching_resumes.each do |resume|
      self.delivery!(resume) if resume.auto_delivery?
    end
  end

  def matching_resumes
    similar_entity(Resume)
  end

  def similar_jobs
    similar_entity(Job)
  end

  def update_and_notify_supplier!(job_params)
    self.attributes = job_params
    if self.changed? and self.save
      RecruiterMailer.job_updated(self).deliver_now
    end
  end

  def available_for_final_payment?
    self.deposit_paid_confirmed? && self.deliveries.any_available_for_final_payment?
  end

  def is_show_salary?
    self.salary_min? and self.salary_max? and self.salary_min > 0 and self.salary_max > 0
  end

  def all_kinds_of_deliveries_count
    all_kinds_of_deliveries = {}
    all_kinds_of_deliveries[:all_count] = self.deliveries.with_deleted.count
    all_kinds_of_deliveries[:after_approved_count] = self.deliveries.after_approved.count
    all_kinds_of_deliveries[:after_paid_count] = self.deliveries.after_paid.count
    all_kinds_of_deliveries[:refused_count] = self.deliveries.refused.count
    all_kinds_of_deliveries
  end

  def may_approve?
    self.deliveries.recommended.size > 0
  end

  def recommended_deliveries
    self.deliveries.recommended
  end

  def recommended_deliveries_count
    recommended_deliveries.count
  end

  def approved_deliveries
    self.deliveries.approved
  end

  def approved_deliveries_count
    approved_deliveries.count
  end

  private
  def notify_recruiter_and_deliver_matching_resumes
    RecruiterMailer.job_approved(recruiter, self).deliver_now
    deliver_matching_resumes
  end

  def destroy_all_association_entities
    self.job_recover
  end
end
