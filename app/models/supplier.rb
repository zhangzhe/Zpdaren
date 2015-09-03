class Supplier < User
  devise :database_authenticatable, :registerable, :trackable, :validatable
  has_many :resumes
end
