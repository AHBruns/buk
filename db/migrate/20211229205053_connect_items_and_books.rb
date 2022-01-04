class ConnectItemsAndBooks < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :items, :placeable, polymorphic: true, index: false

    add_index :items, [:placeable_type, :placeable_id], unique: true
  end
end
