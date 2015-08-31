class Company < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id
end
