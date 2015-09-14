class Wallet < ActiveRecord::Base
  belongs_to :supplier, foreign_key: :user_id
  belongs_to :admin, foreign_key: :user_id

  def update_money(operator, value)
    self.update_attribute(:money, self.money.send(operator.to_sym, value))
  end
end