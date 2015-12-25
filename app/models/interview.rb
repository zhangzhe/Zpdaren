class Interview < ActiveRecord::Base
  validates_presence_of :content, :avatar, :professor_name, :professor_title, :professor_brief, :brief
  has_many :comments
  mount_uploader :avatar, AvatarUploader

end
