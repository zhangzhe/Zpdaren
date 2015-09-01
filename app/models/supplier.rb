class Supplier < User
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
end
