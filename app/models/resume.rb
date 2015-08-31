class Resume < ActiveRecord::Base
  mount_uploader :attachment, FileUploader
end