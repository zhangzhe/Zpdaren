class Job < ActiveRecord::Base
  belongs_to :company
  has_many :deliveries
  has_many :resumes, through: :deliveries

  include AASM
  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :approved
    state :finished

    event :publish do
      # debugger
      transitions :from => :submitted, :to => :approved
    end

    event :complete do
      transitions :from => :approved, :to => :finished
    end
  end

  def company_name
    company.name
  end

  def company_description
    company.description
  end

  def delivery!(resume)
    Delivery.create(:resume_id => resume.id, :job_id => self.id)
  end

  def view_pay(pay)
    if self.deposit < pay
      return '余额不足'
    else
      return self.update_attribute(:deposit, self.deposit - pay)
    end
  end

end
