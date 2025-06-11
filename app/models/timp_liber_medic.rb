class TimpLiberMedic < ApplicationRecord
 self.table_name = "timp_liber_medics"
  self.primary_key = 'id_timp_liber'
  belongs_to :utilizator, foreign_key: "utilizator_id"



  validates :zi, presence: true
  validates :utilizator_id, presence: true
end
