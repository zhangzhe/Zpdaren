class Delivery < ActiveRecord::Base
  belongs_to :job
  belongs_to :resume
  has_one :rejection
  belongs_to :final_payment, :foreign_key => :final_payment_id

  delegate :id, :candidate_name, :tag_list, :mobile, :email, :message, to: :resume, prefix: true
  delegate :id, :title, :user_id, :bonus, :description, :tag_list, to: :job, prefix: true
  delegate :reason, :other, to: :rejection, prefix: true

  validates_length_of :message, maximum: 50

  scope :paid, -> { where(state: 'paid') }
  scope :recommended, -> { where(state: 'recommended') }
  scope :waiting_approved, -> { where(state: 'recommended') }

  scope :process, -> { where("deliveries.state in ('paid', 'refused', 'final_payment_paid', 'finished')") }
  scope :approved, -> { where('deliveries.state' => 'approved') }
  scope :after_approved, -> { where.not(state: 'recommended') }
  scope :recruiter_watchable, -> { where("deliveries.state not in ('recommended', 'refused') or (deliveries.state = 'refused' and deliveries.read_at is not null)") }
  scope :approved_today, -> { where('DATE(deliveries.updated_at) = ? and deliveries.state = ?', Date.today, 'approved') }
  scope :after_paid, -> { where("deliveries.state in ('paid', 'final_payment_paid', 'finished')") }
  scope :final_paid, -> { where("deliveries.state in ('final_payment_paid', 'finished')") }
  scope :paid_today, -> { where('DATE(deliveries.updated_at) = ? and deliveries.state = ?', Date.today, 'paid') }
  scope :paid_yesterday, -> { where('DATE(deliveries.updated_at) = ? and deliveries.state = ?', 1.day.ago.to_date, 'paid') }
  scope :paid_the_day_before_yesterday, -> { where('DATE(deliveries.updated_at) = ? and deliveries.state = ?', 2.day.ago.to_date, 'paid') }
  scope :refused, -> { where(state: 'refused') }
  scope :max_priority, -> { joins(:job).where("jobs.priority = 1") }

  default_scope { order('updated_at DESC') }

  extend Statistics

  acts_as_paranoid
  include AASM
  aasm.attribute_name :state
  aasm do
    state :recommended, :initial => true
    state :approved
    state :paid
    state :refused
    state :final_payment_paid
    state :finished

    event :approve, :after => :notify_recruiter_and_supplier do
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
      after do
        notify_supplier_refused
      end
      transitions :from => [:recommended, :approved], :to => :refused
    end

    event :pay_final_payment do
      after do
        sync_job
        transfer_final_payment_to_admin
      end
      transitions :from => [:approved, :paid], :to => :final_payment_paid
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

  class << self
    def order_by_state
      select("deliveries.*, case when state='recommended' then 1 else 0 end as state_level").order("state_level desc")
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
    ['approved', 'paid'].include?(self.state) && self.final_payment.nil? && self.ever_paid? && !ever_final_payment_paid_or_finished?
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

  def ever_final_payment_paid_or_finished?
    self.resume.deliveries.each do |delivery|
      return true if (delivery.final_payment_paid? || delivery.finished?) && (delivery.recruiter_id == self.recruiter.id)
    end
    false
  end

  def ever_paid_or_final_payment_paid_or_finished?
    ever_paid? || ever_final_payment_paid_or_finished?
  end

  def recruiter_id
    job_user_id
  end

  def money_earned
    if self.paid?
      return self.job.bonus_for_each_resume/2
    elsif self.finished?
       return (self.job.bonus_for_each_resume/2 + job.bonus_for_entry)
    end
  end

  def may_pay_or_refuse?
    self.job.deposit_paid_confirmed? and !self.ever_paid_or_final_payment_paid_or_finished? and !self.refused?
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
    Weixin.notify_supplier_deposit_paid(self) if supplier.weixin
  end

  # FIXME: refactor dupplicate code
  def notify_supplier_final_payment_paid
    Weixin.notify_supplier_final_payment_paid(self) if supplier.weixin
  end

  def transfer_deposit
    bonus = job.bonus_for_each_resume
    ActiveRecord::Base.transaction do
      Admin.admin.pay(bonus/2)
      if job.deposit >= bonus
        job.update_attributes(:deposit => job.deposit - bonus)
      else
        raise "您的押金已用完，请联系管理员"
      end
      supplier.receive(bonus/2)
    end
  end

  def notify_recruiter_and_supplier
    RecruiterMailer.resume_recommended(recruiter, self).deliver_now
    Weixin.notify_resume_approved(self) if self.resume.supplier.weixin
  end

  def notify_supplier_refused
    Weixin.send_resume_refused_notification(self) if self.resume.supplier.weixin
  end
end
