class CreateConsultatie < ActiveRecord::Migration[7.1]
  def change
    create_table :consultatie do |t|
      t.integer :programare_id, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.integer :durata_minute, null: false

      t.timestamps
    end

    add_foreign_key :consultatie, :programari, column: :programare_id
    add_index :consultatie, :programare_id, unique: true
  end
end
