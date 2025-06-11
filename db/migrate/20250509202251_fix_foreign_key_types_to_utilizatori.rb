class FixForeignKeyTypesToUtilizatori < ActiveRecord::Migration[7.0]
  def change
    change_column :setari_profil, :utilizator_id, :bigint, using: 'utilizator_id::bigint'
    change_column :timp_liber_medics, :utilizator_id, :bigint, using: 'utilizator_id::bigint'
    change_column :disponibilitate_medic, :utilizator_id, :bigint, using: 'utilizator_id::bigint'
    change_column :programari, :pacient_id, :bigint, using: 'pacient_id::bigint'
    change_column :programari, :medic_id, :bigint, using: 'medic_id::bigint'
    change_column :mesaj, :id_sender, :bigint, using: 'id_sender::bigint'
    change_column :fisier, :id_utilizator, :bigint, using: 'id_utilizator::bigint'
    change_column :plata, :id_platitor, :bigint, using: 'id_platitor::bigint'
    change_column :notificare, :id_utilizator, :bigint, using: 'id_utilizator::bigint'
  end
end
