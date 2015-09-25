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
  has_many :attentions
  has_many :suppliers, through: :attentions
  has_many :refund_requests

  validates_presence_of :title, :description, :bonus, :tag_list
  validates_length_of :title, maximum: 50
  validates_numericality_of :bonus, greater_than_or_equal_to: 1000

  delegate :name, :id, to: :company, prefix: true

  scope :deposit_paid, -> { where('state' => 'deposit_paid')}
  scope :approved, -> { where('state' => 'approved')}
  scope :available, -> { where('state in (?)', ['submitted', 'deposit_paid', 'approved']) }
  scope :in_hiring, -> { where.not('state in (?)', ['freezing', 'finished']) }

  extend DefaultValue
  include SimilarEntity
  include AASM

  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :deposit_paid
    state :approved
    state :final_payment_paid
    state :finished
    state :freezing

    event :pay do
      transitions :from => :submitted, :to => :deposit_paid
    end

    event :freeze do
      transitions :from => [:submitted, :deposit_paid, :approved], :to => :freezing
    end

    event :active do
      transitions :from => :freezing, :to => :submitted
    end

    event :approve, :after => :notify_recruiter_and_deliver_matching_resumes do
      transitions :from => :deposit_paid, :to => :approved
    end
  end

  def editable?
     !["final_payment_paid", "finished", "freezing"].include?(self.state)
  end

  def unread_deliveries
    self.deliveries.unread
  end

  def approved_deliveries
    self.deliveries.approved
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

  BONUS_RATE_FOR_EACH_RESUME = 0.005
  BONUS_RATE_FOR_ENTRY = 0.8
  DEPOSIT_RATE = 0.2
  def bonus_for_each_resume
    (BONUS_RATE_FOR_EACH_RESUME * bonus.to_i).to_i
  end

  def bonus_for_entry
    (bonus.to_i * BONUS_RATE_FOR_ENTRY).to_i
  end

  def original_deposit
    (bonus.to_i * DEPOSIT_RATE).to_i
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
    Delivery.create(:resume_id => resume.id, :job_id => self.id)
  end

  def watch_by?(supplier)
    suppliers.include?(supplier)
  end

  def view_pay(pay)
    if self.deposit < pay
      return '余额不足'
    else
      return self.update_attribute(:deposit, self.deposit - pay)
    end
  end

  def may_refund?
    (self.deposit_paid? || self.approved?) && refund_requests.find_by_state(:submitted).nil?
  end

  def deliver_matching_resumes
    matching_resumes.each do |resume|
      self.delivery!(resume) if (resume.auto_delivery? && !Delivery.find_by_resume_id_and_job_id(resume.id, self.id))
    end
  end

  def matching_resumes
    similar_entity(Resume)
  end

  def similar_jobs
    similar_entity(Job)
  end

  def update_and_approve!(job_params)
    self.attributes = job_params
    if self.changed? and self.save
      RecruiterMailer.edit_job_notify(self).deliver_now
    end
    self.approve!
  end

  def in_hiring?
    !['freezing', 'finished'].include?(self.state)
  end

  def available_for_final_payment?
    self.approved? && self.deliveries.any_available_for_final_payment?
  end

  def self.waiting_approved
    deposit_paid
  end

  private
  def notify_recruiter_and_deliver_matching_resumes
    RecruiterMailer.email_jd_approved(recruiter, self).deliver_now
    deliver_matching_resumes
  end
end
