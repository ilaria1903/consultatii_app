class CreatePlata < ActiveRecord::Migration[7.1]
  def change
    create_table :plata, id: false do |t|
      t.primary_key :id_plata
      t.integer :id_consultatie, null: false
      t.string :id_platitor, null: false
      t.decimal :suma, null: false
      t.string :metoda_plata, null: false
      t.string :status_plata, null: false, default: "in_asteptare"
      t.datetime :data_plata, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_foreign_key :plata, :consultatie, column: :id_consultatie, primary_key: :id_consultatie
    add_foreign_key :plata, :utilizatori, column: :id_platitor, primary_key: :cnp
    add_index :plata, :id_consultatie, unique: true

    execute "ALTER TABLE plata ADD CONSTRAINT suma_pozitiva CHECK (suma > 0);"
    execute "ALTER TABLE plata ADD CONSTRAINT metoda_valida CHECK (metoda_plata IN ('card', 'transfer', 'cash'));"
  end
end
