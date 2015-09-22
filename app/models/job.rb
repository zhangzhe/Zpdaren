class Job < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id
  has_one :final_payment_request
  has_one :company, through: :recruiter
  has_many :resumes, through: :deliveries
  has_many :deliveries
  has_many :attentions
  has_many :suppliers, through: :attentions
  has_many :refund_requests

  validates_presence_of :title, :description, :bonus, :tag_list
  validates_length_of :title, maximum: 20
  validates_numericality_of :bonus, greater_than_or_equal_to: 1000

  delegate :name, :id, to: :company, prefix: true

  scope :deposit_paid, -> { where('state' => 'deposit_paid')}
  scope :approved, -> { where('state' => 'approved')}
  scope :available, -> { where('state in (?)', ['submitted', 'deposit_paid', 'approved']) }
  scope :in_hiring, -> { where.not('state in (?)', ['freezing', 'finished']) }

  include SimilarEntity

  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  include AASM
  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :deposit_paid
    state :approved
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

    event :complete, :after => :pay_and_notify_supplier do
      transitions :from => :approved, :to => :finished
    end
  end

  class << self
    def waiting_approved
      deposit_paid
    end
  end

  def unread_deliveries
    self.deliveries.unread
  end

  def approved_deliveries
    self.deliveries.approved
  end

  def resumes_bonus_for(supplier)
    count = 0
    resumes_from(supplier).map(&:deliveries).flatten.each do |delivery|
      if delivery.paid?
        count += 1
      end
    end
    return (count * bonus_for_each_resume)
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

  def bonus_for_each_resume
    if bonus
      (0.005 * bonus).to_i
    else
      0
    end
  end

  def original_deposit
    (bonus * 0.2).to_i
  end

  def bonus_for_entry
    (bonus * 0.8).to_i
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

  def refund_request?
    (self.deposit_paid? || self.approved?) && refund_requests.find_by_state(:submitted).nil?
  end

  def pay_final_payment_to(supplier)
    self.final_payment_request = FinalPaymentRequest.create(supplier_id: supplier.id, money: self.bonus_for_entry)
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
    if self.changed? and self.save!
      RecruiterMailer.edit_job_notify(self).deliver_now
    end
    self.approve!
  end

  def in_hiring?
    !['freezing', 'finished'].include?(self.state)
  end

  private
  def notify_recruiter_and_deliver_matching_resumes
    RecruiterMailer.email_jd_approved(recruiter, self).deliver_now
    deliver_matching_resumes
  end

  def pay_and_notify_supplier
    # choose resume and pay the supplier
    # notify_supplier
  end
end
