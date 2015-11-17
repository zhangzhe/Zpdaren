class RefundRequest < ActiveRecord::Base
  belongs_to :job
  delegate :title, :bonus, :description, :created_at, :deposit, to: :job, prefix: true
  default_scope { order('created_at DESC') }
  scope :waiting_approved, -> { where('state' => 'submitted')}

  strip_attributes
  acts_as_paranoid
  include AASM
  aasm.attribute_name :state

  aasm do
    state :submitted, :initial => true
    state :agreed
    state :refused

    event :agree, :after => :refund_to_recruiter do
      transitions :from => :submitted, :to => :agreed
    end

    event :refuse do
      transitions :from => :submitted, :to => :refused
    end
  end

  def state_show
    case self.state.to_sym
    when :submitted
      '等待退款'
    when :agreed
      #TODO
      '完成退款'
    when :refused
      '退款被拒绝'
    end
  end

  private

  def refund_to_recruiter
    ActiveRecord::Base.transaction do
      recruiter.receive(job.deposit)
      Admin.admin.pay(job.deposit)
    end
  end

  def recruiter
    self.job.recruiter
  end
end
