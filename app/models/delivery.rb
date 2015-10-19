class Delivery < ActiveRecord::Base
  belongs_to :job
  belongs_to :resume
  has_one :rejection
  belongs_to :final_payment, :foreign_key => :final_payment_id

  delegate :id, :candidate_name, :tag_list, :mobile, :email, :message, to: :resume, prefix: true
  delegate :id, :title, :user_id, to: :job, prefix: true
  delegate :reason, :other, to: :rejection, prefix: true

  scope :paid, -> { where(state: 'paid') }
  scope :recommended, -> { where(state: 'recommended') }
  scope :waiting_approved, -> { where(state: 'recommended') }

  scope :unread, -> { where('read_at' => nil, 'state' => 'approved') }
  scope :approved, -> { where('state' => 'approved') }

  include AASM
  aasm.attribute_name :state
  aasm do
    state :recommended, :initial => true
    state :approved
    state :paid
    state :refused
    state :final_payment_paid
    state :finished

    event :approve, :after => :notify_recruiter_and_supplier_and_auto_pay do
      transitions :from => :recommended, :to => :approved
    end

    event :pay do
      after do
        notify_supplier_deposit_paid
        transfer_deposit
      end
      transitions :from => :approved, :to => :paid
    end

    event :refuse do
      transitions :from => :approved, :to => :refused
    end

    event :pay_final_payment do
      after do
        sync_job
        transfer_final_payment_to_admin
      end
      transitions :from => :paid, :to => :final_payment_paid
    end

    event :complete do
      after do
        sync_job
        transfer_final_payment_to_supplier
        notify_supplier_final_payment_paid
      end
      transitions :from => :final_payment_paid, :to => :finished
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

  def candidate_brief
    "#{self.resume_candidate_name}: (#{self.resume_tag_list})"
  end

  def description
    resume.description
  end

  def recruiter
    job.recruiter
  end

  def supplier
    resume.supplier
  end

  def available_for_final_payment?
    self.final_payment.nil? && self.ever_paid?
  end

  def ever_paid?
    self.resume.deliveries.each do |delivery|
      return true if delivery.paid_by?(recruiter)
    end
    false
  end

  def paid_by?(recruiter)
    self.paid? && recruiter_id == recruiter.id
  end

  def recruiter_id
    job_user_id
  end

  private
  def sync_job
    job.state = self.state
    job.save!
  end

  def transfer_final_payment_to_admin
    bonus = job.bonus_for_entry
    ActiveRecord::Base.transaction do
      recruiter.pay(bonus)
      Admin.admin.receive(bonus)
    end
  end

  def transfer_final_payment_to_supplier
    bonus = job.bonus_for_entry
    ActiveRecord::Base.transaction do
      Admin.admin.pay(bonus)
      supplier.receive(bonus)
    end
  end

  def notify_supplier_deposit_paid
    Weixin.notify_supplier_deposit_paid(self.resume, self.job) if supplier.weixin
  end

  # FIXME: refactor dupplicate code
  def notify_supplier_final_payment_paid
    Weixin.notify_supplier_final_payment_paid(self.resume, self.job) if supplier.weixin
  end

  def transfer_deposit
    bonus = job.bonus_for_each_resume
    ActiveRecord::Base.transaction do
      Admin.admin.pay(bonus)
      supplier.receive(bonus)
    end
  end

  def notify_recruiter_and_supplier_and_auto_pay
    RecruiterMailer.resume_recommended(recruiter, self).deliver_now
    Weixin.notify_resume_approved(self.resume) if self.resume.supplier.weixin
  end
end
