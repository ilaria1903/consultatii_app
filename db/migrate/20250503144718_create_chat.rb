class CreateChat < ActiveRecord::Migration[7.1]
  def change
    create_table :chat do |t|
      t.integer :consultatie_id, null: false
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end

    add_foreign_key :chat, :consultatie
    add_index :chat, :consultatie_id, unique: true
  end
end
