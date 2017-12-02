class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.string :description
      t.integer :amount, default: 0
      t.integer :balance, default: 0

      t.timestamps
    end
  end
end
