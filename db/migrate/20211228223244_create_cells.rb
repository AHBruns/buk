class CreateCells < ActiveRecord::Migration[6.1]
  def change
    create_table :cells do |t|
      t.belongs_to :account, foreign_key: true
      t.integer :x, null: false
      t.integer :y, null: false

      t.timestamps
    end
  end
end
