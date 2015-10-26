class Resume < ActiveRecord::Base
  has_many :deliveries
  has_many :jobs, through: :deliveries
  belongs_to :supplier
  validates_presence_of :candidate_name, :mobile, :tag_list
  validates_presence_of :attachment, message: '不能为空'
  validates_length_of :candidate_name, maximum: 10
  validates_uniqueness_of :mobile, message: '系统中已经存在，请上选择其他候选人'
  validates_length_of :mobile, is: 11
  after_create :auto_deliver
  default_scope { order("created_at DESC") }

  include SimilarEntity
  acts_as_taggable
  acts_as_taggable_on :skills, :interests
  mount_uploader :attachment, FileUploader

  def resumes_from(supplier)
    self.resumes.where(:supplier_id => supplier.id)
  end

  def deliveried?(job)
    jobs.include?(job)
  end

  private
  def auto_deliver
    matching_jobs.each do |job|
      job.delivery!(self) if self.auto_delivery?
    end
  end

  def matching_jobs
    similar_entity(Job)
  end
end
