class Partner <ActiveRecord::Base
  validates_presence_of :name, :logo
  validates_length_of :name, maximum: 50

  mount_uploader :logo, AvatarUploader
  mount_uploader :qrcode, AvatarUploader
end