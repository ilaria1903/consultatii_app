class CreateFisier < ActiveRecord::Migration[7.1]
  def change
    create_table :fisier, id: false do |t|
      t.primary_key :id_fisier
      t.integer :id_chat, null: false
      t.string :id_utilizator, null: false
      t.string :nume_fisier, null: false
      t.text :file_url, null: false
      t.string :file_type
      t.datetime :upload_time, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_foreign_key :fisier, :chat, column: :id_chat, primary_key: :id_chat
    add_foreign_key :fisier, :utilizatori, column: :id_utilizator, primary_key: :cnp
  end
end
