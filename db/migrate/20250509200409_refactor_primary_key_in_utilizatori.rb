class RefactorPrimaryKeyInUtilizatori < ActiveRecord::Migration[8.0]
  def up
    execute "ALTER TABLE setari_profil DROP CONSTRAINT IF EXISTS fk_rails_2298fcd625"
    execute "ALTER TABLE timp_liber_medics DROP CONSTRAINT IF EXISTS fk_rails_dfec3ff5cd"
    execute "ALTER TABLE disponibilitate_medic DROP CONSTRAINT IF EXISTS fk_rails_412a738c4a"
    execute "ALTER TABLE programari DROP CONSTRAINT IF EXISTS fk_rails_23a5287b1e"
    execute "ALTER TABLE programari DROP CONSTRAINT IF EXISTS fk_rails_6c5c9ded8e"
    execute "ALTER TABLE mesaj DROP CONSTRAINT IF EXISTS fk_rails_26c37d94c0"
    execute "ALTER TABLE fisier DROP CONSTRAINT IF EXISTS fk_rails_0d4e94b3cd"
    execute "ALTER TABLE plata DROP CONSTRAINT IF EXISTS fk_rails_8456f0854b"
    execute "ALTER TABLE notificare DROP CONSTRAINT IF EXISTS fk_rails_408ef5d2a9"

    # Scoate cheia primară veche
    execute "ALTER TABLE utilizatori DROP CONSTRAINT IF EXISTS utilizatori_pkey CASCADE"

    # Adaugă coloana id doar dacă nu există deja
    unless column_exists?(:utilizatori, :id)
      add_column :utilizatori, :id, :primary_key
    end

    # Asigură-te că id e cheia primară
    execute "ALTER TABLE utilizatori ADD PRIMARY KEY (id)"
  end

  def down
    # rollback opțional
  end
end
