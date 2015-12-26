class Comment < ActiveRecord::Base
  belongs_to :interview
  acts_as_tree order: 'created_at DESC'

  validates_presence_of :content
end
