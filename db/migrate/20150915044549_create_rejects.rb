class CreateRejects < ActiveRecord::Migration
  def change
    create_table :rejects do |t|
      t.integer :delivery_id
      t.string :reason
      t.text :other

      t.timestamps
    end
  end
end
