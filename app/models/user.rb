class User < ActiveRecord::Base
  devise :database_authenticatable

  def receive(pay)
    if self.wallet
      self.wallet.update_attribute(:money, self.wallet.money + pay)
    else
      self.wallet = Wallet.create!({money: pay})
    end
  end
end
