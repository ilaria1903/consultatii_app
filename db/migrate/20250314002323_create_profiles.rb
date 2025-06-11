class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :email
      t.string :twitter

      t.timestamps
    end
  end
end
