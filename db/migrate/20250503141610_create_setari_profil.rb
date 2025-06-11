class CreateSetariProfil < ActiveRecord::Migration[7.1]
  def change
    create_table :setari_profil do |t|
      t.string :utilizator_id, null: false
      t.string :gen
      t.text :istoric_diagnostic
      t.text :alergii

      t.timestamps
    end

    add_foreign_key :setari_profil, :utilizatori, column: :utilizator_id, primary_key: :cnp
    add_index :setari_profil, :utilizator_id, unique: true
  end
end
