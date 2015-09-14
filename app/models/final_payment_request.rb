class FinalPaymentRequest < ActiveRecord::Base
  belongs_to :job
  belongs_to :supplier

  include AASM
  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :paid

    event :pay do
      transitions :from => :submitted, :to => :paid
    end
  end
end