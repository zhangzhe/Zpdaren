class Job < ActiveRecord::Base
  belongs_to :company
  has_many :deliveries
  has_many :resumes, through: :deliveries

  scope :pre_approved, -> { where("state = 'submitted' and deposit is not null")}
  scope :approved, -> { where('state' => 'approved')}

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

  def deposit
    (bonus * 0.2).to_i
  end

  def resumes_bonus_for(supplier)
    count = 0
    resumes_from(supplier).map(&:deliveries).flatten.each do |delivery|
      if delivery.paid?
        count += 1
      end
    end
    return (count * bonus_for_each_resume)
  end

  def resumes_count_from(supplier)
    resumes_from(supplier).count
  end

  def resumes_from(supplier)
    self.resumes.where(:supplier_id => supplier.id)
  end

  def bonus_for_each_resume
     (0.005 * deposit).to_i
  end

  def bonus_for_entry
     (bonus * 0.8).to_i
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
