class Drawing < ActiveRecord::Base
  belongs_to :supplier
  has_one :wallet, through: :supplier
  scope :waiting_approved, -> { where('state' => 'submitted')}

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
      '请求已提交'
    when :agreed
      '同意'
    when :refused
      '拒绝'
    end
  end
end
