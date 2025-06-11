class AddUniqueIndexToCnpInUtilizatori < ActiveRecord::Migration[7.0]
  def change
    add_index :utilizatori, :cnp, unique: true
  end
end

