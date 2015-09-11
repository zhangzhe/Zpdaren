class Company < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id

  scope :active, -> { where.not('name' => nil) }
  default_scope { order('created_at DESC') }
end
