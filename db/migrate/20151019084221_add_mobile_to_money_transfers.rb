class AddMobileToMoneyTransfers < ActiveRecord::Migration
  def change
    add_column :money_transfers, :mobile, :string
  end
end
