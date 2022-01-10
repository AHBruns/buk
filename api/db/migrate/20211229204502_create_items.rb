class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.belongs_to :account, foreign_key: true
      t.integer :index, null: false

      t.timestamps
    end
  end
end
