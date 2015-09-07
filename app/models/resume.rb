class Resume < ActiveRecord::Base
  has_many :deliveries
  has_many :jobs, through: :deliveries
  belongs_to :supplier
  scope :active, -> { where('review' => true) }

  validates_presence_of :candidate_name, :attachment


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

end
