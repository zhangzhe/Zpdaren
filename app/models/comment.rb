class Comment < ActiveRecord::Base
  belongs_to :interview
  validates_presence_of :content
  before_save :set_default_commenter_name
  acts_as_tree order: 'created_at DESC'
  acts_as_paranoid

  def from_professor?
    self.commenter_id == self.interview.professor_id
  end

  private
  def set_default_commenter_name
    self.commenter_name = "匿名用户" if self.commenter_name.blank?
  end
end
