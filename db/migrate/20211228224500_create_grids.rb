class CreateGrids < ActiveRecord::Migration[6.1]
  def change
    create_table :grids do |t|
      t.belongs_to :account, foreign_key: true
      t.string :name, null: false

      t.timestamps

      t.index [:account_id, :name], unique: true
    end
  end
end
