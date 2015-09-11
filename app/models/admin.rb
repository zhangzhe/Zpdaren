class Admin < User
  devise :database_authenticatable, :trackable
end
