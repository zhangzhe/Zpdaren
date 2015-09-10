class User < ActiveRecord::Base
  devise :database_authenticatable
  has_one :weixin

  def receive(pay)
    if self.wallet
      self.wallet.update_attribute(:money, self.wallet.money + pay)
    else
      self.wallet = Wallet.create!({money: pay})
    end
  end

  def weixin_name
    weixin.user_name
  end
end
