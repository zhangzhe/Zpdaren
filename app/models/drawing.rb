class Drawing < ActiveRecord::Base
  belongs_to :supplier
  has_one :wallet, through: :supplier

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

  def review!(opt)
    if opt == 'agree'
      self.agree! if self.submitted? && self.may_agree?
    elsif opt == 'refuse'
      if self.submitted? && self.may_refuse?
        self.refuse!
        wallet.update_attribute(:money, self.money)
      end
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