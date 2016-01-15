class Interview < ActiveRecord::Base
  validates_presence_of :content, :avatar, :professor_name, :professor_title, :brief
  has_many :comments
  belongs_to :professor
  mount_uploader :avatar, AvatarUploader
  acts_as_paranoid
  default_scope { order('updated_at DESC') }

  def available?
    (Time.now.to_i < reply_end_at.to_i) && (Time.now.to_i > reply_begin_at.to_i)
  end

  def questions_count
    comments.questions.count
  end
end
