class MoneyTransfer < ActiveRecord::Base
  belongs_to :wallet
  include AASM
  scope :waiting_approved, -> { where('state' => 'submitted')}

  aasm.attribute_name :state

  aasm do
    state :submitted, :initial => true
    state :finished

    event :go do
      transitions :from => :submitted, :to => :finished
    end
  end
end
