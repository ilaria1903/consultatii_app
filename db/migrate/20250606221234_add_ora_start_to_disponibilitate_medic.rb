class AddOraStartToDisponibilitateMedic < ActiveRecord::Migration[8.0]
  def change
    add_column :disponibilitate_medic, :ora_start, :time
  end
end
