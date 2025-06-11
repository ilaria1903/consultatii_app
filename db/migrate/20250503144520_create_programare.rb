class CreateProgramare < ActiveRecord::Migration[7.1]
  def change
    create_table :programari do |t|
      t.string :pacient_id, null: false
      t.string :medic_id, null: false
      t.date :data_programare, null: false
      t.time :ora_programare, null: false
      t.string :status, null: false, default: "pending"
      t.text :motiv

      t.timestamps
    end

    add_foreign_key :programari, :utilizatori, column: :pacient_id, primary_key: :cnp
    add_foreign_key :programari, :utilizatori, column: :medic_id, primary_key: :cnp
    add_index :programari, [:pacient_id, :medic_id, :data_programare, :ora_programare], unique: true
  end
end
