class CreateDisponibilitateMedic < ActiveRecord::Migration[7.1]
  def change
    create_table :disponibilitate_medic do |t|
      t.string :utilizator_id, null: false
      t.integer :zi_saptamana, null: false  # 1 = luni, 2 = marți, ..., 5 = vineri

      t.timestamps
    end

    add_foreign_key :disponibilitate_medic, :utilizatori, column: :utilizator_id, primary_key: :cnp
    add_index :disponibilitate_medic, [:utilizator_id, :zi_saptamana], unique: true
  end
end
