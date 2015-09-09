class Petition < ActiveRecord::Base
  belongs_to :job
  belongs_to :recruiter

  delegate :title, :bonus, :description, :created_at, to: :job, prefix: true

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
      '已提交'
    when :agreed
      '同意退款'
    when :refused
      '申请被拒绝'
    end
  end
end