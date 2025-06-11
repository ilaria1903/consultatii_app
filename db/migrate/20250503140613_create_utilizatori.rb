class CreateUtilizatori < ActiveRecord::Migration[7.1]
  def change
    create_table :utilizatori, id: false do |t|
      t.string :cnp, primary_key: true
      t.text :email, null: false
      t.text :parola, null: false
      t.string :nume, null: false, limit: 20
      t.string :prenume, null: false, limit: 20
      t.date :data_inregistrare, default: -> { 'CURRENT_DATE' }
      t.integer :rol_id, null: false
      t.date :data_nasterii
      t.boolean :activ, default: true

      t.timestamps
    end

    add_foreign_key :utilizatori, :roluri, column: :rol_id
  end
end
