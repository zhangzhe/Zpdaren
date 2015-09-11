class Admin < User
  devise :database_authenticatable, :trackable

  def self.admin
    self.first
  end
end
