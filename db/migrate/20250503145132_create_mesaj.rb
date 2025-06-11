class CreateMesaj < ActiveRecord::Migration[7.1]
  def change
    create_table :mesaj do |t|
      t.integer :chat_id, null: false
      t.string :sender_id, null: false
      t.text :content
      t.datetime :sent_at, null: false
      t.string :tip, null: false  # 'text' sau 'fisier'

      t.timestamps
    end

    add_foreign_key :mesaj, :chat
    add_foreign_key :mesaj, :utilizatori, column: :sender_id, primary_key: :cnp
  end
end
