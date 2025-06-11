class CreateRecenzie < ActiveRecord::Migration[7.1]
  def change
    create_table :recenzie, id: false do |t|
      t.primary_key :id_recenzie
      t.integer :id_consultatie, null: false
      t.integer :nr_stele, null: false
      t.datetime :rating_creat_la, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_foreign_key :recenzie, :consultatie, column: :id_consultatie, primary_key: :id_consultatie
    add_index :recenzie, :id_consultatie, unique: true
    execute "ALTER TABLE recenzie ADD CONSTRAINT stele_check CHECK (nr_stele BETWEEN 1 AND 5);"
  end
end
