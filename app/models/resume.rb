class Resume < ActiveRecord::Base
  has_many :deliveries
  has_many :jobs, through: :deliveries
  belongs_to :supplier
  validates_presence_of :candidate_name, :mobile, :tag_list
  validates_presence_of :attachment, message: '不能为空'
  validates_length_of :candidate_name, maximum: 10
  validates_uniqueness_of :mobile, message: '系统中已经存在，请您选择其他候选人'
  after_create :auto_deliver
  default_scope { order("created_at DESC") }
  scope :completed, ->{ where("description is not null or pdf_attachment is not null") }
  scope :uncompleted, ->{ where("description is null and pdf_attachment is null") }
  scope :waiting_approved, ->{ where("description is null and pdf_attachment is null") }
  scope :unavailable, ->{ where(:available => false) }
  scope :available, ->{ where(:available => true) }
  scope :problemed, ->{ where("problem is not null") }


  accepts_nested_attributes_for :deliveries
  include SimilarEntity
  acts_as_taggable
  acts_as_taggable_on :skills, :interests
  mount_uploader :attachment, FileUploader
  mount_uploader :pdf_attachment, FileUploader
  strip_attributes

  def set_attachment_to_pdf_attachment(reuse_attachment)
    self.update_attribute(:pdf_attachment, self.attachment) if reuse_attachment == '1'
  end

  def resumes_from(supplier)
    self.resumes.where(:supplier_id => supplier.id)
  end

  def deliveried?(job)
    jobs.include?(job)
  end

  def is_pdf?
    self.attachment.file.file.end_with?('pdf')
  end

  def may_improve?
    self.description.blank? and self.pdf_attachment.blank? and self.available == nil
  end

  def recent_delivery_message
    self.deliveries.last.message if self.deliveries.try(:last)
  end

  def unavailable?
    available == false
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
