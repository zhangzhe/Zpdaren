class CreateRefuseReasons < ActiveRecord::Migration
  def change
    create_table :refuse_reasons do |t|
      t.integer :delivery_id
      t.text :content

      t.timestamps
    end
  end
end
