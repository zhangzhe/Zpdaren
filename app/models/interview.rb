class Interview < ActiveRecord::Base
  validates_presence_of :content, :avatar, :professor_name, :professor_title,  :brief
  has_many :comments
  belongs_to :professor
  mount_uploader :avatar, AvatarUploader

end
