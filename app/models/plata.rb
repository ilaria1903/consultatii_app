class Plata < ApplicationRecord
  self.table_name = 'plata'
  self.primary_key = 'id_plata'

  belongs_to :consultatie, foreign_key: 'id_consultatie'
  belongs_to :platitor, class_name: "Utilizator", foreign_key: "id_platitor", primary_key: "cnp"


  validates :suma, numericality: { greater_than: 0 }
  validates :metoda_plata, inclusion: { in: %w[card transfer cash] }
  validates :status_plata, inclusion: { in: %w[in_asteptare platita esec] }
end
