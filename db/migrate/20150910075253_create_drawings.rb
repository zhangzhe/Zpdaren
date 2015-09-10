class CreateDrawings < ActiveRecord::Migration
  def change
    create_table :drawings do |t|
      t.integer :supplier_id
      t.integer :money
      t.string :state

      t.timestamps
    end
  end
end
