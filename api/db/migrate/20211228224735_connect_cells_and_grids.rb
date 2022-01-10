class ConnectCellsAndGrids < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :cells, :grid, foreign_key: true

    add_index :cells, [:grid_id, :x, :y], unique: true
  end
end
