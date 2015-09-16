class Delivery < ActiveRecord::Base
  belongs_to :job
  belongs_to :resume

  delegate :candidate_name, :tag_list, :mobile, :email, to: :resume, prefix: true
  delegate :id, :title, to: :job, prefix: true

  scope :paid, -> { where(state: 'paid') }
  scope :recommended, -> { where(state: 'recommended') }
  scope :unread, -> { where('read_at' => nil, 'approved' => true) }
  scope :approved, -> { where('approved' => true) }

  after_create :notify_recruiter, if: Proc.new { self.resume.approved? }
  default_scope { order('created_at DESC') }

  include AASM
  aasm.attribute_name :state
  aasm do
    state :recommended, :initial => true
    state :paid

    event :pay, :after => :notify_supplier_and_transfer_money do
      transitions :from => :recommended, :to => :paid
    end
  end

  def read!
    self.update_attribute(:read_at, Time.now)
  end

  def read?
    !unread?
  end

  def unread?
    read_at.blank?
  end

  def approve!
    self.update_attribute(:approved, true)
  end

  def candidate_name
    resume.candidate_name
  end

  def description
    resume.description
  end

  def notify_recruiter
    RecruiterMailer.email_resume_recommended(recruiter, self).deliver_now
  end

  def recruiter
    job.recruiter
  end

  private
  def notify_supplier_and_transfer_money
    notify_supplier
    transfer_money
  end

  def notify_supplier
    Weixin.notify_resume_paid(self) if resume.supplier.weixin
  end

  def transfer_money
    bonus = job.bonus_for_each_resume
    ActiveRecord::Base.transaction do
      resume.supplier.receive(bonus)
      recruiter.pay(bonus)
    end
  end
end
