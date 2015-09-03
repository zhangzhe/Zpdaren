class Resume < ActiveRecord::Base
  has_many :deliveries
  has_many :jobs, through: :deliveries
  belongs_to :supplier
  scope :active, -> { where('checked' => true) }

  validates_presence_of :candidate_name, :attachment


  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  mount_uploader :attachment, FileUploader
end
