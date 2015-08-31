class Recruiter < User
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_one :company, :foreign_key => :user_id
end
