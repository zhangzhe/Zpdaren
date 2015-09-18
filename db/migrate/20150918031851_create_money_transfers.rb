class CreateMoneyTransfers < ActiveRecord::Migration
  def change
    create_table :money_transfers do |t|
      t.string :type
      t.integer :amount
      t.integer :wallet_id
      t.string :state
      t.string :zhifubao_account
      t.string :string

      t.timestamps null: false
    end
  end
end
