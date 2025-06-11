class DisponibilitateMedic < ApplicationRecord
  self.table_name = 'disponibilitate_medic'
  self.primary_key = 'id_disponibilitate'

  belongs_to :utilizator, foreign_key: "utilizator_id"



  validates:zi_saptamana, inclusion: { in: 0..6 }
  validates :utilizator_id, presence: true
end
