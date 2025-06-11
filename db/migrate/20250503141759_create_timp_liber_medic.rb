class CreateTimpLiberMedic < ActiveRecord::Migration[7.1]

  def change
    create_table :timp_liber_medics do |t|
      t.string :utilizator_id
      t.date :zi
      t.text :motiv

      t.timestamps
    end
  end
end
