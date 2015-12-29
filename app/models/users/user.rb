class User < ActiveRecord::Base
  has_one :weixin
  has_one :wallet
  default_scope { order('created_at DESC') }
  after_create :create_wallet
  devise :database_authenticatable, :validatable, :recoverable, :trackable

  def receive(money)
    self.wallet.update_attribute(:money, self.wallet.money.to_i + money)
  end

  def pay(money)
    if self.wallet.money.to_i >= money
      self.wallet.update_attribute(:money, self.wallet.money.to_i - money)
    else
      # FIXME: 显示具体错误
      raise "余额不足"
    end
  end

  def weixin_name
    weixin.user_name
  end

  def weixin_subscribable?
    self.type == "Supplier" && self.weixin.nil?
  end

  def name
    self.read_attribute("name") || email
  end
end
