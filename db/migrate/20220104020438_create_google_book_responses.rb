class CreateGoogleBookResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :google_book_requests do |t|
      t.string :isbn, null: false
      t.jsonb :response, null: false

      t.timestamps

      t.index :isbn, unique: true
    end
  end
end
