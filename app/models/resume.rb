class Resume < ActiveRecord::Base
  has_many :deliveries
  has_many :jobs, through: :deliveries
  belongs_to :supplier
  validates_presence_of :candidate_name, :mobile, :tag_list
  # validates_presence_of :email, :description, on: :update
  validates_presence_of :attachment, message: '不能为空'
  validates_length_of :candidate_name, maximum: 10
  validates_uniqueness_of :mobile, :email, message: '系统中已经存在，请上选择其他候选人'
  validates_length_of :mobile, is: 11

  scope :waiting_approved, -> { where('state' => 'submitted')}

  acts_as_taggable
  acts_as_taggable_on :skills, :interests
  mount_uploader :attachment, FileUploader

  include SimilarEntity
  include AASM
  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :approved

    event :approve , :after => :notify_recruiter_and_supplier_and_auto_deliver do
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

  def auto_deliver
    matching_jobs.each do |job|
      job.delivery!(self) if (self.auto_delivery? && !Delivery.find_by_resume_id_and_job_id(self.id, job.id))
    end
  end

  def matching_jobs
    similar_entity(Job)
  end

  private
  def notify_recruiter_and_supplier_and_auto_deliver
    # set approved
    deliveries.each do |deliver|
      deliver.approve!
    end
    # email for recruiter
    deliveries.each do |deliver|
      deliver.notify_recruiter
    end
    # weixin for supplier
    Weixin.notify_resume_approved(self) if self.supplier.weixin
    auto_deliver
  end
end
