class CreateVideo < ActiveRecord::Migration[7.1]
  def change
    create_table :video, id: false do |t|
      t.primary_key :id_video
      t.integer :id_consultatie, null: false
      t.text :url_video, null: false
      t.datetime :video_inceput_la, null: false
      t.datetime :video_incheiat_la
      t.string :status_video, null: false, default: "pending"

      t.timestamps
    end

    add_foreign_key :video, :consultatie, column: :id_consultatie
    add_index :video, :id_consultatie, unique: true
  end
end
