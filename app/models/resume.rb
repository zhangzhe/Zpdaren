class Resume < ActiveRecord::Base
  has_many :deliveries
  has_many :jobs, through: :deliveries
  belongs_to :supplier

  validates_presence_of :candidate_name, :mobile, :attachment
  default_scope { order('created_at DESC') }

  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  mount_uploader :attachment, FileUploader

  include AASM
  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :approved

    event :approve , :after => :notify_recruiter_and_supplier do
      transitions :from => :submitted, :to => :approved
    end
  end

  def resume_bonus
    count = 0
    self.deliveries.paid.each do |delivery|
      count += delivery.job.bonus_for_each_resume
    end
    count
  end

  def resumes_from(supplier)
    self.resumes.where(:supplier_id => supplier.id)
  end

  def deliveried?(job)
    jobs.include?(job)
  end

  private
  def notify_recruiter_and_supplier
    # email for recruiter
    deliveries.each do |deliver|
      deliver.notify_recruiter
    end
    # weixin for supplier
    Weixin.notify_resume_approved(self) if self.supplier.weixin
  end
end
