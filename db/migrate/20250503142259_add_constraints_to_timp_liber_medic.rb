class AddConstraintsToTimpLiberMedic < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :timp_liber_medics, :utilizatori, column: :utilizator_id, primary_key: :cnp
    add_index :timp_liber_medics, [:utilizator_id, :zi], unique: true
  end
end
