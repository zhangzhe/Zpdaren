class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.integer :amount
      t.integer :wallet_id
      t.string :state
      t.string :zhifubao_account

      t.timestamps null: false
    end
  end
end
