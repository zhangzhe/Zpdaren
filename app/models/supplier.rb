class Supplier < User
  devise :database_authenticatable, :registerable, :trackable, :validatable, :recoverable
  has_many :resumes

  has_one :wallet, foreign_key: :user_id
end
