class Partner <ActiveRecord::Base
  validates_presence_of :name, :logo
  validates_length_of :name, maximum: 50

  default_scope { order(created_at: :asc) }

  mount_uploader :logo, AvatarUploader
  mount_uploader :qrcode, AvatarUploader
end
