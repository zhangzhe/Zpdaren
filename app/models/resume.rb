class Resume < ActiveRecord::Base
  has_many :deliveries
  has_many :jobs, through: :deliveries
  belongs_to :supplier
  validates_presence_of :candidate_name, :mobile, :tag_list
  validates_presence_of :attachment, message: '不能为空'
  validates_length_of :candidate_name, maximum: 10
  validates_uniqueness_of :mobile, :email, message: '系统中已经存在，请上选择其他候选人'
  validates_length_of :mobile, is: 11
  validates_length_of :message, maximum: 50

  after_create :auto_deliver

  extend DefaultValue
  include SimilarEntity

  acts_as_taggable
  acts_as_taggable_on :skills, :interests
  mount_uploader :attachment, FileUploader

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
  def auto_deliver
    matching_jobs.each do |job|
      job.delivery!(self) if (self.auto_delivery? && !Delivery.find_by_resume_id_and_job_id(self.id, job.id))
    end
  end

  def matching_jobs
    similar_entity(Job)
  end
end
