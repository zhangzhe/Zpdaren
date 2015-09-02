class Resume < ActiveRecord::Base
  has_many :deliveries
  has_many :jobs, through: :deliveries

  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  mount_uploader :attachment, FileUploader
end
