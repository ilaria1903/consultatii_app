class AddSpecializareIdToUtilizatori < ActiveRecord::Migration[7.0]
  def change
    add_column :utilizatori, :specializare_id, :integer
    add_foreign_key :utilizatori, :specializari, column: :specializare_id
  end
end
