class AddIdColumnToUtilizatori < ActiveRecord::Migration[7.1]
  def change
    add_column :utilizatori, :id, :bigserial
  end
end
