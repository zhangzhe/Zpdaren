class Interview < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
end
