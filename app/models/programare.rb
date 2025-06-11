class Programare < ApplicationRecord
  self.table_name = "programari"
  self.primary_key = "id"

  belongs_to :pacient, class_name: "Utilizator", foreign_key: "pacient_id"
  belongs_to :medic, class_name: "Utilizator", foreign_key: "medic_id"
 has_one :consultatie, foreign_key: "id_programare"


  validates :data_programare, presence: true
  validates :ora_programare, presence: true
  validates :status, presence: true
end
