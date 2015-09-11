class RefundRequest < ActiveRecord::Base
  belongs_to :job
  delegate :title, :bonus, :description, :created_at, to: :job, prefix: true
  default_scope { order('created_at DESC') }

  include AASM
  aasm.attribute_name :state

  aasm do
    state :submitted, :initial => true
    state :agreed
    state :refused

    event :agree do
      transitions :from => :submitted, :to => :agreed
    end

    event :refuse do
      transitions :from => :submitted, :to => :refused
    end
  end

  def state_show
    case self.state.to_sym
    when :submitted
      '等待审批'
    when :agreed
      #TODO
      '完成退款'
    when :refused
      '申请被拒绝'
    end
  end
end
