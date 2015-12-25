class Comment < ActiveRecord::Base
  belongs_to :interview
  validates_presence_of :content
end
