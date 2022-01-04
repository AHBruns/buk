class ConnectCellsAndItems < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :items, :cell, foreign_key: true

    add_index :items, [:cell_id, :index], unique: true
  end
end
