class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.belongs_to :account, foreign_key: true
      t.string :isbn, null: false

      t.timestamps
    end
  end
end
