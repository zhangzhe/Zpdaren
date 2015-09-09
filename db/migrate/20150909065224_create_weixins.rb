class CreateWeixins < ActiveRecord::Migration
  def change
    create_table :weixins do |t|
      t.string :user_name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
