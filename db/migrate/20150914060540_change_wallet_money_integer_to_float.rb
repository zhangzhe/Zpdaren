class ChangeWalletMoneyIntegerToFloat < ActiveRecord::Migration
  def change
    change_column :wallets, :money, :float, default: 0
    Wallet.where("money is null").each { |wallet| wallet.update_attribute(:money, 0) }
  end
end
