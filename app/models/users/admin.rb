class Admin < User
  devise :database_authenticatable, :trackable

  def self.admin
    self.first
  end

  def bank_account
    "11054701040001271"
  end
end
