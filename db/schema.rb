# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_06_221234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chat", primary_key: "id_chat", id: :bigint, default: -> { "nextval('chat_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "id_consultatie", null: false
    t.datetime "chat_inceput_la"
    t.datetime "chat_incheiat_la"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status_chat", default: "activ", null: false
    t.index ["id_consultatie"], name: "index_chat_on_id_consultatie", unique: true
  end

  create_table "consultatie", primary_key: "id_consultatie", id: :bigint, default: -> { "nextval('consultatie_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "id_programare", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.integer "durata_minute", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_programare"], name: "index_consultatie_on_id_programare", unique: true
  end

  create_table "disponibilitate_medic", force: :cascade do |t|
    t.bigint "utilizator_id", null: false
    t.integer "zi_saptamana", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "ora_start"
    t.index ["utilizator_id", "zi_saptamana"], name: "index_disponibilitate_medic_on_utilizator_id_and_zi_saptamana", unique: true
  end

  create_table "fisier", primary_key: "id_fisier", force: :cascade do |t|
    t.integer "id_chat", null: false
    t.bigint "id_utilizator", null: false
    t.string "nume_fisier", null: false
    t.text "file_url", null: false
    t.string "file_type"
    t.datetime "upload_time", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mesaj", primary_key: "id_mesaj", id: :bigint, default: -> { "nextval('mesaj_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "id_chat", null: false
    t.bigint "id_sender", null: false
    t.text "continut"
    t.datetime "trimis_la", null: false
    t.string "tip_continut", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notificare", primary_key: "id_notificare", force: :cascade do |t|
    t.bigint "id_utilizator", null: false
    t.text "continut_notificare", null: false
    t.datetime "data_trimitere", default: -> { "CURRENT_TIMESTAMP" }
    t.boolean "citita", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plata", primary_key: "id_plata", force: :cascade do |t|
    t.integer "id_consultatie", null: false
    t.bigint "id_platitor", null: false
    t.decimal "suma", null: false
    t.string "metoda_plata", null: false
    t.string "status_plata", default: "in_asteptare", null: false
    t.datetime "data_plata", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_consultatie"], name: "index_plata_on_id_consultatie", unique: true
    t.check_constraint "metoda_plata::text = ANY (ARRAY['card'::character varying, 'transfer'::character varying, 'cash'::character varying]::text[])", name: "metoda_valida"
    t.check_constraint "suma > 0::numeric", name: "suma_pozitiva"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "twitter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programari", force: :cascade do |t|
    t.bigint "pacient_id", null: false
    t.bigint "medic_id", null: false
    t.date "data_programare", null: false
    t.time "ora_programare", null: false
    t.string "status", default: "pending", null: false
    t.text "motiv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pacient_id", "medic_id", "data_programare", "ora_programare"], name: "idx_on_pacient_id_medic_id_data_programare_ora_prog_2dff9ea6ef", unique: true
  end

  create_table "recenzie", primary_key: "id_recenzie", force: :cascade do |t|
    t.integer "id_consultatie", null: false
    t.integer "nr_stele", null: false
    t.datetime "rating_creat_la", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_consultatie"], name: "index_recenzie_on_id_consultatie", unique: true
    t.check_constraint "nr_stele >= 1 AND nr_stele <= 5", name: "stele_check"
  end

  create_table "roluri", force: :cascade do |t|
    t.string "nume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "setari_profil", force: :cascade do |t|
    t.bigint "utilizator_id", null: false
    t.string "gen"
    t.text "istoric_diagnostic"
    t.text "alergii"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["utilizator_id"], name: "index_setari_profil_on_utilizator_id", unique: true
  end

  create_table "specializari", force: :cascade do |t|
    t.string "nume", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timp_liber_medics", force: :cascade do |t|
    t.bigint "utilizator_id"
    t.date "zi"
    t.text "motiv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["utilizator_id", "zi"], name: "index_timp_liber_medics_on_utilizator_id_and_zi", unique: true
  end

  create_table "utilizatori", force: :cascade do |t|
    t.string "cnp", null: false
    t.text "email", null: false
    t.string "nume", limit: 20, null: false
    t.string "prenume", limit: 20, null: false
    t.date "data_inregistrare", default: -> { "CURRENT_DATE" }
    t.integer "rol_id", null: false
    t.date "data_nasterii"
    t.boolean "activ", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.integer "specializare_id"
    t.index ["cnp"], name: "index_utilizatori_on_cnp", unique: true
  end

  create_table "video", primary_key: "id_video", force: :cascade do |t|
    t.integer "id_consultatie", null: false
    t.text "url_video", null: false
    t.datetime "video_inceput_la", null: false
    t.datetime "video_incheiat_la"
    t.string "status_video", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_consultatie"], name: "index_video_on_id_consultatie", unique: true
  end

  add_foreign_key "chat", "consultatie", column: "id_consultatie", primary_key: "id_consultatie"
  add_foreign_key "consultatie", "programari", column: "id_programare"
  add_foreign_key "disponibilitate_medic", "utilizatori", column: "utilizator_id", on_delete: :cascade
  add_foreign_key "fisier", "chat", column: "id_chat", primary_key: "id_chat"
  add_foreign_key "fisier", "utilizatori", column: "id_utilizator", on_delete: :cascade
  add_foreign_key "mesaj", "chat", column: "id_chat", primary_key: "id_chat"
  add_foreign_key "mesaj", "utilizatori", column: "id_sender", on_delete: :cascade
  add_foreign_key "notificare", "utilizatori", column: "id_utilizator", on_delete: :cascade
  add_foreign_key "plata", "consultatie", column: "id_consultatie", primary_key: "id_consultatie"
  add_foreign_key "plata", "utilizatori", column: "id_platitor", on_delete: :cascade
  add_foreign_key "programari", "utilizatori", column: "medic_id", on_delete: :cascade
  add_foreign_key "programari", "utilizatori", column: "pacient_id", on_delete: :cascade
  add_foreign_key "recenzie", "consultatie", column: "id_consultatie", primary_key: "id_consultatie"
  add_foreign_key "setari_profil", "utilizatori", column: "utilizator_id", on_delete: :cascade
  add_foreign_key "timp_liber_medics", "utilizatori", column: "utilizator_id", on_delete: :cascade
  add_foreign_key "utilizatori", "roluri", column: "rol_id"
  add_foreign_key "utilizatori", "specializari", column: "specializare_id"
  add_foreign_key "video", "consultatie", column: "id_consultatie", primary_key: "id_consultatie"
end
