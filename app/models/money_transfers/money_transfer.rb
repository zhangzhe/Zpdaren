class MoneyTransfer < ActiveRecord::Base
  belongs_to :wallet
  default_scope { order('created_at DESC') }

  strip_attributes
  include AASM

  aasm.attribute_name :state

  aasm do
    state :submitted, :initial => true
    state :finished

    event :go do
      transitions :from => :submitted, :to => :finished
    end
  end

  def state_show
    case state
    when "submitted"
      "提交"
    when "finished"
      "完成"
    end
  end
end
