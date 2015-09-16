class CreateRejections < ActiveRecord::Migration
  def change
    create_table :rejections do |t|
      t.integer :delivery_id
      t.string :reason
      t.text :other

      t.timestamps
    end
  end
end
