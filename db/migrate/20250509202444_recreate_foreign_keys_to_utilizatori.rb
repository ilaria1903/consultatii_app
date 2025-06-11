class RecreateForeignKeysToUtilizatori < ActiveRecord::Migration[7.0]
  def change
    # === SETARI PROFIL ===
    add_foreign_key :setari_profil, :utilizatori, column: :utilizator_id, primary_key: :id, on_delete: :cascade

    # === TIMP LIBER MEDIC ===
    add_foreign_key :timp_liber_medics, :utilizatori, column: :utilizator_id, primary_key: :id, on_delete: :cascade

    # === DISPONIBILITATE MEDIC ===
    add_foreign_key :disponibilitate_medic, :utilizatori, column: :utilizator_id, primary_key: :id, on_delete: :cascade

    # === PROGRAMARE ===
    add_foreign_key :programari, :utilizatori, column: :pacient_id, primary_key: :id, on_delete: :cascade
    add_foreign_key :programari, :utilizatori, column: :medic_id, primary_key: :id, on_delete: :cascade

    # === MESAJE ===
    add_foreign_key :mesaj, :utilizatori, column: :id_sender, primary_key: :id, on_delete: :cascade

    # === FISIER ===
    add_foreign_key :fisier, :utilizatori, column: :id_utilizator, primary_key: :id, on_delete: :cascade

    # === PLATA ===
    add_foreign_key :plata, :utilizatori, column: :id_platitor, primary_key: :id, on_delete: :cascade

    # === NOTIFICARE ===
    add_foreign_key :notificare, :utilizatori, column: :id_utilizator, primary_key: :id, on_delete: :cascade
  end
end
