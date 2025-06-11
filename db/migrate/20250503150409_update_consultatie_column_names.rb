class UpdateConsultatieColumnNames < ActiveRecord::Migration[7.1]
  def change
    rename_column :consultatie, :id, :id_consultatie
    rename_column :consultatie, :programare_id, :id_programare
  end
end
