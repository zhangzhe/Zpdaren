class Supplier < User
  devise :database_authenticatable, :registerable, :trackable, :validatable
end
