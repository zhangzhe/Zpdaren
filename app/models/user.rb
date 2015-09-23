class User < ActiveRecord::Base
  devise :database_authenticatable
  has_one :weixin
  has_one :wallet
  default_scope { order('created_at DESC') }
  after_create :create_wallet

  def receive(money)
    self.wallet.update_attribute(:money, self.wallet.money.to_i + money)
  end

  def pay(money)
    if self.wallet.money.to_i > money
      self.wallet.update_attribute(:money, self.wallet.money.to_i - money)
    else
      # FIXME: 显示具体错误
<<<<<<< HEAD
      raise "余额不足"
=======
      # raise "余额不足"
>>>>>>> c6b88adc4821bd5c855451eb60403efb9b2a9021
    end
  end

  def weixin_name
    weixin.user_name
  end
end
