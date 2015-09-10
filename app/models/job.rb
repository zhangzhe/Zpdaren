class Job < ActiveRecord::Base
  belongs_to :company
  has_many :deliveries
  has_many :resumes, through: :deliveries
  has_many :attentions
  has_many :suppliers, through: :attentions
  has_many :petitions

  # scope :pre_approved, -> { where("state = 'submitted' and deposit is not null")}
  scope :deposit_paid, -> { where('state' => 'deposit_paid')}
  scope :approved, -> { where('state' => 'approved')}
  default_scope { order('created_at DESC') }

  include AASM
  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :deposit_paid
    state :approved
    state :finished
    state :freezing

    event :pay do
      transitions :from => :submitted, :to => :deposit_paid
    end

    event :freeze do
      transitions :from => [:submitted, :deposit_paid, :approved], :to => :freezing
    end

    event :active do
      transitions :from => :freezing, :to => :submitted
    end

    event :approve, :after => :notify_recruiter do
      transitions :from => :deposit_paid, :to => :approved
    end

    event :complete do
      transitions :from => :approved, :to => :finished
    end
  end

  def original_deposit
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

  def deliveries_from(supplier)
    self.deliveries.where("resume_id in (?)", supplier.resumes.map {|resume| resume.id })
  end

  def bonus_for_each_resume
    if deposit
     (0.005 * deposit).to_i
   else
     0
   end
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

  def watch_by?(supplier)
    suppliers.include?(supplier)
  end

  def view_pay(pay)
    if self.deposit < pay
      return '余额不足'
    else
      return self.update_attribute(:deposit, self.deposit - pay)
    end
  end

  def recruiter
    company.recruiter
  end

  def petition?
    (self.deposit_paid? || self.approved?) && petitions.find_by_state(:submitted).nil?
  end

  private
  def notify_recruiter
    RecruiterMailer.email_jd_approved(recruiter).deliver_now
  end
end
