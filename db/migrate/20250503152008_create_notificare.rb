class CreateNotificare < ActiveRecord::Migration[7.1]
  def change
    create_table :notificare, id: false do |t|
      t.primary_key :id_notificare
      t.string :id_utilizator, null: false
      t.text :continut_notificare, null: false
      t.datetime :data_trimitere, default: -> { 'CURRENT_TIMESTAMP' }
      t.boolean :citita, default: false

      t.timestamps
    end

    add_foreign_key :notificare, :utilizatori, column: :id_utilizator, primary_key: :cnp
  end
end
