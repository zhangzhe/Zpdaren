class Admin < User
  devise :database_authenticatable, :trackable

  BANK_ACCOUNT = '11054701040001271'

  def self.admin
    self.first
  end
end
