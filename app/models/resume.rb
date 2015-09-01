class Resume < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  mount_uploader :attachment, FileUploader
end
