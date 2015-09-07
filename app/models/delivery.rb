class Delivery < ActiveRecord::Base
  belongs_to :job
  belongs_to :resume

  delegate :review, :candidate_name, :tag_list, :mobile, :email, to: :resume, prefix: true
  delegate :title, to: :job, prefix: true

  scope :paid, -> { where(state: 'paid') }

  include AASM
  aasm.attribute_name :state
  aasm do
    state :recommended, :initial => true
    state :seen
    state :paid

    event :view do
      transitions :from => :recommended, :to => :seen
    end

    event :pay do
      transitions :from => :seen, :to => :paid
    end
  end

  def candidate_name
    resume.candidate_name
  end

  def description
    resume.description
  end
end
