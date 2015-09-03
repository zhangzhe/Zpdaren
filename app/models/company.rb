class Company < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id
  has_many :jobs

  scope :active, -> { where.not('name' => nil) }
end
