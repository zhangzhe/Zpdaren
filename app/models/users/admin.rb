class Admin < User
  devise :database_authenticatable, :trackable

  def self.admin
    self.first
  end

  def zhifubao_account
    "11054701040001271  开户行：中国农业银行（北四环支行）"
  end
end
